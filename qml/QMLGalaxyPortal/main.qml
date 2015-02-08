import QtQuick 2.3
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import QtMultimedia 5.4

import "utils.js" as Utils

Rectangle {
    id: main
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

    // Frequency of periodic polls (zero means no polling) - default once a minute.
    property int periodicPolls: 60000

    property bool audioNotifications: true

    // User set size multiplier.
    property real scale: 1.5

    // List item in millimetre (pixelDensity is number of pixels per mm).
    property int mmItemHeight: Screen.pixelDensity * 10 * scale;
    property int mmItemMargin: Screen.pixelDensity * 3 * scale;

    // Save settings.
    Settings {
        // Galaxy API settings.
        property alias dataKey: main.dataKey
        property alias dataSource: main.dataSource
        property alias username: main.username

        // Passcode settings.
        property alias passcode: main.passcode
        property alias passcodeEnabled : main.passcodeEnabled

        // Job item flip fields.
        property alias fieldList : main.fieldList
        property alias advancedFields : main.advancedFields

        // Currently viewed history and job.
        property alias currentHistory : main.currentHistory
        property alias currentHistoryID : main.currentHistoryID
        property alias currentJobID : main.currentJobID

        // Polling frequency.
        property alias periodicPolls : main.periodicPolls

        // Instance List
        property alias instanceList : main.instanceList
        property alias instanceListKeys : main.instanceListKeys

        // Audio Alerts
        property alias audioNotifications : main.audioNotifications

        // User set size multiplier.
        property alias scale : main.scale
    }

    // loader to spawn pages on top of list (e.g. for settings)
    Loader {  z: 1; id: mainLoader }

    Audio {
        id: notificationSound
        source: "qrc:/resources/resources/sounds/ping.mp3"
    }
    Audio {
        id: alertSound
        source: "qrc:/resources/resources/sounds/alert.mp3"
    }

    // Properties to manage different device resolutions and screen sizes (handled in utils.js).
    property var res: ["mdpi","hdpi","xhdpi", "xxhdpi"]
    property var devwidth: ["320", "480", "600", "1024", "1280", "1920", "2560"]
    readonly property int resIndex: Utils.getResolutionIndex(Screen.pixelDensity)
    readonly property int widthIndex: Utils.getScreenWidthIndex(Screen.width)
    property string imagePath: "qrc:/resources/resources/icons/" + res[resIndex] + "/"

    // Model for the list of histories (main list).
    JSONListModel {
        id: jsonHistoriesModel
        pollInterval: main.periodicPolls
        source: dataKey.length > 0 ? dataSource.length > 0 ? dataSource + "/api/histories?key=" + dataKey : "" : ""
    }

    // Model for the list of jobs in a selected history (source set when history selected).
    JSONListModel {
        id: jsonHistoryJobsModel
        pollInterval: main.periodicPolls
        source: main.currentHistoryID.length > 0 ? dataSource + "/api/histories/" + main.currentHistoryID + "/contents?key=" + dataKey : "";
    }

    JSONDataset {
        id: jsonHistoryJobContent
        pollInterval: main.periodicPolls
        source: main.currentHistoryID.length > 0 ? dataSource + "/api/histories/" + main.currentHistoryID + "/contents/datasets/" + main.currentJobID + "?key=" + dataKey : "";
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
        visible: (!challengeDialog.visible && jsonHistoriesModel.count === 0 && main.state === "")
    }

    // Init view at startup.
    Component.onCompleted:{
        if (main.currentHistoryID.length > 0) {
            main.state = "historyItems";
        }
    }

    Column {
        visible: !challengeDialog.visible
        anchors.fill: parent
        ActionBar {
            id: mainActionbar
            width: main.width
            height: Screen.pixelDensity * 9
            // Back button only visible when possible to navigate back.
            backButton.visible: main.state === "" ? false : true
            actionBarTitle: main.state === "" ? "Galaxy Portal - " + jsonHistoriesModel.count + " items" :  currentHistory + " - " + jsonHistoryJobsModel.count + " items"
        }
        Row {
            id: screenlayout
            ListView {
                id: historyListView
                width: main.width
                height: main.height - mainActionbar.height
                model: jsonHistoriesModel.model
                delegate: HistoryDelegate {}
                clip: true
                boundsBehavior: Flickable.StopAtBounds
            }
            ListView {
                id: jobListItems
                width: main.width
                height: main.height - mainActionbar.height
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
            x: -main.width
        }
    }
}

