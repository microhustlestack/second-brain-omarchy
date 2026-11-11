import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Second Brain companion widget for the Omarchy bar.
//
// Shows the state of your Second Brain vault inbox as a status dot next
// to a label: it runs `second-brain status` (from the WSTUNLTD™ Second
// Brain Omarchy package) and reads the pending ingestion count, the
// number of files sitting in the vault's raw/ folder that have not been
// filed into the wiki yet.
//
//   green  nothing waiting, the inbox is fully filed
//   amber  files are waiting, and the count shows next to the label
//   grey   still checking, or the second-brain CLI was not found
//
// Clicking the widget opens the vault (`second-brain open` by default,
// which opens it in Obsidian where available).
//
// The widget is read-only: it runs the status command and the launch
// command you configure. It never writes to the vault.
//
// IPC, from a terminal:
//   omarchy-shell io.github.microhustlestack.secondbrain status   -> pending count, or unknown
//   omarchy-shell io.github.microhustlestack.secondbrain refresh
//   omarchy-shell io.github.microhustlestack.secondbrain launch
BarWidget {
  id: root
  moduleName: "io.github.microhustlestack.secondbrain"

  readonly property string label: setting("label", "Brain")
  readonly property bool showLabel: setting("showLabel", true)
  readonly property int refreshSeconds: setting("refreshSeconds", 60)
  readonly property string launchCommand: setting("launchCommand", "second-brain open")

  // Pending ingestion count from `second-brain status`. -1 means the
  // count is unknown: still checking, or the CLI is not installed.
  property int pending: -1

  readonly property color dotColor: pending < 0 ? "#888888" : (pending === 0 ? "#7fc348" : "#e8a13a")
  readonly property color fg: bar ? bar.barForeground : Color.foreground

  function refresh() {
    if (!statusProc.running) statusProc.running = true
  }

  function launch() {
    launchProc.command = launchCommand.split(" ").filter(function (s) { return s.length > 0 })
    launchProc.running = true
  }

  implicitWidth: row.implicitWidth + 16
  implicitHeight: row.implicitHeight

  Process {
    id: statusProc
    command: ["/bin/bash", "-lc", "second-brain status 2>/dev/null | grep -o 'Pending ingestion: [0-9]*' | grep -o '[0-9]*$'"]
    stdout: StdioCollector {
      onStreamFinished: {
        var t = text.trim()
        var n = parseInt(t, 10)
        root.pending = (t.length > 0 && !isNaN(n)) ? n : -1
      }
    }
  }

  Process {
    id: launchProc
    command: ["second-brain", "open"]
  }

  Timer {
    interval: Math.max(15, root.refreshSeconds) * 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  IpcHandler {
    target: "io.github.microhustlestack.secondbrain"
    function status(): string { return root.pending < 0 ? "unknown" : String(root.pending) }
    function refresh(): void { root.refresh() }
    function launch(): void { root.launch() }
  }

  Row {
    id: row
    anchors.centerIn: parent
    spacing: 6

    Rectangle {
      anchors.verticalCenter: parent.verticalCenter
      width: 8
      height: 8
      radius: 4
      color: root.dotColor
    }

    Text {
      anchors.verticalCenter: parent.verticalCenter
      visible: root.showLabel && !root.vertical
      text: root.label
      color: root.fg
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.body
    }

    Text {
      anchors.verticalCenter: parent.verticalCenter
      visible: root.pending > 0 && !root.vertical
      text: String(root.pending)
      color: root.dotColor
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.body
      font.bold: true
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: root.launch()
  }
}
