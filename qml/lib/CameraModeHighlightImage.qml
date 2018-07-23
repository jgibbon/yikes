import Sailfish.Silica 1.0

HighlightImage {
    anchors.fill: parent
    image.width: parent.width / 2
    image.height: parent.width / 2
    image.anchors.fill: undefined
    image.opacity: highlighted? 1:0.7
    color: Theme.primaryColor
    useShadow: true
    shadowColor: Theme.highlightDimmerColor
    onClicked: function(){parent.clickedFunc()}
}
