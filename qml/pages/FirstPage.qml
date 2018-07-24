import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import '../lib'

Page {
    id: page

    allowedOrientations: Orientation.All

    states: [
        State {
            name: "disconnected"
            when: !api.connected
            PropertyChanges {
                target: pageDisconnected
                opacity: 1
            }
            PropertyChanges {
                target: pageConnected
                opacity: 0
            }
        },
        State {
            name: "connected"
            when: api.connected
            PropertyChanges {
                target: pageConnected
                opacity: 1
            }
            PropertyChanges {
                target: pageDisconnected
                opacity: 0
            }
        }

    ]

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: mainFlickable
        width: parent.width
        height: parent.height

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Camera Settings")
                enabled: api.connected
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/CameraSettingsPage.qml"))
            }
        }
        contentHeight: page.height

        MainpageConnected {
            id: pageConnected
            opacity: 0
        }
        MainpageDisconnected {
            id: pageDisconnected
        }


    }
}

