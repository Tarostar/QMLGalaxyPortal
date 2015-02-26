import QtQuick 2.3
import QtQuick.Window 2.2
import "utils.js" as Utils

Rectangle {
    id: jobItem
    anchors.fill: parent
    color: itemColor

    property bool front: true
    property alias textHeight: jobItemText.contentHeight
    property color itemColor: Utils.itemColour(model.state, false)
    property color itemSelectColor: Utils.itemColour(model.state, true)
    property string currentText: ""

    function datasetText() {
        // note this may generate a false error: "QML Text: Binding loop detected for property "style"
        // This is a known Qt bug in v 5.3 QTBUG-36849: False binding loops in QtQuick Controls: https://bugreports.qt-project.org/browse/QTBUG-36849

        if (front) {
            return model.name;
        }

        if (currentJobID !== model.id)
        {
            // This is not the current job item, so just return current text.
            return currentText;
        }

        // Current job.

        if (advancedFields && jsonHistoryJobContent.text && jsonHistoryJobContent.text.length > 0)
        {
            // Set current text to display from JSON data.
            currentText = "<b>Status</b>: " + model.state + jsonHistoryJobContent.text;
        }
        else
        {
            // No display text, just show basic information.
            currentText = "<b>Status</b>:" + model.state + " <b>Content</b>: " + model.history_content_type + " <b>Type</b>: " + model.type;
        }

        return currentText;
    }

    Separator {
        id: separator
        anchors.bottom: parent.bottom
        width: parent.width
        margin: 0
    }

    Text {
        id: jobItemText
        anchors.left: parent.left
        anchors.right: jobItemDetails.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 20
        anchors.rightMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideMiddle
        text: datasetText();
        font.pointSize: largeFonts ? 18 : advancedFields && !front ? 12 : 14
        font.strikeout: model.deleted
        wrapMode: Text.WordWrap
    }
    Rectangle {
        id: jobItemDetails
        color: "lemonchiffon"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 1
        height: parent.height - 2
        width: parent.height > parent.width / 5 ? parent.width / 5 : parent.height - 2
        Image {
            id: image
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: sourceSize.height
            fillMode: Image.PreserveAspectFit
            source: mouseArea.pressed ? iconRoot + "ic_action_search_pressed.png" : iconRoot + "ic_action_search.png"
        }
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
                main.currentJobID = model.id;
                mainLoader.source = "DetailView.qml";
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
                main.currentJobID = model.id;
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
