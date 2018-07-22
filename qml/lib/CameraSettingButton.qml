import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root
    property alias source: image.source
    property int size: Theme.itemSizeMedium
    property string optionName
    width: size
    height: size
    function getSetterName(){
        var replaced = (optionName[0].toUpperCase() + optionName.slice(1)
                        .replace(/_([a-z])/g, function (g) { return g[1].toUpperCase(); }))
                        // does not work every time, so:
                        .replace('RecMode', 'RecordMode')


        return 'set' + replaced;
    }
    Rectangle {
        color: Theme.highlightBackgroundColor
        opacity: combobox.down ? Theme.highlightBackgroundOpacity : Theme.highlightBackgroundOpacity * 0.7
        radius: root.size / 6
        anchors.fill: parent
    }

    Label {
        text: combobox.label + '<br>' + api.settings[root.optionName] || ''
        font.pixelSize: Theme.fontSizeTiny
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    Image {
        id: image
        source: '../images/settingsButton_'+root.optionName+'.svg'

//        fillMode: Image.PreserveAspectFit
        onStatusChanged: {
            if(status === Image.Error) {
                source = 'image://theme/icon-s-setting'
            }
        }
        anchors.centerIn: parent

//        property color color: Theme.highlightColor
//        layer.effect: ShaderEffect {
//            property color color: Theme.highlightColor

//            fragmentShader: "
//                varying mediump vec2 qt_TexCoord0;
//                uniform highp float qt_Opacity;
//                uniform lowp sampler2D source;
//                uniform highp vec4 color;
//                void main() {
//                    highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
//                    gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
//                }
//            "
//        }
//        layer.enabled: combobox.down
//        layer.samplerName: "source"
    }
    ComboBox {
        id: combobox
        opacity: _menuOpen ? 1 : 0
        anchors.fill: parent
        width: root.size
        height: root.size

        label: strings.get(root.optionName)
        value: api.settings[root.optionName] || ''
        onValueChanged: {
            optionsModel.refill()
        }

        Component.onCompleted: {
            optionsModel.requestOptions()
        }

        menu: ContextMenu {
            Repeater {
                model: optionsModel
                MenuItem {
//                    visible: valueName !== ''
                    text:valueName
                    onClicked: {
//                        console.log(valueName, optionName, getSetterName())
                        if(valueName !== '') {
                            api.cmd(getSetterName(), valueName)
                        }
                    }
                    Component.onCompleted: {
                        if(valueName === combobox.value) {
//                            console.log('CURRENT VALUE', index)
//                            combobox.currentIndex
                        }
                    }
                }
            }
        }

    }

    ListModel {
        id: optionsModel
        property var allJsonData: api.settingsOptions
        property var jsonData: allJsonData[optionName] || ['','','','','','',''] //hack: dummy to force new page
        function refill() {
            clear()
            jsonData.forEach(function(option){
                append({optionName: root.optionName, valueName: option});
            })
            var i = 5;
            while(i--){
                append({optionName: '', valueName: ''});
            }
        }

        onJsonDataChanged: {
            refill()
            combobox._resetCurrent()
            combobox._loadCurrent()
        }

        function requestOptions(){
//            console.log('request setting options', root.optionName)
//            api.cmd('getSettingOptions', root.optionName);
            api.getSettingOptions(root.optionName)
        }
    }
}


