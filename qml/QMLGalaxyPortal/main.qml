import QtQuick 2.3
import QtQuick.Window 2.2
import Qt.labs.settings 1.0

import "utils.js" as Utils

Rectangle {
    id: screen
    width: Screen.width
    height: Screen.height

    // Title of any selected History item.
    property string currentHistory: ""
    property string currentHistoryID: ""
    property string currentJobID: ""

    // Galaxy API key for the dataSource used to retrieve data for user.
    property string dataSource: "http://10.0.0.80"
    property string dataKey: "0f303101f8a957e35106c049f7ac38f9"
    property string passcode: ""
    property bool passcodeEnabled: false

    Settings {
        property alias dataKey: screen.dataKey
        property alias dataSource: screen.dataSource
        property alias passcode: screen.passcode
        property alias passcodeEnabled : screen.passcodeEnabled
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

    // Model for the list of histories (main list).
    JSONListModel {
        id: jsonHistoriesModel
        source: dataSource + "/api/histories?key=" + dataKey
        clearOnEmptyData: false
        pollInterval: 5000
    }

    // Model for the list of jobs in a selected history (source set when history selected).
    JSONListModel {
        id: jsonHistoryJobsModel
        clearOnEmptyData: false
        pollInterval: 5000
    }

    JSONDataset {
        id: jsonHistoryJobContent
        source: dataSource + "/api/histories/" + screen.currentHistoryID + "/contents/datasets/" + screen.currentJobID + "?key=" + dataKey;
        pollInterval: 1000
    }

    Column {
        ActionBar {
            id: mainActionbar
            width: screen.width
            height: Screen.pixelDensity * 9
            // Settings button always visible.
            settingsButton.visible: true // screen.state === "" ? true : false
            // Back button only visible when possible to navigate back.
            backButton.visible: screen.state === "" ? false : true
            actionBarTitle.text: screen.state === "" ? "Galaxy Portal - " + jsonHistoriesModel.count + " items" :  currentHistory + " - " + jsonHistoryJobsModel.count + " items"
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

