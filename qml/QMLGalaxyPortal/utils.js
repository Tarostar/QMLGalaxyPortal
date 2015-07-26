function itemColour(state, selected)
{
    // Returns colour coding based on item state (from json data) and whether item is in a selected state (e.g. clicked or mouse hover).

    if (state === "ok")
        return selected ? "#94CC94" : "#AFF1AF";

    if (state === "error")
        return selected ? "red" : "tomato";

    if (state === "discarded")
        return selected ? "gray" : "lightgray";

    if (state === "empty")
        return selected ? "lemonchiffon" : "white";

    if (state === "failed_metadata")
        return selected ? "#c1cdc1" : "Honeydew";

    if (state === "new")
        return selected ? "#cdc9c9" : "#f5f5f5";

    if (state === "paused")
        return selected ? "yellow" : "gold";

    if (state === "queued")
        return selected ? "#CCCCCC" : "#EEEEEE";

    if (state === "resubmitted")
        return selected ? "cyan" : "lightcyan";

    if (state === "running")
        return selected ? "#D3D3AB" : "#FFFFCC";

    if (state === "setting_metadata")
        return selected ? "lemonchiffon" : "ivory";

    if (state === "upload")
        return selected ? "lemonchiffon" : "ivory";

    // default
    return selected ? "lemonchiffon" : "ivory";
}


function getResolutionIndex(pixelDensity) {

    // images for different device densities are determined by the device's pixel density
    if (pixelDensity < 6.3)
        return 0; // mdpi
    else if (pixelDensity < 9.5)
        return 1; // hdpi
    else if (pixelDensity < 12.6)
        return 2; // xhdpi

    // anything larger use xxhdpi
    return 3;


}

function getScreenWidthIndex(width) {
    // width we use for images that want to be full screen width uses closest category
    if (width <= 400)
        return 0;
    else if (width <= 540)
        return 1;
    else if (width <= 812)
        return 2;
    else if (width <= 1152)
        return 3;
    else if (width <= 1600)
        return 4;
    else if (width <= 2240)
        return 5;
    else // any larger screen width uses the 2560 image width
        return 6;
}

// Poll server using the global XMLHttpRequest (note: does not enforce the same origin policy).
function poll(source, onReady, parentID, authorizationHeader, timeoutInterval) {
    if (timeoutInterval === undefined) {
        timeoutInterval = 5000;
    }

    var request = new XMLHttpRequest;

    // Since XMLHttpRequest does not support timeout, dynamically create a timer object for this from QML string.
    var pollTimer = Qt.createQmlObject("import QtQuick 2.3; Timer {interval:" + timeoutInterval +"; repeat: false; running: true;}", parentID, "PollTimer");

    // Connect the "triggered" signal to timeout function
    pollTimer.triggered.connect(function() {
        // Abort and call onReady without parameters which will report error.
        request.abort();
        onReady();
    });

    // Do the Request.

    request.open("GET", source);

    if (authorizationHeader !== undefined && authorizationHeader !== null) {
        request.setRequestHeader("Authorization", authorizationHeader);
    } else {
        request.setRequestHeader("Content-type", "application/json");
    }

    request.setRequestHeader('Accept-Language', 'en');
    request.onreadystatechange = function(){ pollTimer.stop(); onReady(request); };
    request.send();
}


// Hacky function that finds the id of the job that created a dataset in the history
function findJobFromDatasetID(datasetID, callback){
	console.info("Find job from dataset ID");
	var currentHistoryID = main.currentHistoryID;
	
	// Itereate over every job in this history, find the job that created dataset with id datasetID
	sendRequest("jobs/", "history_id=" + currentHistoryID, {}, "GET", function(data){ 
		data = JSON.parse(data);
		
		
		var jobIDs = [];
		for(var i = 0; i < data.length; i++){
			var job = data[i];
			jobIDs.push(job.id);
		}
		
		
		for (var i = 0; i < jobIDs.length; i++){
			var jobID = jobIDs[i];
			
			sendRequest("jobs/" + jobID, "", {}, "GET", function(jobInfo){ 
				jobInfo = JSON.parse(jobInfo);
				
				// Dirty way: Search for output id in string of output:
				if(JSON.stringify(jobInfo.outputs).indexOf(datasetID) !== -1){ 
					callback(jobID);
					i = jobIDs.length;
					return;
				}
				else{
					console.log("No hit with " + datasetID + " on " + JSON.stringify(jobInfo.outputs));
				}
			}, false);	
		}
	});
}



// Send request to the galaxy api
function sendRequest(url, get_params, post_params, type, onSuccess, async) {
	console.log("SendRequest");
	if (type === undefined) {
		type = "GET";
	}
	
	if (async === undefined) {
		async = true;
	}
	
	if (onSuccess === undefined) {
		onSuccess = function(){}; 
	}
	
	
	// Add api key to params
	get_params += "&key=" + dataKey;
	
	// Start a new XMLHttpRequest
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onload = function() { console.log("Success"); onSuccess(xmlhttp.responseText); }
	xmlhttp.onerror = function(){ console.log("xmlhtt error"); };
	
	xmlhttp.onreadystatechange = function () {
		
		if (xmlhttp.readyState != 4) return;
		
		if(xmlhttp.readyState == 4) onSuccess(xmlhttp.responseText); 
		
		/*
		if (xmlhttp.status != 200 && xmlhttp.status != 304) {
			console.log('HTTP error ' + xmlhttp.status + ", " + xmlhttp.responseText);
			return;
		}
		*/
		
	}
	
	
	xmlhttp.open(type, dataSource + "/api/" + url + "?" + get_params, async);
	
	if(type == "POST"){
		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded;charset=UTF-8;");
	}
	
	xmlhttp.send(post_params);

}

/**
*
* Android Pixel Density Categories
* dpi and dots per mm, and standard multiplier for the size
*
* ldpi (low) ~120dpi (4.7 d/mm) x0.75
* mdpi (medium) ~160dpi (6.30 d/mm) x1
* hdpi (high) ~240dpi  (9.5 d/mm) x1.5
* xhdpi (extra-high) ~320dpi (12.6 d/mm) x2
* xxhdpi (extra-extra-high) ~480dpi (18.9 d/mm) x3
* xxxhdpi (extra-extra-extra-high) ~640dpi (25 d/mm) x4
*/

/**
* A typical Android item is 48dp high (translates to 9mm)
*
* ldpi: 36 (width: 320, 480)
* mdpi: 48 (width: 480, 600, 1024, 1280)
* hdpi: 72 (width: 1920)
* xhdpi: 96 (width: 2560)
*/

/**
* Android typical screen widths
*
* 320dp: a typical phone screen (240x320 ldpi, 320x480 mdpi, 480x800 hdpi, etc).
* 480dp: a tweener tablet like the Streak (480x800 mdpi).
* 600dp: a 7” tablet (600x1024 mdpi).
* 720dp: a 10” tablet (720x1280 mdpi, 800x1280 mdpi, etc).
*/

/*
*
* Android: typical screen sizes for different pixel density categories
*
* http://developer.android.com/guide/practices/screens_support.html#DeclaringTabletLayouts
* ldpi, mdpi: 320x480
* ldpi, mdpi, hdpi: ->480x800<-
* mdpi, hdpi: 600x1024
* mdpi: 1024x768 (1280x768, 1280x800)
* hdpi: 1920x1200 (1920x1152)
* xhdpi: 2560x1600 (2048x1536, 2560x1536)
*/
