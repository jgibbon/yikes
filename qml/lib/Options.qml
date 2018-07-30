import QtQuick 2.0

PersistentObject {
    id: options
    objectName: "options"

    //general options
    /*
      startCameraMode: We need to set the camera mode on start because it is

        possible modes are:
        - 'video'
        - 'photo'
    */
    property string startCameraMode: 'video'

    //view finder (stream) options
    property bool useViewFinder: true
    property bool useGrid: true

    //main View
    property bool autoLoadLatestThumbnail: false

}
