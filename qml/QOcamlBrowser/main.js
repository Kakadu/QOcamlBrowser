function onClick(name, id) {
    console.log("Clicked: " + name + ", " + id);
}

function createControls(data, parent) {
    console.log( data.tableCount() ) ;
    var i,j = 0;
    var ans;
    //for (i=0; i<data.tableCount(); ++i) {
    for (i=0; i<1; ++i) {
        console.log("i=" + i);
        ans = "import QtQuick 1.0;\n";
        ans += "ListModel {\n";
        ans += "  id: model" + i + ";\n";
        for (j=0; j<data.tableLength(i); ++j) {
            ans += "  ListElement{name:\""+ data.take(i,j) + "\"}\n";
        }
        ans += "}";
        console.log(ans);
        var newModel = Qt.createQmlObject(ans, parent, "model"+i);
        // creating view
        ans  = "import QtQuick 1.0;\n";
        ans += "ListView {\n";
        ans += "  id: view" + i + "\n";
        ans += "  width: 400; height: 500;\n";
        ans += "  anchors{top:parent.top;" +
                ((i===0)? "" : ("left:listView"+(i)+".right; ")) +
                " leftMargin: 1}\n";
        ans += "  model: model"+i + "\n";
        ans += "  delegate: Rectangle {\n";
        ans += "    height: 50; width: parent.width; border{color:\"black\"; width: 1}\n";
        ans += "    Text {text: name }\n";
        ans += "  }\n";
        ans += "}"
        console.log(ans);
        var newView = Qt.createQmlObject(ans, parent, "listView"+i);
    }
}

function createModel(data,n, parent) {
    var j,ans = "import QtQuick 1.0;\n";
    ans += "ListModel {\n";
    //ans += "  id: model" + i + ";\n";
    for (j=0; j<data.tableLength(n); ++j) {
        ans += "  ListElement{name:\""+ data.take(n,j) + "\"}\n";
    }
    ans += "}";
    //console.log(ans);
    var newModel = Qt.createQmlObject(ans, parent, "model"+n);
    return newModel;
}

function getViewPath(data,n) {
    var ans = data.take(0, data.selectedIndexAt(0));
    for (var i=1; i<=n; i++) {
        ans += "/" + data.take(i, data.selectedIndexAt(i));
    }
    return ans;
}
