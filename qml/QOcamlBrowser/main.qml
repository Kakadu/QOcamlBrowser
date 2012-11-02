import QtQuick 1.0
import "main.js" as MainFunctions

Rectangle {
    id: root
    width: 800
    height: 700

    Component.onCompleted: {
        //MainFunctions.createControls(mainData, root);
    }
    Row {
        id: mainRow
        anchors{top:parent.top; left:parent.left}
        Repeater {
            model: mainData.tableCount1
            ListView {
                id: lv1
                width: 300; height: 500;
                model: MainFunctions.createModel(mainData, index, mainRow);
                //property string path: MainFunctions.getViewPath(mainData, index);
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
        anchors.top: mainRow.bottom
        anchors.left: mainRow.left;
        //anchors.fill: root
        //x: 0
        y: lv1.height
        font.family: "Comic Sans MS"
        text:"preview will be here"
    }

/*
    function showlistView2(index){
        switch(index){
            case 0:listView2.model = fruitsModel
                break;
            case 1:listView2.model = vegModel
                break;
            case 2:listView2.model = gameModel
                break;
        }
    }

    ListModel{
        id:emptyModel
    }

    ListModel{
        id:modelData
        ListElement{name:"Fruits"}
        ListElement{name:"Vegetables"}
        ListElement{name:"Games"}
    }

    ListModel{
        id:fruitsModel
        ListElement{name:"Apple"}
        ListElement{name:"Banana"}
        ListElement{name:"Mango"}
    }

    ListModel{
        id:vegModel
        ListElement{name:"Onion"}
        ListElement{name:"Potato"}
        ListElement{name:"Tomato"}
    }

    ListModel{
        id:gameModel
        ListElement{name:"Basketball"}
        ListElement{name:"Cricket"}
        ListElement{name:"Football"}
    }

    ListView {
        id: listView1
        width: 400; height: 500
        anchors{top:parent.top; left:parent.left}
        model: modelData
        delegate: Rectangle {
            height: 50; width: parent.width; border{color:"black"; width: 1}
            Text { text: name }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    MainFunctions.onClick(name, id);
                    showlistView2(index);
                }
            }
        }
    }

    ListView {
        id:listView2
        width: 400; height: 500;
        anchors{top:parent.top; left:listView1.right; leftMargin: 1}
        model: emptyModel
        delegate: Rectangle {
            height: 50; width: parent.width; border{color:"black"; width: 1}
            Text {text: name }
        }
    }
    */
}
