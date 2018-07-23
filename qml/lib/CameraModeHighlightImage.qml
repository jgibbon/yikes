import Sailfish.Silica 1.0

HighlightImage {
    anchors.fill: parent
    image.width: parent.width / 2
    image.height: parent.width / 2
    image.anchors.fill: undefined
    image.scale: highlighted? 1.2 : 1
    color: Theme.primaryColor
    onClicked: function(){parent.clickedFunc()}
}
