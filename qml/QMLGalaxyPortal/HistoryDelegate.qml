import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    id: historyItem

    property alias itemTitleText: itemtitle.text

    width: parent.width
    // pixelDensity: the number of physical pixels per millimeter.
    height: Math.max(mmItemHeight, itemtitle.contentHeight + mmItemMargin)
    color: "white"

    function getModelId() {
        return model.id;
    }

    Separator {
        anchors.bottom: parent.bottom
        width: parent.width
        margin: 0
    }

    // Item title.
    Text {
        id: itemtitle
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: model.name
        font.pointSize: largeFonts ? 20 : 15
    }
    // Icon for item.
    Image {
        id: itemIcon
        anchors.right: itemtitle.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 5
        height: sourceSize.height / 2
        width: sourceSize.width / 2
        fillMode: Image.PreserveAspectFit
        source: mouseArea.pressed ? iconRoot + "ic_action_next_item_pressed.png" : iconRoot + "ic_action_next_item.png"
    }

    // Items in the history list are clickable.
    MouseArea {
        // Give user visual feedback of active item through colour shift when hovering over item.
        // Will also result in colour change when item selected through touch giving user feedback.
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {historyItem.color = "lightgray" }
        onPressed: {historyItem.color = "lightgray" }
        onExited: {historyItem.color = "white" }
        onReleased: {historyItem.color = "white" }
        onPressAndHold: {historyItem.color = "white" }

        onClicked: {
            // set current history name
            main.currentHistory = itemtitle.text;
            main.currentHistoryID = model.id;
            historyListView.currentIndex = index;
        }
    }
}
