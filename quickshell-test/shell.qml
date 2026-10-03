import QtQuick
import Quickshell

Item {


    width: 800

    Text {
        id: lorem

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum non orci ipsum, eu laoreet nisl. Suspendisse ut dictum neque. Pellentesque nulla ipsum, posuere ut mattis vel, dapibus fringilla arcu. Donec fermentum purus in risus convallis semper. Nullam tempor urna eu libero vulputate vitae pulvinar enim accumsan. Donec vitae leo a enim faucibus consectetur. Nullam lectus justo, eleifend quis condimentum ut, pharetra et risus. Ut luctus molestie nibh sit amet vestibulum."

        wrapMode: Text.WordWrap
        font.family: "SF Pro Display"
        font.pixelSize: 15
        font.weight: Font.Bold

        color: "black"
    }
}