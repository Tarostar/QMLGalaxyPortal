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
            return model.hid + ": " + model.name;
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
        anchors.right: front ? frontRerunButton.left : backJobItemDetailsButton.left
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
        id: backJobItemDetailsButton
        visible: !front
        color: "#AFF1AF"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 1
        height: parent.height - 2
        width: parent.height > parent.width / 5 ? parent.width / 5 : parent.height - 2
        Image {
            id: metadataImage
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: sourceSize.height
            fillMode: Image.PreserveAspectFit
            source: metadataImageMouseArea.pressed ? iconRoot + "ic_action_zoom_pressed.png" : iconRoot + "ic_action_zoom.png"
        }
        MouseArea {
            id: metadataImageMouseArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {backJobItemDetailsButton.color = itemSelectColor }
            onPressed: {backJobItemDetailsButton.color = itemSelectColor }
            onExited: {backJobItemDetailsButton.color = itemColor }
            onReleased: {backJobItemDetailsButton.color = itemColor }
            onPressAndHold: {backJobItemDetailsButton.color = itemColor }
            onClicked: {
                jobListItems.currentIndex = index;
                main.currentJobID = model.id;
                mainLoader.source = "DetailView.qml";
            }
        }
    }
    Rectangle {
        id: frontDatasetButton
        visible: front && jsonHistoryJobContent.fullDataset.length > 0
        color: "#AFF1AF"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 1
        height: parent.height - 2
        width: parent.height > parent.width / 5 ? parent.width / 5 : parent.height - 2
        Image {
            id: datasetImage
            visible: front
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: sourceSize.height
            fillMode: Image.PreserveAspectFit
            source: datasetImageMouseArea.pressed ? iconRoot + "ic_action_attachment_pressed.png" : iconRoot + "ic_action_attachment.png"
        }
        MouseArea {
            id: datasetImageMouseArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {frontDatasetButton.color = itemSelectColor }
            onPressed: {frontDatasetButton.color = itemSelectColor }
            onExited: {frontDatasetButton.color = itemColor }
            onReleased: {frontDatasetButton.color = itemColor }
            onPressAndHold: {frontDatasetButton.color = itemColor }
            onClicked: {
                mainLoader.source = "Dataset.qml";
                mainLoader.item.url = jsonHistoryJobContent.fullDataset;
                mainLoader.item.actionBarTitle = model.name;
            }
        }
    }
    Rectangle {
        id: frontRerunButton
        visible: front
        color: "#AFF1AF"
        anchors.right: frontDatasetButton.visible ? frontDatasetButton.left : parent.right
        anchors.top: parent.top
        anchors.rightMargin: 1
        height: parent.height - 2
        width: parent.height > parent.width / 5 ? parent.width / 5 : parent.height - 2
        Image {
            id: rerunImage
            visible: front
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: sourceSize.height
            fillMode: Image.PreserveAspectFit
            source: rerunImageMouseArea.pressed ? iconRoot + "ic_action_replay_pressed.png" : iconRoot + "ic_action_replay.png"
        }
        MouseArea {
            id: rerunImageMouseArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {frontRerunButton.color = itemSelectColor }
            onPressed: {frontRerunButton.color = itemSelectColor }
            onExited: {frontRerunButton.color = itemColor }
            onReleased: {frontRerunButton.color = itemColor }
            onPressAndHold: {frontRerunButton.color = itemColor }
            onClicked: {
                //Utils.rerunJob();
                main.currentJobID = model.id;
                mainLoader.source = "RunJob.qml";
            }
        }
    }
    MouseArea {
        hoverEnabled: true
        anchors.left: parent.left
        anchors.right: front ? frontRerunButton.left : backJobItemDetailsButton.left
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
