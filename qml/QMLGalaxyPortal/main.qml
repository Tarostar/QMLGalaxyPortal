import QtQuick 2.3
import QtQuick.Window 2.2
import Qt.labs.settings 1.0

import "utils.js" as Utils

Rectangle {
    id: screen
    width: Screen.width
    height: Screen.height

    // Title and ID of any selected history and job item.
    property string currentHistory: ""
    property string currentHistoryID: ""
    property string currentJobID: ""

    // String of fields displayed on the flipped job items to store between sessions
    property string fieldList: "update_time,data_type,misc_blurb"
    property bool advancedFields: true;

    // Galaxy API key for the dataSource used to retrieve data for user.
    property string dataSource: "http://10.0.0.80"
    property string dataKey: "0f303101f8a957e35106c049f7ac38f9"
    property string passcode: ""
    property bool passcodeEnabled: false

    // Frequency of periodic polls (zero means no polling).
    property int periodicPolls: 0

    // Save settings.
    Settings {
        // Galaxy API settings.
        property alias dataKey: screen.dataKey
        property alias dataSource: screen.dataSource

        // Passcode settings.
        property alias passcode: screen.passcode
        property alias passcodeEnabled : screen.passcodeEnabled

        // Job item flip fields.
        property alias fieldList : screen.fieldList
        property alias advancedFields : screen.advancedFields

        // Currently viewed history and job.
        property alias currentHistory : screen.currentHistory
        property alias currentHistoryID : screen.currentHistoryID
        property alias currentJobID : screen.currentJobID

        // Polling frequency.
        property alias periodicPolls : screen.periodicPolls
    }

    // loader to spawn pages on top of list (e.g. for settings)
    Loader {  z: 1; id: mainLoader }

/*
    // test galaxy values
    property string dataKey: "48878f3f037cdc0c1be3157296e2c964"
    property string dataSource: "https://test.galaxyproject.org"
*/
    // https://usegalaxy.org (218afad6146272c7c771688e10fb9884)

    // Properties to manage different device resolutions and screen sizes (handled in utils.js).
    property var res: ["mdpi","hdpi","xhdpi", "xxhdpi"]
    property var devwidth: ["320", "480", "600", "1024", "1280", "1920", "2560"]
    readonly property int resIndex: Utils.getResolutionIndex(Screen.pixelDensity)
    readonly property int widthIndex: Utils.getScreenWidthIndex(Screen.width)
    property string imagePath: "qrc:/resources/resources/icons/" + res[resIndex] + "/"

    // Model for the list of histories (main list).
    JSONListModel {
        id: jsonHistoriesModel
        source: dataSource + "/api/histories?key=" + dataKey
        clearOnEmptyData: false
        pollInterval: screen.periodicPolls
    }

    // Model for the list of jobs in a selected history (source set when history selected).
    JSONListModel {
        id: jsonHistoryJobsModel
        clearOnEmptyData: false
        pollInterval: screen.periodicPolls
        source: screen.currentHistoryID.length > 0 ? dataSource + "/api/histories/" + screen.currentHistoryID + "/contents?key=" + dataKey : "";
    }

    JSONDataset {
        id: jsonHistoryJobContent
        source: screen.currentHistoryID.length > 0 ? dataSource + "/api/histories/" + screen.currentHistoryID + "/contents/datasets/" + screen.currentJobID + "?key=" + dataKey : "";
        pollInterval: screen.periodicPolls
    }

    PasscodeChallenge {
        id: challengeDialog
        visible: passcodeEnabled
        anchors.fill: parent
        onDone: {
          challengeDialog.visible = false;
        }
    }

    Rectangle {
        visible: (jsonHistoriesModel.count === 0 && screen.state === "")
        anchors.fill: parent
        Text {
            id: welcome
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: 10
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            text: "Welcome"
            font.pointSize: 12
            font.bold: true
        }
        Text {
            id: url
            anchors.top: welcome.bottom
            anchors.margins: 10
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
            text: "Current Galaxy URL: " + dataSource
            font.pointSize: 11
        }
        Text {
            id: instructions
            anchors.top: url.bottom
            anchors.margins: 10
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.WordWrap
            text: "Select the cog wheel on the right in the top action bar to configure."
            font.pointSize: 11
        }
        Text {
            id: userguide
            anchors.top: instructions.bottom
            anchors.topMargin: 30
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            text: "Download user guide:"
            font.pointSize: 11
        }
        Text {
            id: userguideURL
            anchors.top: userguide.bottom
            anchors.margins: 10
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            text: "<a href=\"https://github.com/Tarostar/QMLGalaxyPortal/blob/master/GalaxyPortalUserGuide.pdf?raw=true\">https://github.com/Tarostar/QMLGalaxyPortal/blob/master/GalaxyPortalUserGuide.pdf?raw=true</a>"
            font.pointSize: 9
        }
    }

    // Init view at startup.
    Component.onCompleted:{
        if (screen.currentHistoryID.length > 0) {
            screen.state = "historyItems";
            //jsonHistoryJobsModel.source = screen.currentHistoryID.length > 0 ? dataSource + "/api/histories/" + screen.currentHistoryID + "/contents?key=" + dataKey : "";
        }
    }

    Column {
        visible: !challengeDialog.visible
        anchors.fill: parent
        ActionBar {
            id: mainActionbar
            width: screen.width
            height: Screen.pixelDensity * 9
            // Settings button always visible.
            settingsButton.visible: true // screen.state === "" ? true : false
            // Back button only visible when possible to navigate back.
            backButton.visible: screen.state === "" ? false : true
            actionBarTitle: screen.state === "" ? "Galaxy Portal - " + jsonHistoriesModel.count + " items" :  currentHistory + " - " + jsonHistoryJobsModel.count + " items"
        }
        Row {
            id: screenlayout
            ListView {
                id: historyListView
                width: screen.width
                height: screen.height - mainActionbar.height
                model: jsonHistoriesModel.model
                delegate: HistoryDelegate {}
                clip: true
                boundsBehavior: Flickable.StopAtBounds
            }
            ListView {
                id: jobListItems
                width: screen.width
                height: screen.height - mainActionbar.height
                model: jsonHistoryJobsModel.model
                delegate: JobDelegate {}
                clip: true
                boundsBehavior: Flickable.StopAtBounds
            }

        }
    }
    transitions: Transition {
        NumberAnimation {
            target: screenlayout
            easing.type: Easing.OutCubic
            property: "x"
            duration: 500.0
        }
    }
    states:
        State {
        name: "historyItems"
        PropertyChanges {
            target: screenlayout
            x: -screen.width
        }
    }
}

