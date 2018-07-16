import QtQuick 2.0
import io.thp.pyotherside 1.5

Item {
    id: api
    property bool loaded: false
    property string var1: ''
    property string var2: ''
    Python {
        id: pyscript
        property bool initialized: false
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))


            setHandler('debugoutput', function(var1, var2){
                console.log('qml: getting output from python', var1, var2);
                api.var1 = var1;
                api.var2 = var2;
            })


            importModule('pytest', function () {
                initialized = true;
                api.loaded = true;
            });
        }

        onReceived: {
            console.log('unhandled message: ' + data);
        }

        onError: {
            console.log('Python failure: ' + traceback);
        }
        onInitializedChanged: {
            if(initialized) {
                call('pytest.testinstance.debugoutput', function(){
                    console.log('qml: python call finished');
                });
            }
        }
    }
}
