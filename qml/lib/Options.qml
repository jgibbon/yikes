import QtQuick 2.0

import Sailfish.Silica 1.0


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
    property bool setCameraDateTimeOnConnection: true
    property bool amazfishButtonShutterEnabled: false
    property int amazfishButtonShutterPresses: 1

    //view finder (stream) options
    property bool useViewFinder: true
    property bool disconnectViewFinderInBackground: true
    property bool useGrid: true

    //main View
    property bool autoLoadLatestThumbnail: false
    //downloads
    property string downloadPath: StandardPaths.pictures
}
