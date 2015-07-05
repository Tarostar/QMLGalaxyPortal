import QtQuick 2.3

Rectangle {
    // Acccess to override default colours.
    property int margin : mmItemMargin

    height: 1

    Rectangle { id: topLine; color: "black"; width: parent.width; height: 1; anchors.verticalCenter: parent.verticalCenter }
}
