import QtQuick 2.0

QtObject {
    id: options
    objectName: "options"

    //general options
    /*
      startCameraMode: We need to set the camera mode on start because it is

        possible modes are:
        - 'video'
        - 'photo'
    */
    property var startCameraMode: 'video'

    //view finder (stream) options
    property bool useViewFinder: true
    property bool useGrid: true

}
