import QtQuick 2.3
import QtQuick.Window 2.2

import "utils.js" as Utils

Item {
    id: jobItem

    property real hm: 1.0
    property real appear: 1.0
    property real startRotation: 1.0
    property color itemColor: Utils.itemColour(model.state, false)
    property color itemSelectColor: Utils.itemColour(model.state, true)
    property string currentText: ""

    // Tracks status for user notification when it changes.
    property string currentState: ""

    function checkNotify() {
        // Check if we have a current state and if it has changed.
        if (model.state && model.state.length > 0 && model.state !== currentState) {
            if (currentState && currentState.length > 0) {
                if (main.audioNotifications) {
                    // Play alert if we go from "running" state to a new state, otherwise play notification.
                    if (currentState === "running") {
                        alertSound.play();
                    } else {
                        notificationSound.play();
                    }
                }

                // update colour
                frontItem.color = Utils.itemColour(model.state, false);
                backItem.color = Utils.itemColour(model.state, false);
            }

            currentState = model.state;
        }
    }

    onAppearChanged: {
        jobItem.startRotation = 0.5
        flipBar.animDuration = appear;
        delayedAnim.start();
    }

    SequentialAnimation {
        id: delayedAnim
        PauseAnimation { duration: 50.0 }
        ScriptAction { script: flipBar.flipDown(startRotation); }
    }

    function datasetText() {
        // note this may generate a false error: "QML Text: Binding loop detected for property "style"
        // This is a known Qt bug in v 5.3 QTBUG-36849: False binding loops in QtQuick Controls: https://bugreports.qt-project.org/browse/QTBUG-36849

        // Check status to see if user should be notified.
        checkNotify();

        if (currentJobID !== model.id)
        {
            // This is not the current job item, so just return current text.
            return currentText;
        }

        // Current job.

        if (advancedFields && jsonHistoryJobContent.text && jsonHistoryJobContent.text.length > 0)
        {
            // Set current text to display from JSON data.
            currentText = "<b>Status</b>: " + model.state + " <b>Content</b>: " + jsonHistoryJobContent.text;
        }
        else
        {
            // No display text, just show basic information.
            currentText = "<b>Status</b>:" + model.state + " <b>Content</b>: " + model.history_content_type + " <b>Type</b>: " + model.type;
        }

        return currentText;
    }

    width: parent.width

    // When flipped to show backside the item should be sized to text content.
    height: flipBar.flipped ? Screen.pixelDensity * 9 * hm > (backItem.textHeight + 10) * hm ? Screen.pixelDensity * 9 * hm : (backItem.textHeight + 10) * hm : Screen.pixelDensity * 9 * hm

    Flip {
        id: flipBar

        property bool flipped: false
        vertexDelta: startRotation

        // Width fills screen, height is pixelDensity (number of physical pixels per millimeter).
        width: parent.width
        height: parent.height

        // Set how much to fold edges (3D effect) based on item width to get a realistic effect.
        factor: width <= 200 ? 0.1 : 0.1 / (width / 200.0)

        // Rectangle for frontside of the flip item.
        front: JobItem {
            id: frontItem
            front: true
            color: itemColor
        }

        // Rectangle for backside of the flip item.
        back: JobItem {
            id: backItem
            front: false
            color: itemColor
            fontSize: 12
            itemText: datasetText();
        }
    }
}
