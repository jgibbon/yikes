// NameInputDialog.qml
import QtQuick 2.2
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property string key
    property string currentValue

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

    SilicaListView {
        id: optionsColumn
        header: DialogHeader {
            id: dialogHeader
            title: key
        }
        clip: true
        anchors.fill: parent
        model: optionsModel
        delegate: MenuItem {
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log('option CLICKED!', option, currentValue)
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
