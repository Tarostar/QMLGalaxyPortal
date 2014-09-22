import QtQuick 2.3
import QtQuick.Window 2.2

import "utils.js" as Utils

Rectangle {
    id: screen
    width: Screen.width
    height: Screen.height

    // Galaxy API key for the dataSource used to retrieve data for user
    property string dataKey: "48878f3f037cdc0c1be3157296e2c964"
    property string dataSource: "https://test.galaxyproject.org"
    // https://usegalaxy.org (218afad6146272c7c771688e10fb9884)



    property var res: ["ldpi", "mdpi","hdpi","xhdpi"]
    property var devwidth: ["320", "480", "600", "1024", "1280", "1920", "2560"]
    readonly property int resIndex: Utils.getResolutionIndex(Screen.pixelDensity)
    readonly property int widthIndex: Utils.getScreenWidthIndex(Screen.width)

    JSONListModel {
        id: jsonHistoryJobsModel
        source: "not-set"
        query: "$.*"
    }

    JSONListModel {
        id: jsonHistoriesModel
        source: dataSource + "/api/histories?key=" + dataKey
        query: "$.*"
    }

    Row {
        id: screenlayout
        ListView {
            id: listview
            width: screen.width
            height: screen.height
            model: jsonHistoriesModel.model

            // note, delegate can just specify an "id"
            // also note can simply use "Component"
            delegate: Rectangle {
                id: listItem
                width: parent.width
                // pixelDensity: the number of physical pixels per millimeter.
                height: Screen.pixelDensity * 9;
                //source: "../../Images/" + res[resIndex] + "/item_" + devwidth[widthIndex] + ".png"
                color: "ivory" // "lightsteelblue"

                Image {
                    id: thumbnail
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: parent.height / 2
                    width: parent.height / 2
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/resources/main_image"
                    //source: imagesource
                    //onSourceChanged: print(imagesource)
                }
                Text {
                    id: itemtitle
                    anchors.left: thumbnail.right
                    anchors.right: parent.right
                    anchors.leftMargin: 20
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideMiddle
                    text: model.name
                    font.pixelSize: 15
                }
                Line {
                    id: seperator
                    anchors.left: parent.left
                    width: parent.width
                }

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    onEntered: {listItem.color = "lemonchiffon" }
                    onExited: {listItem.color = "ivory" }
                    onClicked: {
                        jsonHistoryJobsModel.source = dataSource + "/api/histories/" + model.id + "/contents?key=" + dataKey;
                        /*itemTitle.text = model.name;
                        itemDetails.text =  "Url: " + model.url +
                                            "\nID: " + model.id +
                                            "\nDeleted: " + model.deleted +
                                            "\nPublished: " + model.published

                        itemTags.text = "Tags:"*/
                        screen.state = "historyItems"
                    }
                }
            }
        }
        ListView {
                id: historyItems
                width: screen.width
                height: screen.height
                model: jsonHistoryJobsModel.model

                // note, delegate can just specify an "id"
                // also note can simply use "Component"
                delegate: Rectangle {
                    id: historyItem
                    width: parent.width
                    // pixelDensity: the number of physical pixels per millimeter.
                    height: Screen.pixelDensity * 9;
                    color: "ivory"

                Text {
                    id: historyItemTitle
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 20
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideMiddle
                    text: model.name + "\n "
                    font.pixelSize: 15
                }
                Line {
                    id: historyItemSeparator
                    anchors.left: parent.left
                    width: parent.width
                }
                MouseArea {
                    // TODO: this should drill deeper and separate key for returning
                    anchors.fill: parent
                    onClicked: screen.state = ""
                }
            }

            /*Text {
                id: itemTitle
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 5
                anchors.topMargin: 5
                text: "n/a"
                // Behavior on opacity { NumberAnimation {}}
                font.pixelSize: 20
                font.bold: true
            }
            Text {
                id: itemDetails
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 5
                anchors.topMargin: 5
                anchors.top: itemTitle.bottom
                text: "no data"
                // Behavior on opacity { NumberAnimation {}}
                font.pixelSize: 15
            }
            Text {
                id: itemTags
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
                anchors.rightMargin: 5
                anchors.top: itemDetails.bottom
                text: "no tag data"
                // Behavior on opacity { NumberAnimation {}}
                font.pixelSize: 12
                font.italic: true
            }*/
        }

    }
    transitions: Transition {
        NumberAnimation {
            target: screenlayout
            easing: Easing.OutCubic
            property: "x"
            duration: 500
        }
    }
    states: State {
        name: "historyItems"
        PropertyChanges {
            target: screenlayout
            x: -screen.width
        }
    }
}

