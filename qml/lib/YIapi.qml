import QtQuick 2.0
import io.thp.pyotherside 1.5

import Nemo.Notifications 1.0

Item {
    id: api
    property var cameraOverrides: ({
                                    'YI Discovery Action Camera': function(){
                                        api.settingsOptions.rec_mode = {
                                            permission:'settable',
                                            param:'rec_mode',
                                            options:['record', 'record_timelapse', 'record_loop', 'record_photo', 'record_slow_motion']
                                        };

                                        api.settingsOptions.capture_mode = {
                                            permission:'settable',
                                            param:'capture_mode',

                                            options:['precise quality', 'precise quality cont.', 'burst quality', 'precise self quality']

                                        };

                                        api.httpDownloadBase = 'http://192.168.42.1/';
                                    }
                                   })
    property bool loaded: false //python loaded
    property bool connected: false //cam connected
    property alias connectionRetries: reconnectTimer.retries

    property var settings: ({}) //camera settings
    property var settingsOptions: ({}) //valid options for settings
    property var fileList: ({})
    property string streamUrl:''
    property string httpDownloadBase: 'http://192.168.42.1/DCIM/100MEDIA/'

    property bool vfstarted: false //viewfinder / stream started
    property bool modeIsVideo: true //false: photo mode

    property int battery: -1 //percentage
    property int adapterStatus: -1 //no way to query? waiting for events… 1-> charging

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
    function downloadFiles(urls) {
        if(typeof urls !== 'object') {
            urls = [urls];
        }

        for(var i=0; i<urls.length; i++){
            console.log('adding download ', urls[i]);
            pyscript.call('download.add', [urls[i]]);
        }
        pyscript.call('download.start');
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
                    api.cmd('getFileList', '100MEDIA/', function(){});
                } else if(result.type === 'battery'){
                    battery = parseInt(result.param)
                } else if(result.type === 'adapter_status'){
                    adapterStatus = parseInt(result.param)
                } else if(result.type === 'photo_taken'){
                    api.cmd('getFileList', '100MEDIA/', function(){});
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
                api.settings = result;
                if(api.cameraOverrides[result.product_name]) {
                    api.cameraOverrides[result.product_name]();
                }
            });
            setHandler('callback_setRawSetting', function(commandName, result){
                api.cmd('getSettings');//not all settings get notified :(
            });
            setHandler('callback_getSettingOptions', function(commandName, result){
                var options = result;
                var oldSettings = api.settingsOptions;
                oldSettings[result.param] = options
                api.settingsOptions = oldSettings
            });
            setHandler('callback_setCaptureMode', function(){
                modeIsVideo = false;
            });
            setHandler('callback_setRecordMode', function(){
                modeIsVideo = true;
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
            setHandler('callback_getBatteryLevel', function(commandName, result){
                //                console.log('settings', typeof result)
                                console.log(commandName, result);
                api.battery = parseInt(result)
            });
            function formatFileObj(fileObj) {
                var fileName = Object.keys(fileObj)[0]; //only one key
                var values = fileObj[fileName].split('|');
                return {
                    fileName: fileName,
                    previewVideo: fileName,
                    previewImage: '',
                    rawImage:'',
                    rawBytes:0,
                    bytes: parseInt(values[0]),
                    date: new Date(values[1]),
                    isVideo: fileName.toLowerCase().indexOf('.mp4') > -1
                };
            }

            setHandler('callback_getFileList', function(commandName, result){
                var tempObj = {};
                var formattedFileList = [];
                var hasTHM, has_thm, hasSEC, isRaw;
                var keyFileName
                for(var i=0; i< result.length; i++){
                    var formatted = formatFileObj(result[i]),
                        lowercaseFileName = formatted.fileName.toLowerCase();
                    //don't add thumbnails as own entry
                    hasTHM = lowercaseFileName.indexOf('.thm') > -1;
                    has_thm = lowercaseFileName.indexOf('_thm') > -1;
                    hasSEC = lowercaseFileName.indexOf('.sec') > -1;
                    isRaw = lowercaseFileName.indexOf('.dng') > -1;
                    //don't add raw (dng) as well
                    if(!hasTHM && !hasSEC && !has_thm && !isRaw) {
                        if(!(lowercaseFileName in tempObj)) {
                            tempObj[lowercaseFileName] = ({});
                        }
                        tempObj[lowercaseFileName].fileName = formatted.fileName
                        tempObj[lowercaseFileName].bytes = formatted.bytes
                        tempObj[lowercaseFileName].date = formatted.date
                        tempObj[lowercaseFileName].isVideo = formatted.isVideo
                        tempObj[lowercaseFileName].previewVideo = tempObj[lowercaseFileName].previewVideo || ''
                        tempObj[lowercaseFileName].previewImage = tempObj[lowercaseFileName].previewImage || ''
                        tempObj[lowercaseFileName].rawImage = tempObj[lowercaseFileName].rawImage || ''
                        tempObj[lowercaseFileName].rawBytes = tempObj[lowercaseFileName].rawBytes || 0
                        console.log('real entry', lowercaseFileName)
                    } else {
                        keyFileName = lowercaseFileName
                            .replace('.thm', '.mp4')
                            .replace('.sec', '.mp4')
                            .replace('_thm', '')
                            .replace('.dng', '.jpg');
                        if(!(lowercaseFileName in tempObj)) {
                            tempObj[lowercaseFileName] = {}
                        }
                        console.log('has stuff',lowercaseFileName, has_thm, hasSEC, hasTHM, isRaw)
                        if(has_thm || hasSEC) {
                            tempObj[keyFileName].previewVideo = formatted.fileName
                        } else if(hasTHM) {
                            tempObj[keyFileName].previewImage = formatted.fileName
                        } else if(isRaw) {
                            tempObj[keyFileName].rawImage = formatted.fileName
                            tempObj[keyFileName].rawBytes = formatted.bytes
                        }
                    }
                }

                var fileNames = Object.keys(tempObj);
                for(i=0; i<fileNames.length; i++) {
                    if(tempObj[fileNames[i]].fileName) {
                        formattedFileList.push(tempObj[fileNames[i]]);
                    }
                }
                formattedFileList.reverse()
                api.fileList = formattedFileList

                console.log(commandName, JSON.stringify(formattedFileList, null, 1));

            });
            setHandler('streamurl', function(url){
                if(url) {
                    api.connected = true
                    api.streamUrl = url
                }
            });
            setHandler('downloadstate', function(queuesize, percent, progress_size, speed, duration){
//                console.log('downloading: ', queuesize, 'files remaining', percent,'%', progress_size, speed, duration)
                downloadNotification.previewSummary = qsTr('Getting %L1 File(s) from Camera', 'notification: make it short').arg(queuesize + 1)
                downloadNotification.summary = downloadNotification.previewSummary
                downloadNotification.previewBody = qsTr('%1%, %L2kB/s','50%, 300kB/s').arg(percent).arg(speed)
                downloadNotification.body = downloadNotification.previewBody
                downloadNotification.publish()
            })
            setHandler('downloaddone', function(){
                console.log('FILE DONE')
                downloadNotification.close()
            })



            importModule('yi', function () {
                api.loaded = true;
            });
            importModule('download', function () {
//                console.log('setting download dir', options.downloadPath)
                pyscript.call('download.setdownloaddir', [options.downloadPath])
            });
        }

        onReceived: {
            console.log('unhandled message: ' + data);
        }

        onError: {
            console.log('Python failure: ' + traceback);
        }

    }

    Connections {
        target: options
        onDownloadPathChanged: {
            pyscript.call('download.setdownloaddir', [options.downloadPath])
        }
    }
    onLoadedChanged: {
        pyscript.call('yi.connect'); //if successful, it's connected
    }

    onConnectedChanged: {
        if(connected) {
            api.cmd('getBatteryLevel', null, function(){
                api.cmd('getSettings', null, function(){

                pyscript.call('yi.getStreamURL');
                initializeCameraModeTimer.start()

                });
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
            if(options.useViewFinder) {
//                api.cmd('startViewFinder', null, function(){});
            }
            api.cmd('getFileList', '100MEDIA/', function(){});
        }
        interval: 200
    }
    Component.onDestruction: {

        console.log('exiting')
        if(vfstarted) {

            console.log('stopping viewfinder')
            api.cmd('stopViewFinder');
        }
    }
    Notification {
        replacesId: 1
        id: downloadNotification
        appIcon: '/usr/share/icons/hicolor/86x86/apps/yikes.png'//Qt.resolvedUrl("../images/app-icon-fg.svg")
        appName: 'yikes'
//        category: 'x-jolla.lipstick.connectionwlan'
        summary: 'summary'
        previewSummary: 'previewSummary'
        body: 'body'
        previewBody: 'previewBody'
        itemCount: 1
        maxContentLines: 3
        origin: 'origin'

    }
}
