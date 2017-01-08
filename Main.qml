// TODO: cleanup and trim and learn
// TODO: add some basic success/error text
// TODO: hover colors for top right buttons is blue/white
// TODO: focus/hover for login text boxes is blue

import QtQuick 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0

Rectangle {
  TextConstants { id: textConstants }

  Connections {
    target: sddm
    onLoginSucceeded: {}
    onLoginFailed: {}
  }

  Background {
    anchors.fill: parent
    source: config.background
    fillMode: Image.PreserveAspectCrop
    onStatusChanged: {
      if (status == Image.Error && source != config.defaultBackground) {
        source = config.defaultBackground
      }
    }

  }

  Rectangle {
    anchors.fill: parent
    color: "transparent"
    visible: primaryScreen

    Rectangle {
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.topMargin: 5
      z: 100
      width: 250

      color: "transparent"

      border.color: "transparent"
      border.width: 0

      Row {
        spacing: 3

        ComboBox {
          id: session
          opacity: 0
          textColor: "#dddddd"
          color: "#333333"
          model: sessionModel
          index: sessionModel.lastIndex
        }

        Button {
          id: shutdownButton
          text: textConstants.shutdown
          textColor: "#dddddd"
          color: "#333333"
          onClicked: sddm.powerOff()
          KeyNavigation.backtab: session; KeyNavigation.tab: rebootButton
        }

        Button {
          id: rebootButton
          text: textConstants.reboot
          textColor: "#dddddd"
          color: "#333333"
          onClicked: sddm.reboot()
          KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
        }
      }
    }

    Rectangle {
      anchors.centerIn: parent
      width: Math.max(320, mainColumn.implicitWidth + 100)
      height: mainColumn.implicitHeight + 50
      color: "transparent"

      border.color: "transparent"
      border.width: 0

      ColumnLayout {
        id: mainColumn
        anchors.fill: parent
        anchors.margins: parent.width/20

        TextBox {
          id: name
          height: 30
          Layout.fillWidth: true
          text: userModel.lastUser
          font.pixelSize: 10
          font.bold: true
          textColor: "#f0f0f0"
          color: "#333333"
          opacity: 0.6
          borderColor: "transparent"

          KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

          Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              sddm.login(name.text, password.text, session.index)
              event.accepted = true
            }
          }
        }

        PasswordBox {
          id: password
          Layout.fillWidth: true
          font.pixelSize: 10
          color: "#333333"
          textColor: "#f0f0f0"
          opacity: 0.6
          tooltipBG: "#222222"
          borderColor: "transparent"

          KeyNavigation.backtab: name; KeyNavigation.tab: session

          Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
              sddm.login(name.text, password.text, session.index)
              event.accepted = true
            }
          }
        }
      }
    }
  }

  Component.onCompleted: {
    if (name.text == "")
      name.focus = true
    else
      password.focus = true
  }
}
