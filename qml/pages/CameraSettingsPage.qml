import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import '../lib'

Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent
        PageHeader {
            id: pageHeader
            title: qsTr('Camera Settings')
            description: qsTr('Find all raw settings of the Camera')
        }
        ListModel {
            id: settingsModel
            property var settings: api.settings
            function fillModel(){
                clear();
                var keys = Object.keys(settings);
                for(var i = 0; i < keys.length; i++) {
                    append({key:keys[i], currentValue: settings[keys[i]]})
                }

            }
            onSettingsChanged: {
                fillModel()
            }
            Component.onCompleted: {
                fillModel()
            }
        }
        Timer {
            id: positionTimer
            property int indexToShow: -1
            interval: 200
            onTriggered: {
                if(indexToShow > -1) {
                    listView.positionViewAtIndex(indexToShow, ListView.Beginning)
                    indexToShow = -1
                }
            }
        }

        SilicaListView {
            id: listView
            model: settingsModel
            clip: true
            anchors {
                top: pageHeader.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            delegate: ValueButton {
                width: ListView.view.width
                height: Theme.itemSizeSmall
                property string readableString: cameraStrings.get(key)
                label: key
                value: currentValue
                description: readableString !== key ? readableString : ''
                property bool isSettable: {
                    if(api.settingsOptions[key] && api.settingsOptions[key].permission === 'settable' && api.settingsOptions[key].options.length > 1) {
                        return true
                    }
                    return false
                }
                labelColor: isSettable ? Theme.primaryColor : Theme.highlightColor
//                opacity: isSettable ? 1 : 0.2
                onClicked: {
                    if(isSettable) {
                        positionTimer.indexToShow = index
                        var dialog = pageStack.push(Qt.resolvedUrl("../lib/CameraSettingDialog.qml"),
                                                    {"key": key, "currentValue": currentValue})
                        dialog.accepted.connect(function() {
//                            console.log('setRawSetting param:', dialog.currentValue, 'type: ', key)
                            if(api.settings[key] !== dialog.currentValue) {
                                api.cmd('setRawSetting', {param: dialog.currentValue, type: key},
                                        function(){
                                            api.cmd('getSettings')
                                        })
                            }
                        })
                    }
                }

                Component.onCompleted: {
                    api.getSettingOptions(key)

                    positionTimer.start()
//                    console.log(api.settingsOptions[key])
                }

//                Label {
//                    text: key
//                    width: parent * 0.5
//                }

//                Label {
//                    text: currentValue
//                    width: parent * 0.5
//                    horizontalAlignment: Text.AlignRight
//                }
            }
        }
    }
}
