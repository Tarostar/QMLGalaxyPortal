import QtQuick 2.3
import QtQuick.Window 2.2

import "utils.js" as Utils

Rectangle {
    id: screen
    width: Screen.width
    height: Screen.height

    property string currentHistory: ""

    // loader to spawn pages on top of list (e.g. for settings)
    Loader {  z: 1; id: mainLoader }

    // Galaxy API key for the dataSource used to retrieve data for user
    // local instance
    property string dataKey: "0f303101f8a957e35106c049f7ac38f9"
    property string dataSource: "http://10.0.0.80"
    // test galaxy
/*
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
        query: "$.*"
    }

    // Model for the list of jobs in a selected history (source set when history selected).
    JSONListModel {
        id: jsonHistoryJobsModel
        query: "$.*"
    }

    /*EditBox {
        width: screen.width
        height: Screen.pixelDensity * 9;
        text: "hello"
    }

    property alias text: input.text

    TextInput {
        id: input
        anchors.fill: parent
        anchors.margins: 8
        font.pixelSize: 20
    }*/

    Column {
        TopToolbar {
            id: mainActionbar
            width: screen.width
            height: Screen.pixelDensity * 9
            settingsButton.visible: screen.state === "" ? true : false
            backButton.visible: screen.state === "" ? false : true
            toolbarTitle.text: screen.state === "" ? "Galaxy Portal - " + jsonHistoriesModel.count + " items" :  currentHistory + " - " + jsonHistoryJobsModel.count + " items"
        }
        Row {
            id: screenlayout
            ListView {
                id: historyListView
                width: screen.width
                height: screen.height
                model: jsonHistoriesModel.model
                delegate: HistoryDelegate {}
            }
            ListView {
                    id: jobListItems
                    width: screen.width
                    height: screen.height
                    model: jsonHistoryJobsModel.model
                    delegate: JobDelegate {}

                    /*add: Transition {
                        NumberAnimation { property: "hm"; from: 0.0; to: 1.0; duration: 300.0; easing.type: Easing.OutQuad }
                        PropertyAction { property: "appear"; value: 250.0 }
                    }*/
            }

        }
    }
    transitions: Transition {
        NumberAnimation {
            target: screenlayout
            easing: Easing.OutCubic
            property: "x"
            duration: 500.0
        }
    }
    states: /*[
        State {
            name: "test"
            PropertyChanges {
                target: menu
                opacity: 0
                visible: false
            }
        },*/
        State {
        name: "historyItems"
        PropertyChanges {
            target: screenlayout
            x: -screen.width
        }
    }
    //]


}

