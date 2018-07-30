import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import '../lib'

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent
        Column {
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
