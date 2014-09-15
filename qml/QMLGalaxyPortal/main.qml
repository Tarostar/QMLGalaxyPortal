import QtQuick 2.0

Rectangle {
    id: screen
    width: 360
    height: 360

    ListView {
        width: screen.width
        height: screen.height

        model: 20

        delegate: Image {
            width: parent.width
            height: 150
            source: "images/gradient_centernarrow.png"

            Image {
                id: thumbnail
                anchors.left: parent.left
                height: parent.height
                width: parent.height
                source: "images/QMLGalaxyPortal80.png"
            }

            Text {
                anchors.left: thumbnail.right
                anchors.verticalCenter: parent.verticalCenter
                text: "test"
                font.pixelSize: 20
            }
        }
    }
}
