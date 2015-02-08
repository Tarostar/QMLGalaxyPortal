import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    id: historyItem

    width: parent.width
    // pixelDensity: the number of physical pixels per millimeter.
    height: Screen.pixelDensity * 9
    color: "ivory"


    Separator {
        anchors.bottom: parent.bottom
        width: parent.width
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
        font.pointSize: 15
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
        source: mouseArea.pressed ? imagePath + "ic_action_next_item_pressed.png" : imagePath + "ic_action_next_item.png"
    }

    // Items in the history list are clickable.
    MouseArea {
        // Give user visual feedback of active item through colour shift when hovering over item.
        // Will also result in colour change when item selected through touch giving user feedback.
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {historyItem.color = "lemonchiffon" }
        onPressed: {historyItem.color = "lemonchiffon" }
        onExited: {historyItem.color = "ivory" }
        onReleased: {historyItem.color = "ivory" }
        onPressAndHold: {historyItem.color = "ivory" }

        onClicked: {
            // set current history name
            main.currentHistory = itemtitle.text;
            main.currentHistoryID = model.id;

            // Trigger the state change to show the jobs list view.
            main.state = "historyItems";
        }
    }
}
