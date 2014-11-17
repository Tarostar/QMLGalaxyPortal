/* JSONListModel - QML ListModel with JSON
 *
 * Based on:
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 *
 * This version has been extended and modified by Claus Bornich:
 * - JSONPath JavaScript regular expression parsing removed (not needed).
 * - Optional: Added Timer for periodic updates of the model.
 * - Optional: updateJSONModel can only clear model when there is data.
 * - Added comments and refactored code to remove redundant variables and improve formatting.
 *
 */

import QtQuick 2.3

Item {
    // URL to connect to.
    property string source: ""

    // JSON data returned by poll.
    property string json: ""

    // Set if XMLHttpRequest returns error or times out.
    property string error: "loading..."

    // Poll frequencey - if zero then does not poll and only retrieves data when source changes.
    property int pollInterval: 0

    // Clear model when "json" string is empty.
    // Setting this to false prevents list from being reset if polls occasionally return no data.
    property bool clearOnEmptyData: true

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    // Poll for data when source changes.
    onSourceChanged: {
        poll()

        // Kick timer if enabled.
        if (pollInterval > 0)
            pollTimer.start();

    }

    // Timer triggers periodic poll to retrieve any changes server side.
    Timer {
        id: pollTimer
        interval: pollInterval
        repeat: true
        onTriggered: { poll(); }
    }

    // Poll server using the global XMLHttpRequest (note: does not enforce the same origin policy).
    function poll() {
        json = "";
        error = "loading...";
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.setRequestHeader("Content-type", "application/json");
        // Potentially expand to support other languages than english.
        xhr.setRequestHeader('Accept-Language', 'en');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                httpTimeout.running = false;
                if (xhr.status === 200) {
                    error = "";
                    json = xhr.responseText;
                }
            } else if (xhr.readyState === XMLHttpRequest.LOADING) {
                // Need to set errors and status during load due to QTBUG-21706
                if (xhr.status !== 200) {
                    var jsonObject = JSON.parse(xhr.responseText);
                    error = jsonObject["err_msg"] + " [" + xhr.status + "]";
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
            error = "Timed out after " + httpTimeout.interval / 1000 + " seconds.";
        }
    }

    // JSON data has changed - update model.
    onJsonChanged: updateJSONModel();

    // If we have json data - update the model.
    function updateJSONModel() {
        if (json !== "" || clearOnEmptyData)
            jsonModel.clear();

        if (json === "")
            return;

        var objectArray = JSON.parse(json);
        for ( var object in objectArray ) {
            jsonModel.append(objectArray[object]);
        }
    }
}
