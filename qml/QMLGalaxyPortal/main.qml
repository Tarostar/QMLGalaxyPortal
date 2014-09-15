import QtQuick 2.0
import QtQuick.XmlListModel 2.0

// http://qt-project.org/wiki/JSONListModel
// https://github.com/kromain/qml-utils




Rectangle {
    id: screen
    width: 360
    height: 360

    XmlListModel {
        id : listmodel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=atom&tags=cats"
        query: "/feed/entry"
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "imagesource"; query: "link[@rel=\"enclosure\"]/@href/string()" }
    }

    JSONListModel {
                    id: jsonModel1
                    source: "jsonData.txt"

                    query: "$.store.book[*]"
                }

    transitions: [
        Transition {
            NumberAnimation {
                target: screenlayout
                easing: Easing.OutCubic
                property: "x"
                duration: 500
            }
        }
    ]
    states: [
        State {
            name: "view"
            PropertyChanges {
                target: screenlayout
                x: -screen.width
            }
        }
    ]

    Row {
        id: screenlayout
        ListView {
            id: listview
            width: screen.width
            height: screen.height
            //model: 20
            //model: listmodel
            model: jsonModel1.model

            delegate: Image {
                width: parent.width
                height: 80
                source: "images/gradient_invertedcenternarrow.png"

                Image {
                    id: thumbnail
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: parent.height / 2
                    width: parent.height / 2
                    fillMode: Image.PreserveAspectFit
                    source: "images/QMLGalaxyPortal80.png"
                    //source: imagesource
                    //onSourceChanged: print(imagesource)
                }
                Text {
                    id: itemtitle
                    anchors.left: thumbnail.right
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideMiddle
                    anchors.leftMargin: 20
                    text: title
                    font.pixelSize: 20
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: screen.state = "view"
                }
            }
        }
        Text {
            id: details
            width: screen.width
            height: screen.height
            text: "details"
            // Behavior on opacity { NumberAnimation {}}
            MouseArea {
                anchors.fill: parent
                onClicked: screen.state = ""
            }
        }
    }
}
