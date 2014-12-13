import QtQuick 2.3

Rectangle {
    id: jobItem
    anchors.fill: parent
    color: "ivory"

    property bool front: true
    property alias itemText: jobItemText.text
    property alias fontSize: jobItemText.font.pointSize
    property alias textHeight: jobItemText.height

    Separator {
        id: separator
        anchors.bottom: parent.bottom
        width: parent.width
    }

    Text {
        id: jobItemText
        anchors.left: parent.left
        anchors.right: jobItemDetails.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        anchors.rightMargin: 5
        verticalAlignment: contentHeight > parent.height ? Text.AlignTop : Text.AlignVCenter
        elide: Text.ElideMiddle
        text: model.name
        font.pointSize: 14
        wrapMode: Text.WordWrap
    }
    Rectangle {
        id: jobItemDetails
        color: "lemonchiffon"
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height - 2
        width: parent.height - 2
        Image {
            id: image
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: sourceSize.height
            width: sourceSize.width
            fillMode: Image.PreserveAspectFit
            source: mouseArea.pressed ? imagePath + "ic_action_search_pressed.png" : imagePath + "ic_action_search.png"
            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent
                onEntered: {jobItemDetails.color = "aquamarine" }
                onPressed: {jobItemDetails.color = "aquamarine" }
                onExited: {jobItemDetails.color = "lemonchiffon" }
                onReleased: {jobItemDetails.color = "lemonchiffon" }
                onPressAndHold: {jobItemDetails.color = "lemonchiffon" }
                onClicked: {
                    screen.currentJobID = model.id;
                    mainLoader.source = "DetailView.qml";
                }
            }
        }
    }

    MouseArea {
        hoverEnabled: true
        anchors.left: parent.left
        anchors.right: jobItemDetails.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        onEntered: {jobItem.color = itemSelectColor }
        onPressed: {jobItem.color = itemSelectColor }
        onExited: {jobItem.color = itemColor }
        onReleased: {jobItem.color = itemColor }
        onPressAndHold: {jobItem.color = itemColor }
        onClicked: {
            if (front)
            {
                screen.currentJobID = model.id;
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
