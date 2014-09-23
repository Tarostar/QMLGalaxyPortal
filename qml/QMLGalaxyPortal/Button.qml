import QtQuick 2.3

Item {
    id: button

    property url image: "qrc:/resources/resources/icons/btn.png"
    property url pressedImage: "qrc:/resources/resources/icons/btn_highlighted.png"
    property url icon
    property real iconScale: 1

    signal clicked

    Image {
        id: bg
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        source: mouseArea.pressed ? button.pressedImage : button.image
    }

    Image {
        anchors.centerIn: bg
        source: button.icon
        scale: button.iconScale
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        anchors.margins: -10
        onClicked: button.clicked()
    }
}
