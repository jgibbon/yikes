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
//            OptionComboBox {
//                optionname: 'startCameraMode'
//                label: qsTr('Camera Start Mode')
////                description: qsTr('')
//                jsonData: [
//                    {text: qsTr('Video'), value: 'video'},
//                    {text: qsTr('Photo'), value: 'photo'},
//                ]
//            }
            TextSwitch {
                text: qsTr('Set Camera Date when Connection succeeded')
                checked: options.setCameraDateTimeOnConnection
                onClicked: {
                    options.setCameraDateTimeOnConnection = checked
                }
            }
            TextSwitch {
                id:amazfishButtonShutterEnabledSwitch
                // TextSwitch: Pressing Amazfish watch button = Shutter button
                //: TextSwitch: Pressing Amazfish watch button = Shutter button
                text: qsTr( "Amazfish button press")

                checked: options.amazfishButtonShutterEnabled
                onClicked: {
                    options.amazfishButtonShutterEnabled = checked
                }
                // TextSwitch description: Amazfish
                //: TextSwitch description: Amazfish
                description: qsTr('Trigger shutter by pressing button on Amazfish-connected device')
            }

            Slider {
                id: amazfishButtonShutterPressesSlider
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                minimumValue: 1
                maximumValue: 5
                stepSize: 1

                visible: options.amazfishButtonShutterEnabled
                // Slider Value: Press Amazfish watch button x times for shutter
                //: Slider Value: Press Amazfish watch button x times for shutter
                valueText: qsTr('Press %L1 time', '', value).arg(value)
//                            label:
                onValueChanged: {
                    options.amazfishButtonShutterPresses = value
                }
                Component.onCompleted: {
                    value = options.amazfishButtonShutterPresses
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
