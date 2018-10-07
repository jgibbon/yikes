import QtQuick 2.2
import Sailfish.Silica 1.0

Item {
    id: root
    property string key
    property string value
    property bool activeMainmode //api.modeIsVideo or !api.modeIsVideo
    property alias source: image.source
    width: Theme.itemSizeSmall
    height: Theme.itemSizeSmall
    visible: typeof api.settingsOptions[key] === 'object'
        && api.settingsOptions[key].options.indexOf(value) > -1
    onVisibleChanged: checkHighlighted()

    function checkHighlighted(){
        if(page.status === PageStatus.Active) {
            parent.checkHighlighted(image);
        }
    }

    property var clickedFunc: function() {
        if(api.settings[key] !== value) {
            api.cmd('setRawSetting', {param: value, type: key})
        }
    }
    CameraModeHighlightImage {
        id: image
        source: 'image://theme/icon-m-camera'
        highlighted: api.settings[root.key] === root.value
        onHighlightedChanged: {
            root.checkHighlighted()
        }
    }
    Connections {
        target: page
        onStatusChanged: root.checkHighlighted()
    }
}
