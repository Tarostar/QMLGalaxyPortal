import QtQuick 2.0
import QtQuick.Window 2.2
import "utils.js" as Utils
import "jsonpath.js" as JSONPath

Rectangle {
    id: details
    width: screen.width
    height: screen.height
    color: stateColour

    // Array of all the fields displayed.
    property var detailFields: []
    property color stateColour: "ivory"

    property string source: dataSource + "/api/histories/" + screen.currentHistoryID + "/contents/datasets/" + screen.currentJobID + "?key=" + dataKey;
    property string json: ""

    onSourceChanged: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    // Update JSON data when source changes.
    onJsonChanged: {updateJSONStrings(JSON.parse(json))}

    function updateJSONStrings(jsonData) {
        // Add list item for each field in field array which exists in the json data (otherwise ignored).
        detailFields.forEach(function(field) {
            if (jsonData[field])
                detailListModel.append({"fieldName": field, "fieldData": jsonData[field].toString()});
        });

        // Set action bar title to job name - if exists
        if (jsonData["name"])
            detailsActionBar.actionBarTitle.text = jsonData["name"];

        // Set item colour based on item state - if exists.
        if (jsonData["state"])
            stateColour = Utils.itemColour(jsonData["state"], false);
    }

    // Init default field array at startup.
    Component.onCompleted:{ initFieldArray(); }

    function initFieldArray() {
        detailFields.push("update_time");
        detailFields.push("misc_blurb");
        detailFields.push("data_type");
        detailFields.push("genome_build");
        detailFields.push("metadata_data_lines");
        detailFields.push("history_content_type");
        detailFields.push("file_ext");
        detailFields.push("file_size");
        detailFields.push("peek");
    }

    // Model that holds detail items to be displayed.
    ListModel { id: detailListModel }

    // Action bar
    ActionBar {
        id: detailsActionBar
        width: screen.width
        height: Screen.pixelDensity * 9
        settingsButton.visible: false
        backButton.visible: true
        backState: screen.state
    }
    ListView {
        id: detailList
        anchors.top: detailsActionBar.bottom
        anchors.topMargin: 5
        width: screen.width
        height: screen.height
        model: detailListModel
        delegate: Rectangle {
            id: historyItem
            color: stateColour
            width: parent.width
            // Set height to height of text, plus a bit of margin.
            height: textTitle.height > textData.height ? textTitle.height + 2 : textData.height + 5

            Text {
                id: textTitle
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideMiddle
                text: model.fieldName + ":"
                font.pixelSize: 12
                font.bold: true
            }
            Text {
                id: textData
                anchors.left: textTitle.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideMiddle
                text: model.fieldData
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                textFormat: Text.RichText
            }
        }

    }
}
