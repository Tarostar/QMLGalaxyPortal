import QtQuick 2.3
import "utils.js" as Utils

Item {
    id: datasetItem

    // URL to connect to.
    property string source: ""

    // JSON data returned by poll.
    property string json: ""

    // Text to display as result of JSON.
    property string text: ""

    // Array of all the fields displayed.
    property variant fields

    // Name of job item for content.
    property string name: ""

    // Poll frequencey - if zero then does not poll and only retrieves data when source changes.
    property int pollInterval: 0

    property string fullDataset: ""

    function onReady(request) {
        if (request === undefined) {
            datasetItem.text = "Timed out after five seconds....";
            return;
        }

        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                json = request.responseText;
            } else {
                // Report error.
                datasetItem.text = request.statusText;
            }
        }
    }

    onPollIntervalChanged: {
        // Kick timer if enabled.
        if (pollInterval > 0) {
            timer.start();
        }
    }

    // Poll for data when source changes.
    onSourceChanged: {
        // Remove JSON data from previous poll
        json = "";
        datasetItem.text = "";

        if (source.length > 0) {
            doPoll()
        }
    }

    // Timer triggers periodic poll to retrieve any changes server side.
    Timer {
        id: timer
        interval: pollInterval
        repeat: true
        onTriggered: { doPoll(); }
    }

    function doPoll() {
        json = "";

        // Update field list before polling.
        updateFieldArray();

        Utils.poll(source, onReady, datasetItem);
    }

    // Update JSON data when source or fields changes.
    onJsonChanged: {
        if (json.length > 0) {
            updateJSONText(JSON.parse(json))
            main.doJobTransition();
        }
    }

    function updateJSONText(jsonData) {

        if (jsonData["download_url"])
            fullDataset = jsonData["download_url"].toString();

        datasetItem.text = "";
        // Compose string for each field in field array which exists in the json data (otherwise ignored).
        fields.forEach(function(field) {
            if (typeof jsonData[field] === "boolean" || typeof jsonData[field] === "number" ||
                    typeof jsonData[field] === "string" || typeof jsonData[field] === "symbol") {
                if (jsonData[field].toString().length > 0) {
                    datasetItem.text += " <b>" + field + "</b>: " + jsonData[field].toString();
                }
            }
        });

        // Set name property to job name - if exists
        if (jsonData["name"])
            datasetItem.name = jsonData["name"];

    }

    // Init default field array at startup.
    Component.onCompleted:{ updateFieldArray(); }

    function updateFieldArray() {
        var fieldArray = [];

        if (main.fieldList.length < 1) {
            // Default fields initialised.
            fieldArray.push("misc_blurb");
            fieldArray.push("data_type");
            fieldArray.push("genome_build");
            fieldArray.push("update_time");

            // Set field list to contain the default list
            main.fieldList = fieldArray.join();
        }
        else {
            // Init field array from fieldList.
            fieldArray = main.fieldList.split(',');
        }

        datasetItem.fields = fieldArray;
    }

}
