import QtQuick 2.0
import io.thp.pyotherside 1.5

Item {
    id: api
    property bool loaded: false
    property bool connected: false
    property string var1: ''
    property string streamUrl:''
    property bool vfstarted: false
    property var settings: ({}) //camera settings
    Python {
        id: pyscript
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))

            setHandler('notification', function(result) {
                console.log('notification', JSON.stringify(result, null, 1));
                //update settings
//                switch(result.type) {
//                    case 'setting_changed':
//                        console.log('setting changed:', result.param, 'old:', api.settings[result.param], 'new:', result.value);
//                        api.settings[result.param] = result.value;
//                        break;
//                    case 'vf_start':

//                        api.vfstarted = true
//                        break;
//                    case 'vf_stop':
//                        api.vfstarted = false
//                        break;

//                }

                if(result.type === 'setting_changed') {
                    console.log('setting changed:', result.param, 'old:', api.settings[result.param], 'new:', result.value);
                    api.settings[result.param] = result.value;
                } else if(result.type === 'vf_start') {
                    api.vfstarted = true
                } else if(result.type === 'vf_stop') {
                    api.vfstarted = false
                }
            })
            setHandler('disconnected', function() {
                console.log('api: disconnected')
            })
            //general callback, always fired.
            setHandler('callback', function(commandName, result) {
                //                console.log('api: general callback', commandName, JSON.stringify(result, null, 1));
                                console.log('api: general callback', commandName);
            })
            setHandler('callback_getSettings', function(commandName, result){
//                console.log('settings', typeof result)
//                console.log(result);
                api.settings = result;
            });
            setHandler('callback_startViewFinder', function(commandName, result){
                //                console.log('settings', typeof result)
                                console.log(commandName, result);
                api.vfstarted = true
            });
            setHandler('callback_stopViewFinder', function(commandName, result){
                //                console.log('settings', typeof result)
                                console.log(commandName, result);
                api.vfstarted = false
            });
            setHandler('streamurl', function(url){
                api.streamUrl = url
            });



            importModule('yi', function () {
                api.loaded = true;
            });
        }

        onReceived: {
            console.log('unhandled message: ' + data);
        }

        onError: {
            console.log('Python failure: ' + traceback);
        }

    }
    onLoadedChanged: {
        if(loaded) {
            pyscript.call('yi.cmd',['getSettings'], function(){
                console.log('got settings')
                pyscript.call('yi.getStreamURL')
                viewFinderTimer.start()

            });
        }
    }

    Timer { //didn't work directly, so we're starting it delayed.
        id:viewFinderTimer
        onTriggered: {
            console.log('try starting viewfinder')
            pyscript.call('yi.cmd', ['startViewFinder']);
        }
        interval: 200
    }
}
