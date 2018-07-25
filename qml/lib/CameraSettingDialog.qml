// NameInputDialog.qml
import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property string key
    property string currentValue

    property string readableString: cameraStrings.get(key)
    DialogHeader {
                id: dialogHeader
                dialog: dialog
                title: readableString !== key ? readableString : key
                acceptText: qsTr('Change', 'short: change setting or submit dialog')
            }
    ListModel {
        id: optionsModel
        property var options: api.settingsOptions[key] ? api.settingsOptions[key].options : []
        function fillModel(){
            clear()
            for(var i = 0; i < options.length; i++) {
                append({option: options[i]})
            }
        }

        onOptionsChanged: {
            fillModel()
        }
        Component.onCompleted: {
            api.getSettingOptions(key)
        }
    }
    Label {
        id: keyNameLabel
        visible: readableString !== key
        color: Theme.highlightColor
        text: key
        font.pixelSize: Theme.fontSizeSmall
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        anchors {
            top: dialogHeader.bottom
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
//            bottom: parent.bottom
        }
    }
    SilicaListView {
        id: optionsColumn
//        header:
        clip: true
        anchors {
            top: keyNameLabel.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        model: optionsModel
        delegate: MenuItem {
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentValue = option
                }
            }

            width: optionsColumn.width
            text: option
            down: dialog.currentValue === option

        }


    }
    onDone: {
//        if (result == DialogResult.Accepted) {
//            name = nameField.text
//        }
    }
}
