import QtQuick 1.0
import "main.js" as MainFunctions

Rectangle {
    id: root
    width: 800
    height: 700

    Row {
        id: mainRow
        anchors{top:parent.top; left:parent.left}
        Repeater {
            model: mainData.tableCount1
            ListView {
                id: lv1
                width: 300; height: 500;
                model: MainFunctions.createModel(mainData, index, mainRow);
                property int viewIndex: index;
                ScrollBar {
                    flickable: lv1
                    vertical: true
                    hideScrollBarsWhenStopped: false
                }

                delegate: Rectangle {
                    height: 20; width: parent.width;
                    border{color:"black"; width: 1}
                    color: ListView.isCurrentItem ? "green" : "white"
                    Text {
                        text: name; font.pointSize: 10
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                //console.log ("Clicked and item `"+name+"` at table " + index);
                                lv1.currentIndex = index;
                                mainData.setSelectedIndexAt(viewIndex, index);
                            }
                        }
                    }
                }
            }
        }
    }
    Text {
        id: descriptionTextField
        anchors.top: mainRow.bottom
        anchors.left: mainRow.left;
        //anchors.fill: root
        //x: 0
        //y: lv1.height
        font.family: "Comic Sans MS"
        text: mainData.itemDescription
        //text: "asdf"
    }/*
    Binding { target: descriptionTextField; property: 'text';
        value: mainData.itemDescription1
        when: true
    }*/
}
