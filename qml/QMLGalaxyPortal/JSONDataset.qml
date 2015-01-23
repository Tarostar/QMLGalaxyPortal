import QtQuick 2.3

Item {
    id: datasetItem

    // URL to connect to.
    property string source: ""

    // JSON data returned by poll.
    property string json: ""

    // Text to display as result of JSON.
    property string text: ""

    property string textMe: "test"

    // Array of all the fields displayed.
    property variant fields

    // Name of job item for content.
    property string name: ""

    // Poll frequencey - if zero then does not poll and only retrieves data when source changes.
    property int pollInterval: 0

    // Poll for data when source changes.
    onSourceChanged: {
        // Remove JSON data from previous poll
        json = "";

        poll()

        // Kick timer if enabled.
        if (pollInterval > 0)
            timer.start();
    }

    // Timer triggers periodic poll to retrieve any changes server side.
    Timer {
        id: timer
        interval: pollInterval
        repeat: true
        onTriggered: { poll(); }
    }

    // Poll server using the global XMLHttpRequest (note: does not enforce the same origin policy).
    function poll() {
        json = "";

        // update field list before polling
        updateFieldArray();

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
                    // Report error.
                    datasetItem.text = xhr.statusText;
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
            datasetItem.text = "Timed out after " + httpTimeout.interval / 1000 + " seconds.";
        }
    }

    // Update JSON data when source or fields changes.
    onJsonChanged: if (json.length > 0) updateJSONText(JSON.parse(json))

    function updateJSONText(jsonData) {
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
            /*datasetItem.fields.push("metadata_data_lines");
            datasetItem.fields.push("history_content_type");
            datasetItem.fields.push("file_ext");
            datasetItem.fields.push("file_size");*/

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
