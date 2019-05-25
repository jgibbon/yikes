import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import '../lib'

Page {
    id: page

    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: settingsColumn.height
        PullDownMenu {
            MenuItem {
                text: qsTr("About", "pulley menu entry")
                onClicked: pageStack.push(Qt.resolvedUrl("../pages/AboutPage.qml"))
            }
        }
        Column {
            id: settingsColumn
            width: parent.width
            spacing: Theme.paddingSmall
            PageHeader {
                id: pageHeader
                title: qsTr('Application Settings')
            }

            SectionHeader {
                text: qsTr('General Options')
            }
            OptionComboBox {
                optionname: 'startCameraMode'
                label: qsTr('Camera Start Mode')
//                description: qsTr('')
                jsonData: [
                    {text: qsTr('Video'), value: 'video'},
                    {text: qsTr('Photo'), value: 'photo'},
                ]
            }
            TextSwitch {
                opacity: options.useViewFinder ? 1 : 0.5
                text: qsTr('Set Camera Date when Connection succeeded')
                checked: options.setCameraDateTimeOnConnection
                onClicked: {
                    options.setCameraDateTimeOnConnection = checked
                }
            }
            SectionHeader {
                text: qsTr('Viewfinder Options')
            }

            TextSwitch {
                text: qsTr('Use Viewfinder')
                checked: options.useViewFinder
                onClicked: {
                    options.useViewFinder = checked
                }
            }
            TextSwitch {
                opacity: options.useViewFinder ? 1 : 0.5
                text: qsTr('Show Grid')
                checked: options.useGrid
                onClicked: {
                    options.useGrid = checked
                }
            }
            TextSwitch {
                opacity: options.useViewFinder ? 1 : 0.5
                text: qsTr('Disconnect Viewfinder in background')
                description: qsTr('Disconnecting when the Main Page isn\'t visible helps battery life.')
                checked: options.disconnectViewFinderInBackground
                onClicked: {
                    options.disconnectViewFinderInBackground = checked
                }
            }

            SectionHeader {
                text: qsTr('Main Page')
            }
            TextSwitch {
                text: qsTr('Automatically display latest thumbnail')
                description: qsTr('Loading previews strains the network quite a bit and reduces battery life.')
                checked: options.autoLoadLatestThumbnail
                onClicked: {
                    options.autoLoadLatestThumbnail = checked
                }
            }
        }
    }
}
