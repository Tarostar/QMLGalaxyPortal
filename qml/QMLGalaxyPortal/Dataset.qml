import QtQuick 2.3
import QtQuick.Window 2.2
import "utils.js" as Utils

Rectangle {
    id: dataset
    width: main.width
    height: main.height

    property alias actionBarTitle: datasetActionBar.actionBarTitle
    property string url: ""
    property string source: dataSource + url + "?key=" + dataKey;
    property string fullDataset: ""
    property string displayDataset: ""
    property string topMessageText: ""
    property int curPage: 1
    property int maxPage: 1

    function onReady(request) {

        if (request === undefined) {
            textData.text = "Timed out after five seconds.";
            return;
        }

        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200 || request.status === 206) {
                // Data is application/octet-stream and should be formatted.
                // Just display raw data for now.
                if (request.getResponseHeader ("Content-Type") === "application/octet-stream") {
                    // It often also sends HTML data before or after, so this ensures we only care about the octet data

                    // Only show up to the first 100 000 characters (and inform user if cutoff)
                    fullDataset = request.responseText;
                    var dataLen = request.responseText.length;
                    curPage = 1;
                    maxPage = Math.ceil(dataLen / 100000);
                    if (maxPage == curPage) {
                        displayDataset = fullDataset;
                        return;
                    }
                    
                    if (request.status === 206) {
						topMessageText = "This dataset is larger than 5 MB. Only the first 5 MB are loaded to save bandwidth."
					}

                    // More than one page, set display data for current page.
                    updateDisplayedData();
                }
            } else {
                displayDataset = "Error retrieving data. The server responded: " + request.status;
            }
        }
    }

    // Sets display data for current page.
    function updateDisplayedData() {

        displayDataset = "loading data...";

        var start = 100000 * (curPage - 1);
        var end = start + 100000;
        if (end > fullDataset.length) {
            end = fullDataset.length;
        }

        displayDataset = fullDataset.substring(start, end)
    }

    // Poll for data when source changes.
    onSourceChanged: {
        // Poll when source url changes (we do not update this as result data is not expected to change once received).
        displayDataset = "requesting data...";
        Utils.poll(source, onReady, dataset, null, 30000, 5000000);
    }

    ActionBar {
        id: datasetActionBar
        width: parent.width
        backButton.visible: true
        copyButton.visible: true
        backState: main.state
        backSource: "";
        onCopy: {
            datasetRaw.selectAll();
            datasetRaw.copy();
        }
    }
    ImageButton {
        id: nextButton
        visible: curPage < maxPage
        anchors.top: datasetActionBar.bottom
        anchors.right: parent.right
        anchors.rightMargin: mmItemMargin
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("Next Page >")
        onClicked: {
            curPage = curPage + 1;
            if (curPage > maxPage) {
                curPage = maxPage;
            }
            updateDisplayedData();
        }
    }
    ImageButton {
        id: prevButton
        visible: curPage > 1
        anchors.top: datasetActionBar.bottom
        anchors.left: parent.left
        anchors.leftMargin: mmItemMargin
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("< Previous Page")
        onClicked: {
            curPage = curPage - 1;
            if (curPage < 1) {
                curPage = 1;
            }
            updateDisplayedData();
        }
    }
    Flickable {
        anchors.top: nextButton.visible ? nextButton.bottom : prevButton.visible ? prevButton.bottom : datasetActionBar.bottom
        width: parent.width
        height: parent.height - datasetActionBar.height - (nextButton.visible ? nextButton.height : prevButton.visible ? prevButton.height : 0)
        contentWidth: textData.width
        contentHeight: pageTitle.height + textData.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Text {
            id: topMessage
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
            text: topMessageText
            font.pointSize: largeFonts ? 16 : 12
        }
        Text {
            id: pageTitle
            anchors.left: parent.left
            anchors.top: topMessage.bottom
            anchors.margins: 10
            text: "Page:" + curPage + " of " + maxPage
            font.pointSize: largeFonts ? 16 : 12
            font.bold: true
        }
        Text {
            id: textData
            anchors.left: parent.left
            anchors.top: pageTitle.bottom
            anchors.margins: 10
            text: displayDataset
            font.pointSize: largeFonts ? 16 : 12
        }
        // Hidden copy of field for copying (Text fields don't have access to clipboard copy/cut/paste)
        EditBox {
            id: datasetRaw
            visible: false
            anchors.left: parent.left
            anchors.top: textData.bottom
            anchors.margins: 10
            readOnly: true
            text: textData.text
        }
    }
}
