import QtQuick 2.3

Item {
    id: button

    property url imageSource
    property url pressedImageSource
    property alias image: buttonImage

    signal clicked

    Image {
        id: buttonImage
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: mouseArea.pressed ? button.pressedImageSource : button.imageSource
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -10
        onClicked: button.clicked()
    }
}
