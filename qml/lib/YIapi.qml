import QtQuick 2.0
import io.thp.pyotherside 1.5

Item {
    id: api
    property bool loaded: false //python loaded
    property bool connected: false //cam connected
    property alias connectionRetries: reconnectTimer.retries

    property var settings: ({}) //camera settings
    property var settingsOptions: ({}) //valid options for settings
    property string streamUrl:''

    property bool vfstarted: false //viewfinder / stream started
    property bool modeIsVideo: true //false: photo mode
    /*
      subMode: empty for normal photo/video, else:
        Photo:
            - Timer: timer
            - Burst: burst
        Video:
            - Time Lapse: timelapse
            - Slow Motion: slowmotion
    */
    property string subMode: ''

    property bool isrecordingvideo: false
    function cmd(command, arg, cb) {
        if(!connected) {
            return null
        } else if(arg) {
            return pyscript.call('yi.cmd', [command, arg], cb);
        } else { //prevent debug warning:
            return pyscript.call('yi.cmd', [command], cb);
        }
    }
    function getSettingOptions(key) {
        if(!(key in settingsOptions)) {
            api.cmd('getSettingOptions', key);
        }
    }

    // convenience methods
    function shutter(){ // on shutter press
        console.log('RUNNING SHUTTER');
        if(modeIsVideo) {
                        if(!isrecordingvideo) {
                            cmd('startRecording');
                            isrecordingvideo = true;
                        } else {
                            cmd('stopRecording');
                            isrecordingvideo = false;
                        }
        } else {
            cmd('capturePhoto');
        }
    }

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
                    console.log('api: setting changed', result.param, 'old:', api.settings[result.param], 'new:', result.value);
                    var oldSettings = api.settings;
                    oldSettings[result.param] = result.value;
                    api.settings = oldSettings;
                } else if(result.type === 'vf_start') {
                    api.vfstarted = false
                    api.vfstarted = true
                } else if(result.type === 'vf_stop') {
                    api.vfstarted = false
                } else if(result.type === 'start_video_record') {
                    api.isrecordingvideo = true
                } else if(result.type === 'video_record_complete') {
                    api.isrecordingvideo = false
                }
                //try to get modeIsVideo & submode
                var sub = ''
                if(result.type === 'setting_changed' && result.param === 'rec_mode') {
                    modeIsVideo = true
                    subMode = result.param;
                } else if(result.type === 'setting_changed' && result.param === 'capture_mode') {
                    modeIsVideo = false
                    isrecordingvideo = false
                    subMode =result.param
                }
            })
            setHandler('disconnected', function() {
                console.log('api: disconnected')
                api.connected = false
            })
            setHandler('connection', function(success){
                api.connected = success;
            })
            //general callback, always fired.
            setHandler('callback', function(commandName, result) {
                api.connected = true
                //                console.log('api: general callback', commandName, JSON.stringify(result, null, 1));
                                console.log('api: general callback', commandName);
            })
            setHandler('callback_getSettings', function(commandName, result){
//                console.log('settings', typeof result)
//                console.log(result);
//                                console.log(JSON.stringify(result, null, 1));
                api.settings = result;
            });
            setHandler('callback_getSettingOptions', function(commandName, result){
//                console.log(commandName, Object.keys(result).join(', '))

//                console.log(JSON.stringify(result, null, 1));
                var options = [];
                if(true || result.permission === 'settable') {
                    options = result.options
                }
                var oldSettings = api.settingsOptions;
                console.log(result.param, options.join(', '))
                oldSettings[result.param] = options
                api.settingsOptions = oldSettings
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
                if(url) {
                    api.connected = true
                    api.streamUrl = url
                }
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
        pyscript.call('yi.connect'); //if successful, it's connected
    }

    onConnectedChanged: {
        if(connected) {
            api.cmd('getSettings', null, function(){

                pyscript.call('yi.getStreamURL');
                initializeCameraModeTimer.start()

            });
        }
    }
    Timer {
        id: reconnectTimer
        interval: 3000
        repeat: true
        running: !connected
        property int retries: 0
        onRunningChanged: {
            if(!running) {
                retries = 0
            }
        }

        onTriggered: {
            retries = retries + 1
            pyscript.call('yi.connect'); //if successful, it's connected
        }
    }
    Timer { //didn't work directly, so we're starting it delayed.
        id:initializeCameraModeTimer
        onTriggered: {

            var command = ['setRecordMode', api.settings['rec_mode']];
            if(options.startCameraMode == 'photo') {
                command = ['setCaptureMode', api.settings['capture_mode']];
            }
            api.cmd(command[0], command[1], function(){
                viewFinderTimer.start()
            })
        }
        interval: 400
    }
    Timer { //didn't work directly, so we're starting it delayed.
        id:viewFinderTimer
        onTriggered: {
            api.cmd('startViewFinder', null, function(){});
        }
        interval: 200
    }
}
