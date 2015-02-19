import QtQuick 2.3

Rectangle {
    Text {
        id: welcome
        anchors.top: parent.top
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        text: qsTr("Welcome")
        font.pointSize: largeFonts ? 17 : 12
        font.bold: true
    }
    Text {
        id: url
        anchors.top: welcome.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        text: qsTr("Current Galaxy URL: ") + dataSource
        font.pointSize: largeFonts ? 16 : 11
    }
    Text {
        id: httpStatus
        anchors.top: url.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        text: dataSource.length > 0 && dataKey.length > 0 ? "Connection Status: " + jsonHistoriesModel.error : "Please set Galaxy URL and API Key"
        font.pointSize: largeFonts ? 16 : 11
        color: jsonHistoriesModel.error.length > 0 ? "red" : "black"
        font.bold: true
    }
    Text {
        id: instructions
        anchors.top: httpStatus.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        text: qsTr("Select the cog wheel on the right in the top action bar to configure.")
        font.pointSize: largeFonts ? 16 : 11
    }
    Text {
        id: userguide
        anchors.top: instructions.bottom
        anchors.topMargin: 30
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        text: qsTr("Download user guide:")
        font.pointSize: largeFonts ? 16 : 11
    }
    Text {
        id: userguideURL
        anchors.top: userguide.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        text: "<a href=\"https://github.com/Tarostar/QMLGalaxyPortal/blob/master/GalaxyPortalUserGuide.pdf?raw=true\">https://github.com/Tarostar/QMLGalaxyPortal/blob/master/GalaxyPortalUserGuide.pdf?raw=true</a>"
        font.pointSize: largeFonts ? 13 : 9
    }
}
