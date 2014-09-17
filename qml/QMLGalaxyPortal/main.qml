import QtQuick 2.3
//import QtQuick.XmlListModel 2.0
import QtQuick.Window 2.2

// http://qt-project.org/wiki/JSONListModel
// https://github.com/kromain/qml-utils

Rectangle {
    id: screen
    width: Screen.width
    height: Screen.height

    /*XmlListModel {
        id : listmodel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=atom&tags=cats"
        query: "/feed/entry"
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom';"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "imagesource"; query: "link[@rel=\"enclosure\"]/@href/string()" }
    }*/

    /**
    * Density Categories in dpi and dots per mm + multiplier for sizes
    * ldpi (low) ~120dpi (4.7 d/mm) x0.75
    * mdpi (medium) ~160dpi (6.30 d/mm) x1
    * hdpi (high) ~240dpi  (9.5 d/mm) x1.5
    * xhdpi (extra-high) ~320dpi (12.6 d/mm) x2
    * xxhdpi (extra-extra-high) ~480dpi (18.9 d/mm) x3
    * xxxhdpi (extra-extra-extra-high) ~640dpi (25 d/mm) x4
    */

    /**
    * Item at mdpi
    * item: 9mm (48dp) height and screen-width wide
    * ldpi: 36 (width: 320, 480)
    * mdpi: 48 (width: 480, 600, 1024, 1280)
    * hdpi: 72 (width: 1920)
    * xhdpi: 96 (width: 2560)
    */

    /**
    * Typical screen widths
    * 320dp: a typical phone screen (240x320 ldpi, 320x480 mdpi, 480x800 hdpi, etc).
    * 480dp: a tweener tablet like the Streak (480x800 mdpi).
    * 600dp: a 7” tablet (600x1024 mdpi).
    * 720dp: a 10” tablet (720x1280 mdpi, 800x1280 mdpi, etc).
    */

    // support different widths?
    // http://developer.android.com/guide/practices/screens_support.html#DeclaringTabletLayouts
    // ldpi, mdpi: 320x480
    // ldpi, mdpi, hdpi: ->480x800<-
    // mdpi, hdpi: 600x1024
    // mdpi: 1024x768 (1280x768, 1280x800)
    // hdpi: 1920x1200 (1920x1152)
    // xhdpi: 2560x1600 (2048x1536, 2560x1536)

    // images for different device densities are determined by the device's pixel density
    property var res: ["ldpi", "mdpi","hdpi","xhdpi"]
    readonly property int resIndex: {
        if (Screen.pixelDensity < 6.3) // ldpi
            0
        else if (Screen.pixelDensity < 9.5) // mdpi
            1
        else if (Screen.pixelDensity < 12.6) // hdpi
            2
        else // anything larger use xhdpi
            3
        // TODO: add xxhdpi and xxxhdpi
    }

    // width we use for images that want to be full screen width uses closest category
    property var devwidth: ["320", "480", "600", "1024", "1280", "1920", "2560"]
    readonly property int widthIndex: {
        if (Screen.width <= 400)
            0
        else if (Screen.width <= 540)
            1
        else if (Screen.width <= 812)
            2
        else if (Screen.width <= 1152)
            3
        else if (Screen.width <= 1600)
            4
        else if (Screen.width <= 2240)
            5
        else // any larger screen width uses the 2560 image width
            6
    }

    JSONListModel {
        id: jsonModel1
        //source: "jsonData.txt"
        //query: "$.store.book[*]"
        source: "https://usegalaxy.org/api/histories?key=218afad6146272c7c771688e10fb9884"
        query: "$.[*]"
    }

    transitions: [
        Transition {
            NumberAnimation {
                target: screenlayout
                easing: Easing.OutCubic
                property: "x"
                duration: 500
            }
        }
    ]
    states: [
        State {
            name: "view"
            PropertyChanges {
                target: screenlayout
                x: -screen.width
            }
        }
    ]

    Row {
        id: screenlayout
        ListView {
            id: listview
            width: screen.width
            height: screen.height
            //model: 20
            //model: listmodel
            model: jsonModel1.model

            delegate: Image {
                width: parent.width
                // pixelDensity: the number of physical pixels per millimeter.
                height: Screen.pixelDensity * 9;
                //source: "images/gradient_invertedcenternarrow.png"
                source: "Images/" + res[resIndex] + "/item_" + devwidth[widthIndex] + ".png"

                Image {
                    id: thumbnail
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    height: parent.height / 2
                    width: parent.height / 2
                    fillMode: Image.PreserveAspectFit
                    source: "images/QMLGalaxyPortal80.png"
                    //source: imagesource
                    //onSourceChanged: print(imagesource)
                }
                Text {
                    id: itemtitle
                    anchors.left: thumbnail.right
                    anchors.right: parent.right
                    anchors.leftMargin: 20
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideMiddle
                    text: Screen.pixelDensity + " => x9 = " + Screen.pixelDensity * 9
                    // text: name + " - " + url
                    font.pixelSize: 20
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: screen.state = "view"
                }
            }
        }
        Text {
            id: details
            width: screen.width
            height: screen.height
            text: "Logical: " + Screen.logicalPixelDensity.toFixed(2) + " dots/mm (" + (Screen.logicalPixelDensity * 25.4).toFixed(2) + " dots/inch)"
            // Behavior on opacity { NumberAnimation {}}
            MouseArea {
                anchors.fill: parent
                onClicked: screen.state = ""
            }
        }
    }
}

