import QtQuick 2.0

QtObject {
    id: options
    objectName: "options"

    //general options
    /*
      startCameraMode: We need to set the camera mode on start because it is
        impossible to guess from settings (we can only guess after change events)

        possible modes, at least for yi 4k, are:
        Video:
            ['setRecordMode', 'record']
            ['setRecordMode', 'record_timelapse'] //time lapse
            ['setRecordMode', 'record_slow_motion'] //slow motion
        Photo:
            ['setCaptureMode', 'precise quality']
            ['setCaptureMode', 'precise self quality'] //timer
            ['setCaptureMode', 'burst quality'] //burst
    */
    property var startCameraMode: ['setRecordMode', 'record']

    //view finder (stream) options
    property bool useViewFinder: true
    property bool useGrid: true

}
