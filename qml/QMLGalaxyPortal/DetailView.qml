import QtQuick 2.3
import QtQuick.Window 2.2
import "utils.js" as Utils

Rectangle {
    id: details
    width: main.width
    height: main.height
    color: stateColour

    property color stateColour: "ivory"
    property color stateColourAlt: "lemonchiffon"

    property string source: dataSource + "/api/histories/" + main.currentHistoryID + "/contents/datasets/" + main.currentJobID + "?key=" + dataKey;
    property string json: ""

    property string fullDataset: ""

    function onReady(request) {
		
		console.log("Current job id: " + main.currentJobID);
		
        if (request === undefined) {
            detailListModel.clear();
            detailListModel.append({"fieldName": "Timeout" , "fieldData": "after five seconds."});
            return;
        }

        if (request.readyState === XMLHttpRequest.DONE) {
               
            if (request.status === 200) {
                json = request.responseText;
            } else {
                // TODO: report error.
                detailListModel.clear();
                detailListModel.append({"fieldName": "Error" , "fieldData": request.statusText});
            }
        }
    }

    // Poll for data when source changes.
    onSourceChanged: {
        // Timer will trigger immediately on start and then again at every "interval".
        timer.start();
    }

    // Timer triggers periodic poll to retrieve any changes server side.
    Timer {
        id: timer
        interval: main.periodicPolls
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: { doPoll(); }
    }

    function doPoll() {
        json = "";
        Utils.poll(source, onReady, details);
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

        // Link to full dataset.
        fullDataset = jsonObject["download_url"].toString();
    }
    
    

    // Model that holds detail items to be displayed.
    ListModel { id: detailListModel }

    // Action bar
    ActionBar {
        id: detailsActionBar
        width: main.width
        backButton.visible: true
        backState: main.state
    }
    ImageButton {
        id: dataset
        visible: fullDataset.length > 0
        anchors.top: detailsActionBar.bottom
        anchors.left: rerun.right
        anchors.leftMargin: 5;
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("View Dataset")
        onClicked: {
            mainLoader.source = "Dataset.qml";
            mainLoader.item.url = fullDataset;
            mainLoader.item.actionBarTitle = detailsActionBar.actionBarTitle;
        }
    }


    ImageButton {
        id: rerun
        visible: fullDataset.length > 0
        anchors.top: detailsActionBar.bottom
        
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: "Rerun job"
        onClicked: {
            //Utils.rerunJob();
            mainLoader.source = "RunJob.qml";
        }
    }


    ListView {
        id: detailList
        anchors.top: rerun.bottom
        width: main.width
        height: main.height - detailsActionBar.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        model: detailListModel
        delegate: Rectangle {
            id: historyItem
            // Alternating colour.
            color: index%2 == 0 ? stateColour : stateColourAlt
            width: parent.width
            // Set height to height of text, plus a bit of margin.
            height: textTitle.height > textData.height ? textTitle.height + mmItemMargin : textData.height + mmItemMargin

            Text {
                id: textTitle
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
                width: Math.max(160, paintedWidth)
                text: model.fieldName + ":"
                font.pointSize: largeFonts ? 16 : 12
                font.bold: true
            }
            Text {
                id: textData
                anchors.left: textTitle.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideMiddle
                text: model.fieldData
                font.pointSize: largeFonts ? 16 : 12
                textFormat: Text.RichText
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainLoader.source = "DetailZoomView.qml";
                    mainLoader.item.color = historyItem.color;
                    mainLoader.item.title = model.fieldName;
                    mainLoader.item.itemData = model.fieldData;
                    mainLoader.item.actionBarTitle = detailsActionBar.actionBarTitle;
                }
            }
        }
    }

}
