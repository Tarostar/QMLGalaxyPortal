import QtQuick 2.3

Rectangle {
    id: jobItem
    anchors.fill: parent
    color: "ivory"

    property bool front: true
    property alias jobItemText: jobItemText.text

    // Item separator (lighter at the top, darker at the bottom).
    Rectangle { color: "white"; width: parent.width; height: 1 }
    Rectangle { color: "#cdcdc1"; width: parent.width; height: 1; anchors.bottom: parent.bottom }

    Text {
        id: jobItemText
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: model.name
        font.pixelSize: 15
    }
    MouseArea {
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {jobItem.color = itemSelectColor }
        onPressed: {jobItem.color = itemSelectcolor }
        onExited: {jobItem.color = itemColor }
        onReleased: {jobItem.color = itemColor }
        onPressAndHold: {jobItem.color = itemColor }
        onClicked: {
            if (front)
            {
                flipBar.flipUp()
                flipBar.flipped = true
            }
            else
            {
                flipBar.flipDown()
                flipBar.flipped = false
            }
        }
    }
}
