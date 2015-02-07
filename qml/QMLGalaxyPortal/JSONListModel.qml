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
import "utils.js" as Utils

Item {
    id: jsonListModel

    // URL to connect to.
    property string source: ""

    // JSON data returned by poll.
    property string json: ""

    // Set if XMLHttpRequest returns error or times out.
    property string error: "loading..."

    // Poll frequencey - if zero then does not poll and only retrieves data when source changes.
    property int pollInterval: 0

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    function onReady(request) {

        if (request === undefined) {
            error = "Timed out after five seconds.";
            return;
        }

        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                error = "";
                json = request.responseText;
            }
        } else if (request.readyState === XMLHttpRequest.LOADING) {
            // Need to set errors and status during load due to QTBUG-21706
            if (request.status !== 200) {
                var jsonObject = JSON.parse(request.responseText);
                error = jsonObject["err_msg"] + " [" + request.status + "]";
            }
        }
    }

    onPollIntervalChanged: {
        // Set C++ background thread tick interval which will provide periodic polls (divide to go from ms to seconds).
        Bridge.setTickInterval(pollInterval / 1000);
    }

    // Poll for data when source changes.
    onSourceChanged: {
        jsonModel.clear();
        if (source.length > 0) {
            doPoll()
        }
    }

    // Connection to C++ background thread.
    Connections {
        target: Bridge
        onDoWork: { doPoll();}
    }

    // Timer triggers periodic poll to retrieve any changes server side.
    Timer {
        id: pollTimer
        interval: pollInterval
        repeat: true
        onTriggered: { doPoll(); }
    }

    function doPoll() {
        json = "";
        error = "loading...";
        Utils.poll(source, onReady, jsonListModel);
    }

    // JSON data has changed - update model.
    onJsonChanged: updateJSONModel();

    // If we have json data - update the model.
    function updateJSONModel() {

        if (json === "")
            return;

        var objectArray = JSON.parse(json);

        // First remove any items from the model that no longer exist.
        for (var i = jsonModel.count - 1; i >= 0; i--) {
            var bFound = false;
            for ( var object in objectArray ) {
                if (jsonModel.get(i).id === objectArray[object].id) {
                    bFound = true;
                    break;
                }
            }

            if (!bFound) {
                jsonModel.remove(i);
            }
        }

        // Now update model and insert any new items.
        var index = 0;
        for ( object in objectArray ) {
            // Check if item exists at exactly the current index.
            if (index >= jsonModel.count) {
                // We are beyond the current model (or model empty).
                jsonModel.append(objectArray[object]);
            } else if (jsonModel.get(index).id === objectArray[object].id) {
                // Exists - check state and update.
                checkState(jsonModel.get(index).state, objectArray[object].state);
                jsonModel.set(index, objectArray[object]);
            } else {
                // Did not exists, see if exists at a different position.
                var bFound = false;
                for (i = 0; i < jsonModel.count; i++) {
                    if (jsonModel.get(i).id === objectArray[object].id) {
                        // Found it, move it, check state and update.
                        bFound = true;
                        jsonModel.move(i, index, 1);
                        checkState(jsonModel.get(index).state, objectArray[object].state);
                        jsonModel.set(index, objectArray[object]);
                        break;
                    }
                }

                if (!bFound) {
                    // Did not find it, so simply insert it.
                    jsonModel.insert(index, objectArray[object]);
                }
            }

            index++;
        }
    }

    function checkState(currentState, newState) {
        if (currentState === undefined || currentState.length === 0 || newState === undefined || newState.length === 0) {
            return;
        }

        // Check if stat (ok, running, queued, error) changed.
        if (currentState !== newState) {
            // Changed - if current state was running then play job completion/error alert.
            if (currentState === "running") {
                alertSound.play();
            } else {
                notificationSound.play();
            }
        }
    }
}
