import QtQuick 2.3

Item {
    id: button

    property url imageSource
    property url pressedImageSource
    property alias image: buttonImage
    // Optional button text
    property alias title: information.text
    property alias textHeight: information.contentHeight
    property alias textWidth: information.contentWidth

    signal clicked

    Image {
        id: buttonImage
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: mouseArea.pressed ? button.pressedImageSource : button.imageSource
        Text {
            id: information
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            elide: Text.ElideMiddle
            text: title
            font.pointSize: largeFonts ? 18 : 10
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -10
        onClicked: button.clicked()
    }
}
