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

    // Instance list to store between sessions
    property string instanceList: ""
    property string instanceListKeys: ""

    // Galaxy API key for the dataSource used to retrieve data for user.
    property string dataSource: "https://usegalaxy.org"
    property string dataKey: ""
    property string username: ""
    property string passcode: ""
    property bool passcodeEnabled: false

    // Frequency of periodic polls (zero means no polling).
    property int periodicPolls: 0

    // Save settings.
    Settings {
        // Galaxy API settings.
        property alias dataKey: screen.dataKey
        property alias dataSource: screen.dataSource
        property alias username: screen.username

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

        // Instance List
        property alias instanceList : screen.instanceList
        property alias instanceListKeys : screen.instanceListKeys
    }

    // loader to spawn pages on top of list (e.g. for settings)
    Loader {  z: 1; id: mainLoader }

    // Properties to manage different device resolutions and screen sizes (handled in utils.js).
    property var res: ["mdpi","hdpi","xhdpi", "xxhdpi"]
    property var devwidth: ["320", "480", "600", "1024", "1280", "1920", "2560"]
    readonly property int resIndex: Utils.getResolutionIndex(Screen.pixelDensity)
    readonly property int widthIndex: Utils.getScreenWidthIndex(Screen.width)
    property string imagePath: "qrc:/resources/resources/icons/" + res[resIndex] + "/"

    // Model for the list of histories (main list).
    JSONListModel {
        id: jsonHistoriesModel
        source: dataKey.length > 0 ? dataSource.length > 0 ? dataSource + "/api/histories?key=" + dataKey : "" : ""
        clearOnEmptyData: true
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

    // Empty list view.
    Welcome {
        visible: (!challengeDialog.visible && jsonHistoriesModel.count === 0 && screen.state === "")
    }

    // Init view at startup.
    Component.onCompleted:{
        if (screen.currentHistoryID.length > 0) {
            screen.state = "historyItems";
        }
    }

    Column {
        visible: !challengeDialog.visible
        anchors.fill: parent
        ActionBar {
            id: mainActionbar
            width: screen.width
            height: Screen.pixelDensity * 9
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

