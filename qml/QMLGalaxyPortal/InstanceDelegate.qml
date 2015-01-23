import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    id: instanceItem

    width: parent.width
    // pixelDensity: the number of physical pixels per millimeter.
    height: Screen.pixelDensity * 9;
    color: "ivory"

    Separator {
        id: separator
        anchors.bottom: parent.bottom
        width: parent.width
    }

    // Item title.
    Text {
        id: instanceTitle
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: model.url
        font.pointSize: 15
    }
    Rectangle {
        id: deleteInstance
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
            source: mouseArea.pressed ? imagePath + "ic_action_discard_pressed.png" : imagePath + "ic_action_discard.png"
            MouseArea {
                id: mouseArea
                hoverEnabled: true
                anchors.fill: parent
                onEntered: {deleteInstance.color = "aquamarine" }
                onPressed: {deleteInstance.color = "aquamarine" }
                onExited: {deleteInstance.color = "lemonchiffon" }
                onReleased: {deleteInstance.color = "lemonchiffon" }
                onPressAndHold: {deleteInstance.color = "lemonchiffon" }
                onClicked: {
                    // delete instance
                    instanceListView.deleteInstance(model.index);
                }
            }
        }
    }

    // Items in the instance list are clickable.
   MouseArea {
        // Give user visual feedback of active item through colour shift when hovering over item.
        // Will also result in colour change when item selected through touch giving user feedback.
        hoverEnabled: true
        anchors.left: parent.left
        anchors.right: deleteInstance.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        onEntered: {instanceItem.color = "lemonchiffon" }
        onPressed: {instanceItem.color = "lemonchiffon" }
        onExited: {instanceItem.color = "ivory" }
        onReleased: {instanceItem.color = "ivory" }
        onPressAndHold: {instanceItem.color = "ivory" }

        onClicked: {
            // Update instance.
            main.dataSource = model.url
            main.dataKey = model.key;

            // Reset main state to show main history list.
            main.state = "";

            // Go back.
            mainLoader.source = "Settings.qml";
        }
    }
}
