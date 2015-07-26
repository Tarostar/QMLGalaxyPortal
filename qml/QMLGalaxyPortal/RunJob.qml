import QtQuick 2.3
import QtQuick.Window 2.2
import QtWebKit 3.0
//import QtWebKit.experimental 1.0
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

	property string toolId: ""
	
	onSourceChanged: {
	
		// Assume we are rerunning a job
		//loadHtmlToWebview(loadToolHtml());
		
		
		loadHtmlToWebview("<p>Loading data from previous job...</p>");
		rerunJob();
	}
	
	
	

	function loadHtmlToWebview(htmlCode){
		webView.loadHtml(htmlCode); //"<h1>Test</h1><p><a onclick=\"document.title='test';\">Test</a></p>");
		console.log("Loading html");
	
	}
	

	function getDataSets(){
		
		var out = null;
		Utils.sendRequest("histories/" + main.currentHistoryID + "/contents/datasets/", "", "", "GET", function(data){
			out = JSON.parse(data);
		}, false);
		return out;
	}
	
	// Returns the html needed to display a tool
	function loadToolHtml(oldJobData, toolID){
		
		var currentHistoryID = main.currentHistoryID; //"f597429621d6eb2b"
		
		
		var html = "";
		
		html += "<!html>" +
				"<style type='text/css'>" + 
				"body{ background-color: #fffff0; }" +
				"</style>"+
				"<body><form>";
		
		console.log("tool-id: " + toolID);
		
		//sendRequest("tools/addValue/build/", "history_id=" + currentHistoryID + "&inputs={\"dataset\":{\"id\":\"2d9035b3fc152403\",\"src\":\"hda\"},\"name\":\"input1\"}", "", "GET", function(data){
		Utils.sendRequest("tools/" + toolID + "/build/", "history_id=" + currentHistoryID, "", "GET", function(data){
		
			//console.log("Tool built: " + data);
			data = JSON.parse(data);
			html += "<h2>" + data.name + "</h2>";
			
			var inputs = data.inputs;
			console.log(JSON.stringify(inputs));
			
			for (var i = 0; i < 100; i++){
				var input = data.inputs[i];
				if(input == undefined){
					break;
				}
				
				//console.log(oldJobData.params)
				// Get preset value from old job
				//if (oldJobData.params[input.name] != undefined) {
				//	console.log("Param " + input.name + " found.");
				//}
				
				
				// Html for type=data is missing, so we have to create it:
				if(input.type == "data"){
					var input_html = "<select name='" + input.name + "'>";
					
					var datasets = getDataSets();
					for(var j = 0; j < datasets.length; j++){
						var dataset = datasets[j];
						if(dataset.deleted) continue; 
						
						var selected = "";
						/*
						console.log("old inputs: " + JSON.stringify(oldInputs));
						if(oldInputs[input.name] !== undefined){
						
							if(dataset.id == oldInputs[input.name].id){
								selected = "selected";
							} 
						}
						*/
						
						input_html += "<option " + selected + " value='" +  dataset.id + "'>" + dataset. name + "</option>";
					}
					
					input_html += "</select>";
				}
				// Other html seems to be there, so just decode it
				else{	
					var input_html = decodeURIComponent(input.html);
				}
				
				html += "<p>" + input.label + "</p>" + "<p>" + input_html + "</p>";
				
				
				
				console.log("Input " + i + ": " + input_html);
			}
				
			html += data.help;
		
		}, false);
			
		
		html += "<p><input type='button' onclick='postForm();' value='Run tool!' name='run'></p>";
		html += "</body>";
		
		// Add some javascript that will return the form to qml through document.title
		html += "<script>";
		html += "" +
				"function postForm(){" +
				"	var form = [];" +
				"		" +
				"	var inputs = document.getElementsByTagName('input');" +
				"	for (var i = 0; i < inputs.length; i++){" +
				"		form.push([inputs[i].name, inputs[i].value]);" +
				"	}" +
				"	var inputs = document.getElementsByTagName('select');" +
				"	for (var i = 0; i < inputs.length; i++){" +
				"		form.push([inputs[i].name, inputs[i].value]);" +
				"	}" +
				"	console.log(JSON.stringify(form));" +
				"	document.title = JSON.stringify(form);" +
				"}";

		html += "</script></html>";

		return html;
	}


	
	// Simple function for rerunning a job. 
	function rerunJob() {
		// Get inputs from previous job first, 
		// then create new job with the same parameters


		// First, find the old job id from the id of this data set
		var oldJobId = main.currentJobID;
		
		Utils.findJobFromDatasetID(main.currentJobID, function(oldJobId){
			
			var currentHistoryId = main.currentHistoryID;			
			console.log("Rerunning job: " + oldJobId);
			
			// 1: Get prev job info
		
			Utils.sendRequest("jobs/" + oldJobId + "/", "", {}, "GET", function(data){ 
				
				console.log("Prev job: " + data) 
				data = JSON.parse(data);
				toolId = data.tool_id;
				
				// 2: Get prev job input data (to reuse)
				Utils.sendRequest("jobs/" + oldJobId + "/inputs", "", {}, "GET", function(data){ 
					
					console.log("Prev job inputs: " + data) 
					data = JSON.parse(data);
					var inputs = data[0]; // [0] because it is in an array for some reason
					
					console.log("tool_ID:" + toolId);
					var tool_html = loadToolHtml(data, toolId);
					loadHtmlToWebview(tool_html);
					
					
					/*
					// 3: Send a post request to start a new job using this data
					var postData = "tool_id=" + toolId + "&tool_version=&history_id=" + currentHistoryId + "&inputs=" + JSON.stringify(inputs);
					console.info("postData: " + postData);
					Utils.sendRequest("tools/", "", postData, "POST", function(data){
						console.info("Request for starting new job sent. Returned: " + data);
					});
					*/
				});
			});
		
		});
		
		
	}


	// Sends a POST request to /api/jobs/ with the given parameters to start a job
	function startJob(form){
		var postData = "tool_id=" + toolId + "&tool_version=&history_id=" + main.currentHistoryID; // + "&inputs=" + JSON.stringify(inputs);
		
		var test = {
            "id": "4ff6f47412c3e65e", 
            "src": "hda", 
            "uuid": "712fe788-b2e4-4acb-92e8-427aabb59ae1"
        };
        
        var test2 = {
                        "id": "4ff6f47412c3e65e", 
                        "src": "hda"
                    };
		
		var inputs = {};
		for (var i = 0; i < form.length; i++) {
			
			if(form[i][0] == "input"){
				inputs["input"] = test2; //"4ff6f47412c3e65e"; //JSON.stringify(test);
				continue;
			}
			
			
			inputs[form[i][0]] = form[i][1]; //inputs.push([form[i][0], form[i][1]]); // "&" + form[i][0] + "=" + form[i][1];
		}
		
		/*
		inputs["src"] = "hda";
		inputs["id"] = "4ff6f47412c3e65e";
		inputs["uuid"] = "712fe788-b2e4-4acb-92e8-427aabb59ae1";
		*/
		
		postData += "&inputs=" + JSON.stringify(inputs);
		//postData += "&inputs=" + JSON.stringify(test);
		
		
		//var inputs = '{"exp" : "2"}';
		
		//postData += "&inputs=" + inputs;
		
		console.info("postData: " + postData);
		
		
		Utils.sendRequest("tools/", "", postData, "POST", function(data){
			console.info("Request for starting new job sent. Returned: " + data);
			
			if(data.jobs != undefined){
				infoText.text = "Job has successfully been re-runned.";
			}
			
		});
		
		
	
	}
	
	
	
    // Action bar
    ActionBar {
        id: detailsActionBar
        width: main.width
        backButton.visible: true
        backState: main.state
    }
    
	Text {
		id: infoText
		anchors.top: detailsActionBar.bottom
		anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
		text: ""
		font.pointSize: largeFonts ? 20 : 15
		font.bold: false
	}

	
	WebView {
		id: webView
		anchors.top: detailsActionBar.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		height: main.height

	   
		onTitleChanged: {
			var data = title;
			console.log("Data recieved from webview: " + data);
			
			if(data != ""){
				// assume the form is posted
				startJob(JSON.parse(data));
			}
		}

       
    }
    


}
