import QtQuick 2.3
import QtQuick.Window 2.2
import "utils.js" as Utils

Rectangle {
    id: details
    width: screen.width
    height: screen.height
    color: stateColour

    property color stateColour: "ivory"
    property color stateColourAlt: "lemonchiffon"

    property string source: dataSource + "/api/histories/" + screen.currentHistoryID + "/contents/datasets/" + screen.currentJobID + "?key=" + dataKey;
    property string json: ""

    // Poll for data when source changes.
    onSourceChanged: {
        // Timer will trigger immediately on start and then again at every "interval".
        timer.start();
    }

    // Timer triggers periodic poll to retrieve any changes server side.
    Timer {
        id: timer
        interval: screen.periodicPolls
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: { poll(); }
    }

    // Poll server using the global XMLHttpRequest (note: does not enforce the same origin policy).
    function poll() {
        json = "";
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.setRequestHeader("Content-type", "application/json");
        xhr.setRequestHeader('Accept-Language', 'en');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                httpTimeout.running = false;
                if (xhr.status === 200) {
                    json = xhr.responseText;
                } else {
                    // TODO: report error.
                    detailListModel.clear();
                    detailListModel.append({"fieldName": "Error" , "fieldData": xhr.statusText});
                }
            }
        }

        httpTimeout.running = true;
        xhr.send();
    }

    // Timeout handling since Qt XMLHttpRequest does not support "timeout".
    Timer {
        id: httpTimeout
        interval: 5000 // 5 seconds interval, should eventually be user configurable.
        repeat: false
        running: false
        onTriggered: {
            detailListModel.clear();
            detailListModel.append({"fieldName": "Timeout" , "fieldData": "after " + httpTimeout.interval / 1000 + " seconds."});
        }
    }

    // Update JSON data when source changes.
    onJsonChanged: {updateJSONStrings(json)}

    function updateJSONStrings(jsonData) {
        // Take JSON string and convert to JavaScript object.
        var jsonObject = JSON.parse(jsonData)

        // For every key in the JSON object insert a field in the list to be shown.
        for (var key in jsonObject) {
            // Only accept recognised types (i.e. objects and undefined are not inserted into the list).
            if (typeof jsonObject[key] === "boolean" || typeof jsonObject[key] === "number" ||
                    typeof jsonObject[key] === "string" || typeof jsonObject[key] === "symbol") {
                if (jsonObject[key].toString().length > 0) {
                    // Only non-empty strings are actually inserted.
                    detailListModel.append({"fieldName": key.toString() , "fieldData": jsonObject[key].toString()});
                }
            }
        }

        // Set action bar title to job name - if exists
        if (jsonObject["name"])
            detailsActionBar.actionBarTitle = jsonObject["name"];

        // Set item colour based on item state - if exists.
        if (jsonObject["state"])
        {
            stateColour = Utils.itemColour(jsonObject["state"], false);
            stateColourAlt = Utils.itemColour(jsonObject["state"], true);
        }
    }

    // Model that holds detail items to be displayed.
    ListModel { id: detailListModel }

    // Action bar
    ActionBar {
        id: detailsActionBar
        width: screen.width
        height: Screen.pixelDensity * 9
        backButton.visible: true
        backState: screen.state
    }
    ListView {
        id: detailList
        anchors.top: detailsActionBar.bottom
        anchors.topMargin: 5
        width: screen.width
        height: screen.height - detailsActionBar.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: detailListModel
        delegate: Rectangle {
            id: historyItem
            // Alternating colour.
            color: index%2 == 0 ? stateColour : stateColourAlt
            width: parent.width
            // Set height to height of text, plus a bit of margin.
            height: textTitle.height > textData.height ? textTitle.height + 2 : textData.height + 5

            Text {
                id: textTitle
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
                width: Math.max(160, paintedWidth)
                text: model.fieldName + ":"
                font.pointSize: 12
                font.bold: true
            }
            Text {
                id: textData
                anchors.left: textTitle.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideMiddle
                text: model.fieldData
                font.pointSize: 12
                textFormat: Text.RichText
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainLoader.source = "DetailZoom.qml";
                    mainLoader.item.color = historyItem.color;
                    mainLoader.item.title = model.fieldName;
                    mainLoader.item.itemData = model.fieldData;
                    mainLoader.item.actionBarTitle = detailsActionBar.actionBarTitle;
                }
            }
        }

    }
}
