import QtQuick 2.0
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

    JSONDatasetListModel {
        id: jsonDatasetListModel
        source: dataSource + "/api/histories/" + screen.currentHistoryID + "/contents/datasets/" + model.id + "?key=" + dataKey;
    }

    function datasetText() {
        if (jsonDatasetListModel.displayText)
            return "<b>Status</b>: " + model.state + jsonDatasetListModel.displayText;

        // No display text, just show basic information.
        return "<b>Status</b>:" + model.state + " <b>Content</b>: " + model.history_content_type + " <b>Type</b>: " + model.type;
    }

    width: parent.width
    //height: Screen.pixelDensity * 9 * hm

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
