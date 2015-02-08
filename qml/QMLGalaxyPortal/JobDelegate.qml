import QtQuick 2.3
import QtQuick.Window 2.2

Item {
    id: jobItem

    property real hm: 1.0
    property real appear: 1.0
    property real startRotation: 1.0

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
    height: flipBar.flipped ? backItem.textHeight + Screen.pixelDensity * 5: frontItem.textHeight + Screen.pixelDensity * 5

    Flip {
        id: flipBar

        property bool flipped: false

        vertexDelta: startRotation
        anchors.fill: parent

        // Set how much to fold edges (3D effect) based on item width to get a realistic effect.
        factor: width <= 200 ? 0.1 : 0.1 / (width / 200.0)

        // Rectangle for frontside of the flip item.
        front: JobItem {
            id: frontItem
            front: true
        }

        // Rectangle for backside of the flip item.
        back: JobItem {
            id: backItem
            front: false
        }
    }
}
