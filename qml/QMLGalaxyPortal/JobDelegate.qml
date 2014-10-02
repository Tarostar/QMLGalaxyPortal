import QtQuick 2.0
import QtQuick.Window 2.2

Item {
    id: jobItem

    property real hm: 1.0
    property real appear: 1.0
    property real startRotation: 1.0
    property color itemColor: model.state === "ok" ? "ivory" : model.state === "error" ? "red" : "yellow"
    property color itemSelectColor: model.state === "ok" ? "lemonchiffon" : model.state === "error" ? "tomato" : "gold"

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

    width: parent.width
    height: Screen.pixelDensity * 9 * hm

    Flip {
        id: flipBar

        property bool flipped: false
        vertexDelta: startRotation

        // Width fills screen, height is pixelDensity (number of physical pixels per millimeter).
        width: parent.width
        height: Screen.pixelDensity * 9;

        // Set how much to fold edges (3D effect) based on item width to get a realistic effect.
        factor: width <= 200 ? 0.1 : 0.1 / (width / 200.0)

        // Rectangle for frontside of the flip item.
        front: JobItem {
            front: true
            color: itemColor
        }

        // Rectangle for backside of the flip item.
        back: JobItem {
            front: false
            color: itemColor
            jobItemText: "<b>Status</b>: " + model.state + " <b>Content</b>: " + model.history_content_type + " <b>Type</b>: " + model.type
        }
    }
}
