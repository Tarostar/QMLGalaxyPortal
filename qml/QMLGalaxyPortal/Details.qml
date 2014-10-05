import QtQuick 2.3
import QtQuick.Window 2.2

import "jsonpath.js" as JSONPath

Rectangle {
    id: details
    width: screen.width
    height: screen.height
    color:"ivory"

    property string source: dataSource + "/api/histories/" + screen.currentHistoryID + "/contents/datasets/" + screen.currentJobID + "?key=" + dataKey;
    property string json: ""

    property string jsonDetails: ""

    onSourceChanged: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    onJsonChanged: {updateJSONStrings(JSON.parse(json))}

    function updateJSONStrings(jsonData) {
        file_ext.text = jsonData.peek;
    }

    // Action bar
    ActionBar {
        id: detailsActionBar
        width: screen.width
        height: Screen.pixelDensity * 9
        settingsButton.visible: false
        backButton.visible: true
        backState: screen.state
    }
    Text {
        id: file_ext
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: detailsActionBar.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: url
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: file_ext.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "URL: " + source
        font.pixelSize: 15
    }

}
