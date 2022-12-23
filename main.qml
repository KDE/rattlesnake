import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.10 as Kirigami

import org.kde.rattlesnake 1.0

Kirigami.ApplicationWindow {
    visible: true
    width: 700
    minimumWidth: 200
    height: 480
    minimumHeight: 200
    title: qsTr("Rattlesnake")
    pageStack.initialPage: "qrc:/MetronomePage.qml"

}
