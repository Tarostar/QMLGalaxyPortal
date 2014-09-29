import QtQuick 2.3

Item {
    id: button

    property url image
    property url pressedImage

    signal clicked

    Image {
        id: buttonImage
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: mouseArea.pressed ? button.pressedImage : button.image
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -10
        onClicked: button.clicked()
    }
}
