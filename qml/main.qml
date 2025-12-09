import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes
import QtQuick.Dialogs

ApplicationWindow {
    id: root
    width: 1000
    height: 720
    minimumWidth: 1000
    minimumHeight: 720
    visible: true
    title: "Enigmorph"

    // --- STATE PROPERTIES ---
    property string inputText: ""
    property string outputText: ""
    property string lastAction: ""
    property bool processing: false
    property bool copySuccess: false

    // Mode State ("text" or "image")
    property string appMode: "text"
    property string selectedImagePath: ""
    property string stegoSecretMessage: ""

    // UI States
    property bool configExpanded: true
    property bool showPin: false
    property bool showPassword: false

    // --- STYLE DICTIONARY ---
    readonly property color colorPrimary: "#4f46e5"
    readonly property color colorPrimaryHover: "#4338ca"
    readonly property color colorPrimaryActive: "#3730a3"
    readonly property color colorSuccess: "#10b981"
    readonly property color colorSuccessHover: "#059669"
    readonly property color colorSuccessActive: "#047857"
    readonly property color colorDanger: "#ef4444"
    readonly property color colorDangerBg: "#fee2e2"
    readonly property color colorWarningBg: "#fef3c7"
    readonly property color colorWarningBorder: "#fbbf24"
    readonly property color colorWarningText: "#92400e"

    readonly property color colorBgLight: "#f8fafc"
    readonly property color colorBgDark: "#0f172a"
    readonly property color colorBgCard: "#ffffff"
    readonly property color colorBgInput: "#1e293b"
    readonly property color colorBgOverlay: "#f0ffffff"
    readonly property color colorBorderLight: "#e2e8f0"
    readonly property color colorBorderMedium: "#cbd5e1"
    readonly property color colorBorderDark: "#475569"
    readonly property color colorTextDark: "#1e293b"
    readonly property color colorTextLight: "#cbd5e1"
    readonly property color colorTextSub: "#64748b"
    readonly property color colorTextMuted: "#7c8899"
    readonly property color colorTextWhite: "#ffffff"
    readonly property color colorGradientDarkStart: "#0f172a"
    readonly property color colorGradientDarkMid: "#1e293b"
    readonly property color colorGradientDarkEnd: "#312e81"
    readonly property color colorAccentPurple: "#8b5cf6"

    readonly property string fontMain: "Segoe UI"
    readonly property string fontMono: "Consolas"
    readonly property int fontSizeMicro: 9
    readonly property int fontSizeXS: 10
    readonly property int fontSizeS: 11
    readonly property int fontSizeM: 12
    readonly property int fontSizeL: 14
    readonly property int fontSizeXL: 18
    readonly property int fontSizeXXL: 24
    readonly property int fontSizeTitle: 26
    readonly property int fontSizeIcon: 30

    readonly property real radiusS: 8
    readonly property real radiusM: 12
    readonly property real radiusL: 14
    readonly property real radiusXL: 18
    readonly property real radiusXXL: 20
    readonly property real radiusCard: 24
    readonly property real radiusMax: 28

    // --- INTERNAL COMPONENT: VectorIcon ---
    component VectorIcon: Shape {
        property string iconName: "info"
        property color iconColor: "black"
        width: 24; height: 24
        implicitWidth: 24; implicitHeight: 24
        layer.enabled: true
        layer.samples: 4
        layer.smooth: true
        ShapePath {
            fillColor: iconColor
            strokeColor: "transparent"
            PathSvg {
                path: {
                    switch(iconName) {
                        case "info": return "M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z";
                        case "eye": return "M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z";
                        case "eye-off": return "M12 7c2.76 0 5 2.24 5 5 0 .65-.13 1.26-.36 1.83l2.92 2.92c1.51-1.26 2.7-2.89 3.43-4.75-1.73-4.39-6-7.5-11-7.5-1.4 0-2.74.25-3.98.7l2.16 2.16C10.74 7.13 11.35 7 12 7zM2 4.27l2.28 2.28.46.46C3.08 8.3 1.78 10.02 1 12c1.73 4.39 6 7.5 11 7.5 1.55 0 3.03-.3 4.38-.84l.42.42L19.73 22 21 20.73 3.27 3 2 4.27zM7.53 9.8l1.55 1.55c-.05.21-.08.43-.08.65 0 1.66 1.34 3 3 3 .22 0 .44-.03.65-.08l1.55 1.55c-.67.33-1.41.53-2.2.53-2.76 0-5-2.24-5-5 0-.79.2-1.53.53-2.2zm4.31-.78l3.15 3.15.02-.16c0-1.66-1.34-3-3-3l-.17.01z";
                        case "chevron": return "M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z";
                        case "close": return "M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z";
                        case "image": return "M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z";
                        case "text": return "M5 4v3h5.5v12h3V7H19V4z";
                        case "upload": return "M9 16h6v-6h4l-7-7-7 7h4zm-4 2h14v2H5z";
                        default: return "";
                    }
                }
            }
        }
    }

    // --- DIALOGS ---
    FileDialog {
        id: openImageDialog
        title: "Select Image"
        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]
        onAccepted: { root.selectedImagePath = currentFile }
    }

    FileDialog {
        id: saveImageDialog
        title: "Save Encrypted Image"
        fileMode: FileDialog.SaveFile
        nameFilters: ["PNG file (*.png)"]
        onAccepted: {
            var encryptedMsg = enigmorph.encrypt(root.stegoSecretMessage)
            if (enigmorph.embedSecret(root.selectedImagePath, currentFile, encryptedMsg)) {
                root.lastAction = "encrypt"
                root.processing = false
            }
        }
    }

    // --- HELPER FUNCTIONS ---
    function copyToClipboard(text) {
        clipboardHelper.text = text
        clipboardHelper.selectAll()
        clipboardHelper.copy()
        copySuccess = true
        copyTimer.restart()
    }

    TextEdit { id: clipboardHelper; visible: false }
    Timer { id: copyTimer; interval: 2000; onTriggered: copySuccess = false }

    // --- MAIN BACKGROUND ---
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: colorBgLight }
            GradientStop { position: 0.6; color: colorBgInput }
            GradientStop { position: 1.0; color: colorBgDark }
        }
    }

    // --- HELP MODAL ---
    Popup {
        id: helpPopup
        anchors.centerIn: parent
        width: 500; height: 500
        modal: true; focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        Rectangle { id: popupMask; anchors.fill: parent; radius: radiusCard; visible: false }
        
        background: Rectangle {
            color: colorBgDark; radius: radiusCard; layer.enabled: true
            layer.effect: MultiEffect { maskEnabled: true; maskSource: ShaderEffectSource { sourceItem: popupMask; hideSource: true } }
            border.color: colorBorderDark; border.width: 1
        }

        contentItem: Item {
            anchors.fill: parent
            
            // Close Button (X) - Top Right
            Item {
                width: 32; height: 32
                anchors.right: parent.right; anchors.top: parent.top
                anchors.margins: 20
                z: 10
                
                Rectangle { anchors.fill: parent; radius: 16; color: closeMouse.containsMouse ? Qt.rgba(1,1,1,0.1) : "transparent" }
                VectorIcon { anchors.centerIn: parent; iconName: "close"; iconColor: colorTextSub }
                MouseArea { id: closeMouse; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: helpPopup.close() }
            }

            ColumnLayout {
                anchors.fill: parent; anchors.margins: 30; spacing: 20

                // Header Elements (Inside Modal)
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 80
                    color: "transparent"
                    RowLayout {
                        anchors.centerIn: parent; spacing: 20
                        Rectangle {
                            width: 48; height: 48; radius: radiusL; color: colorBgInput
                            Canvas {
                                anchors.centerIn: parent; width: 32; height: 32
                                onPaint: { var ctx = getContext("2d"); ctx.reset(); ctx.fillStyle = colorSuccess; ctx.beginPath(); ctx.moveTo(16, 2); ctx.lineTo(28, 7); ctx.lineTo(28, 14); ctx.bezierCurveTo(28, 24, 16, 30, 16, 30); ctx.bezierCurveTo(16, 30, 4, 24, 4, 14); ctx.lineTo(4, 7); ctx.closePath(); ctx.fill(); }
                            }
                        }
                        ColumnLayout {
                            spacing: 0
                            Text { text: "ENIGMORPH"; font.pixelSize: fontSizeTitle; font.bold: true; font.family: fontMain; color: colorTextWhite; font.letterSpacing: -1 }
                            Text { text: "Next-Generation Dynamic Encryption"; font.pixelSize: fontSizeXS; font.weight: Font.DemiBold; color: colorTextLight; font.letterSpacing: 1.2 }
                        }
                    }
                }

                Rectangle { Layout.fillWidth: true; height: 1; color: colorBorderDark; opacity: 0.5 }

                // Instructions
                Text { height: 40; text: "Quick Guide"; color: colorTextWhite; font.pixelSize: fontSizeXL; font.bold: true }

                ScrollView {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    clip: true
                    contentWidth: availableWidth

                    ColumnLayout {
                        width: parent.width
                        spacing: 35
                        
                        Repeater {
                            model: ListModel {
                                ListElement { step: "1"; title: "Set PIN & Keyword"; desc: "Masukkan 4 angka PIN dan kata sandi untuk mengamankan enkripsi." }
                                ListElement { step: "2"; title: "Select Mode"; desc: "Pilih 'Text Mode' untuk pesan biasa, atau 'Image Mode' untuk menyembunyikan pesan dalam foto (Steganografi)." }
                                ListElement { step: "3"; title: "Process"; desc: "Tulis pesan atau unggah gambar, lalu klik Encrypt/Decrypt." }
                                ListElement { step: "4"; title: "Share Safely"; desc: "Bagikan hasil teks atau gambar terenkripsi hanya kepada penerima yang memiliki kunci yang sama." }
                            }
                            delegate: RowLayout {
                                Layout.fillWidth: true
                                spacing: 16
                                Rectangle {
                                    width: 28; height: 28; radius: 14; Layout.alignment: Qt.AlignTop
                                    color: "transparent"; border.color: colorPrimary; border.width: 2
                                    Text { anchors.centerIn: parent; text: model.step; color: colorPrimary; font.bold: true }
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4
                                    Text { text: model.title; color: colorTextWhite; font.bold: true; font.pixelSize: fontSizeM }
                                    Text { 
                                        text: model.desc; color: colorTextLight; font.pixelSize: fontSizeXS; 
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent; anchors.margins: 40; spacing: 24

        // --- HEADER BAR ---
        Item {
            Layout.fillWidth: true; Layout.preferredHeight: 40
            
            // Info Button
            Item {
                width: 40; height: 40; anchors.left: parent.left
                Rectangle { anchors.fill: parent; radius: 20; color: infoMouse.containsMouse ? colorBgInput : "transparent"; Behavior on color { ColorAnimation { duration: 150 } } }
                VectorIcon { anchors.centerIn: parent; iconName: "info"; iconColor: infoMouse.containsMouse ? colorPrimary : colorTextSub }
                MouseArea { id: infoMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: helpPopup.open() }
            }

            // Minimal Title (Right aligned with Dark Container)
            Rectangle {
                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                width: titleRow.width + 32; height: 36
                radius: radiusL
                color: colorBgDark
                border.color: colorBorderDark; border.width: 1
                
                RowLayout {
                    id: titleRow
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "Enigmorph"; color: colorTextWhite; font.bold: true; font.pixelSize: fontSizeM }
                    Rectangle { width: 8; height: 8; radius: 4; color: colorSuccess }
                }
            }
        }

        // --- CONFIGURATION CARD ---
        Rectangle {
            id: configCard
            Layout.fillWidth: true; Layout.preferredHeight: configExpanded ? 160 : 60
            Behavior on Layout.preferredHeight { NumberAnimation { duration: 300; easing.type: Easing.InOutCubic } }
            radius: radiusMax; color: "transparent"
            layer.enabled: true
            layer.effect: MultiEffect { shadowEnabled: true; shadowColor: Qt.rgba(0,0,0,0.37); shadowVerticalOffset: 12; shadowBlur: 32 }
            MouseArea { width: parent.width; height: 60; z: 10; cursorShape: Qt.PointingHandCursor; onClicked: configExpanded = !configExpanded }
            Rectangle { id: maskRect; anchors.fill: parent; radius: radiusMax; visible: false }
            Rectangle {
                id: cardBackground; anchors.fill: parent; radius: radiusMax
                layer.enabled: true; layer.effect: MultiEffect { maskEnabled: true; maskSource: ShaderEffectSource { sourceItem: maskRect; hideSource: true } }
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: colorGradientDarkStart }
                    GradientStop { position: 0.5; color: colorGradientDarkMid }
                    GradientStop { position: 1.0; color: colorGradientDarkEnd }
                }
            }
            ColumnLayout {
                anchors.fill: parent; spacing: 0
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 60
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 32; anchors.rightMargin: 32
                        Text { text: "CONFIGURATION"; font.pixelSize: fontSizeL; font.bold: true; font.letterSpacing: 2; color: colorTextLight; Layout.alignment: Qt.AlignVCenter }
                        Rectangle { visible: !configExpanded; width: 8; height: 8; radius: 4; color: enigmorph.isPinValid ? colorSuccess : colorDanger; Layout.alignment: Qt.AlignVCenter }
                        Item { Layout.fillWidth: true }
                        Text { visible: !configExpanded; text: enigmorph.isPinValid ? "Ready" : "PIN Required"; font.pixelSize: fontSizeS; font.bold: true; color: enigmorph.isPinValid ? colorSuccess : colorDanger; Layout.alignment: Qt.AlignVCenter }
                        
                        // CHEVRON: Center Alignment & Animation Restored
                        Item {
                            Layout.preferredWidth: 20; Layout.preferredHeight: 20; Layout.alignment: Qt.AlignVCenter
                            VectorIcon { 
                                anchors.centerIn: parent
                                iconName: "chevron"
                                iconColor: colorTextLight
                                transformOrigin: Item.Center 
                                rotation: configExpanded ? 180 : 0
                                opacity: 0.6
                                
                                Behavior on rotation {
                                    NumberAnimation { duration: 300; easing.type: Easing.InOutCubic }
                                }
                            }
                        }
                    }
                }
                RowLayout {
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.margins: 32; Layout.topMargin: 0; spacing: 32; visible: opacity > 0; opacity: configExpanded ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 200 } }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 10
                        Text { text: "PIN (4 DIGITS)"; font.pixelSize: fontSizeXS; font.bold: true; font.letterSpacing: 1; color: colorTextLight }
                        Rectangle {
                            id: pinInputBg; Layout.fillWidth: true; height: 48; radius: radiusL; color: colorBgInput; border.width: 3; border.color: enigmorph.isPinValid ? colorSuccess : colorBorderDark
                            RowLayout {
                                anchors.fill: parent; spacing: 0
                                TextField {
                                    id: pinField; Layout.fillWidth: true; Layout.fillHeight: true; leftPadding: 16; placeholderText: "1945"; placeholderTextColor: colorTextSub; font.pixelSize: fontSizeXL; font.family: fontMono; font.letterSpacing: 4; color: colorTextWhite; maximumLength: 4; verticalAlignment: Text.AlignVCenter; echoMode: showPin ? TextInput.Normal : TextInput.Password; passwordCharacter: "•"; background: Rectangle { color: "transparent" }
                                    validator: RegularExpressionValidator { regularExpression: /[0-9]{0,4}/ }
                                    onTextChanged: { enigmorph.pin = text }
                                }
                                Item {
                                    Layout.preferredWidth: 50; Layout.fillHeight: true
                                    VectorIcon { anchors.centerIn: parent; iconName: showPin ? "eye-off" : "eye"; iconColor: colorTextMuted; opacity: 0.9 }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: showPin = !showPin }
                                }
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 10
                        Text { text: "SECRET KEYWORD"; font.pixelSize: fontSizeXS; font.bold: true; font.letterSpacing: 1; color: colorTextLight }
                        Rectangle {
                            Layout.fillWidth: true; height: 48; radius: radiusL; color: colorBgInput; border.width: 3; border.color: passwordField.activeFocus ? colorPrimary : colorBorderDark
                            RowLayout {
                                anchors.fill: parent; spacing: 0
                                TextField {
                                    id: passwordField; Layout.fillWidth: true; Layout.fillHeight: true; leftPadding: 16; placeholderText: "SecretKey"; placeholderTextColor: colorTextSub; font.pixelSize: fontSizeL; color: colorTextWhite; verticalAlignment: Text.AlignVCenter; echoMode: showPassword ? TextInput.Normal : TextInput.Password; passwordCharacter: "•"; background: Rectangle { color: "transparent" }
                                    onTextChanged: { enigmorph.password = text }
                                }
                                Item {
                                    Layout.preferredWidth: 50; Layout.fillHeight: true
                                    VectorIcon { anchors.centerIn: parent; iconName: showPassword ? "eye-off" : "eye"; iconColor: colorTextMuted; opacity: 0.9 }
                                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: showPassword = !showPassword }
                                }
                            }
                        }
                    }
                }
            }
        }

        // --- MAIN WORKSPACE ---
        Rectangle {
            Layout.fillWidth: true; Layout.fillHeight: true; radius: radiusMax
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: colorGradientDarkStart }
                GradientStop { position: 0.5; color: colorGradientDarkMid }
                GradientStop { position: 1.0; color: colorGradientDarkEnd }
            }
            border.color: colorBorderDark; border.width: 1
            layer.enabled: true; layer.effect: MultiEffect { shadowEnabled: true; shadowColor: Qt.rgba(0,0,0,0.37); shadowVerticalOffset: 12; shadowBlur: 48 }

            RowLayout {
                anchors.fill: parent; anchors.margins: 32; spacing: 32

                // --- LEFT COLUMN: INPUT SECTION ---
                ColumnLayout {
                    Layout.fillWidth: true; Layout.fillHeight: true; spacing: 16

                    // HEADER ROW
                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "INPUT MODE"
                            font.pixelSize: fontSizeM; font.bold: true; font.letterSpacing: 1; color: colorTextLight
                        }

                        // Switcher Tab
                        Rectangle {
                            Layout.leftMargin: 12
                            width: 140; height: 28; radius: 14
                            color: colorBgInput; border.color: colorBorderDark; border.width: 1
                            RowLayout {
                                anchors.fill: parent; spacing: 0
                                Rectangle {
                                    Layout.fillWidth: true; Layout.fillHeight: true; radius: 14
                                    color: root.appMode === "text" ? colorPrimary : "transparent"
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    Text { anchors.centerIn: parent; text: "Text"; color: root.appMode === "text" ? "white" : colorTextMuted; font.bold: true; font.pixelSize: fontSizeXS }
                                    MouseArea { anchors.fill: parent; onClicked: root.appMode = "text"; cursorShape: Qt.PointingHandCursor }
                                }
                                Rectangle {
                                    Layout.fillWidth: true; Layout.fillHeight: true; radius: 14
                                    color: root.appMode === "image" ? colorPrimary : "transparent"
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    Text { anchors.centerIn: parent; text: "Image"; color: root.appMode === "image" ? "white" : colorTextMuted; font.bold: true; font.pixelSize: fontSizeXS }
                                    MouseArea { anchors.fill: parent; onClicked: root.appMode = "image"; cursorShape: Qt.PointingHandCursor }
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // Clear Button
                        Button {
                            padding: 0; 
                            Layout.preferredHeight: 24; Layout.preferredWidth: 60
                            visible: (root.appMode === "text" && inputArea.text.length > 0) || (root.appMode === "image" && root.selectedImagePath !== "")
                            
                            contentItem: Text { 
                                text: "Clear"; font.pixelSize: fontSizeS; font.bold: true; color: colorDanger; 
                                anchors.centerIn: parent 
                                verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
                            }
                            background: Rectangle { radius: radiusMax; color: parent.hovered ? Qt.rgba(239/255, 68/255, 68/255, 0.15) : "transparent" }
                            onClicked: {
                                inputArea.text = ""; outputArea.text = ""; lastAction = ""
                                root.selectedImagePath = ""; root.stegoSecretMessage = ""; secretInput.text = ""
                            }
                        }
                    }

                    // MAIN INPUT AREA (STACKED)
                    StackLayout {
                        currentIndex: root.appMode === "text" ? 0 : 1
                        Layout.fillWidth: true; Layout.fillHeight: true

                        // ORIGINAL TEXT INPUT
                        ScrollView {
                            Layout.fillWidth: true; Layout.fillHeight: true; clip: true
                            TextArea {
                                id: inputArea
                                placeholderText: "Type your secret message here..."
                                placeholderTextColor: colorTextMuted
                                wrapMode: Text.Wrap; font.pixelSize: fontSizeL; font.family: fontMain; selectByMouse: true; color: colorTextWhite
                                leftPadding: 20; rightPadding: 20; topPadding: 20; bottomPadding: 20
                                background: Rectangle {
                                    radius: radiusXL; color: colorBgInput
                                    border.color: inputArea.activeFocus ? colorPrimary : colorBorderDark; border.width: 2
                                }
                                onTextChanged: { root.inputText = text }
                            }
                        }

                        // IMAGE INPUT
                        ColumnLayout {
                            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 12

                            // IMAGE CONTAINER (Dynamic Height)
                            Rectangle {
                                id: imgDropZone
                                Layout.fillWidth: true
                                Layout.fillHeight: root.selectedImagePath === ""
                                Layout.preferredHeight: root.selectedImagePath !== "" ? 120 : 0
                                Behavior on Layout.preferredHeight { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

                                color: colorBgInput; radius: radiusXL
                                border.color: root.selectedImagePath !== "" ? colorPrimary : colorBorderDark; border.width: 2
                                
                                DropArea {
                                    anchors.fill: parent
                                    onDropped: (drop) => {
                                        if (drop.hasUrls && (drop.urls[0].toString().endsWith(".png") || drop.urls[0].toString().endsWith(".jpg"))) {
                                            root.selectedImagePath = drop.urls[0].toString()
                                        }
                                    }
                                }

                                // STATE: EMPTY
                                ColumnLayout {
                                    anchors.centerIn: parent; visible: root.selectedImagePath === ""
                                    spacing: 10
                                    VectorIcon { Layout.alignment: Qt.AlignHCenter; iconName: "upload"; iconColor: colorTextMuted; width: 48; height: 48; opacity: 0.5 }
                                    Text { text: "Drop Image or Click to Browse"; color: colorTextMuted; font.bold: true }
                                    
                                    Button {
                                        Layout.alignment: Qt.AlignHCenter
                                        contentItem: Text { 
                                            text: "Browse File"; color: parent.down ? colorTextWhite : colorPrimary; font.bold: true; horizontalAlignment: Text.AlignHCenter 
                                        }
                                        background: Rectangle {
                                            color: parent.hovered ? Qt.rgba(79/255, 70/255, 229/255, 0.1) : "transparent"
                                            radius: 8; border.color: colorPrimary; border.width: 1
                                        }
                                        onClicked: openImageDialog.open()
                                        MouseArea {
                                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onPressed: mouse.accepted = false
                                        }
                                    }
                                }

                                // STATE: FILLED (THUMBNAIL)
                                RowLayout {
                                    anchors.fill: parent; anchors.margins: 12; visible: root.selectedImagePath !== ""
                                    spacing: 16
                                    
                                    Rectangle {
                                        Layout.preferredWidth: 60; Layout.preferredHeight: 60; 
                                        color: "black"; radius: radiusM; clip: true
                                        Image { source: root.selectedImagePath; anchors.fill: parent; fillMode: Image.PreserveAspectFit; mipmap: true }
                                    }
                                    ColumnLayout {
                                        Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter
                                        Text { text: "Image Attached"; color: colorTextWhite; font.bold: true; font.pixelSize: fontSizeS }
                                        Text { text: "Ready to hide secret message"; color: colorSuccess; font.pixelSize: fontSizeXS }
                                    }
                                    Button {
                                        Layout.preferredWidth: 28; Layout.preferredHeight: 28
                                        background: Rectangle { radius: 14; color: parent.hovered ? colorDangerBg : "transparent" }
                                        contentItem: Text { text: "✕"; color: parent.hovered ? colorDanger : colorTextSub; font.bold: true; anchors.centerIn: parent }
                                        onClicked: { root.selectedImagePath = ""; root.stegoSecretMessage = ""; secretInput.text = "" }
                                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.clicked() }
                                    }
                                }
                            }

                            // SECRET MESSAGE INPUT
                            ScrollView {
                                visible: root.selectedImagePath !== ""
                                Layout.fillWidth: true; Layout.fillHeight: true
                                clip: true
                                opacity: visible ? 1.0 : 0.0
                                Behavior on opacity { NumberAnimation { duration: 300 } }

                                ScrollBar.vertical: ScrollBar {
                                    parent: parent
                                    anchors.right: parent.right; anchors.rightMargin: 6
                                    anchors.top: parent.top; anchors.topMargin: 6
                                    anchors.bottom: parent.bottom; anchors.bottomMargin: 6
                                    width: 8; policy: ScrollBar.AsNeeded
                                    contentItem: Rectangle { implicitWidth: 8; implicitHeight: 100; radius: 3; color: parent.pressed ? colorPrimary : colorBorderDark; opacity: parent.active || parent.pressed ? 1.0 : 0.0 }
                                    background: Item { implicitWidth: 6 }
                                }

                                TextArea {
                                    id: secretInput
                                    placeholderText: "Type your secret message to hide in the image..."
                                    placeholderTextColor: colorTextMuted
                                    wrapMode: Text.Wrap; font.pixelSize: fontSizeL; font.family: fontMain; color: colorTextWhite
                                    leftPadding: 20; rightPadding: 20; topPadding: 20; bottomPadding: 20
                                    background: Rectangle {
                                        radius: radiusXL; color: colorBgInput
                                        border.color: secretInput.activeFocus ? colorPrimary : colorBorderDark; border.width: 2
                                    }
                                    onTextChanged: root.stegoSecretMessage = text
                                }
                            }
                        }
                    }

                    // ACTION BUTTONS
                    RowLayout {
                        Layout.fillWidth: true; spacing: 12
                        
                        Button {
                            id: encryptBtn
                            Layout.fillWidth: true; Layout.preferredHeight: 42
                            enabled: enigmorph.isPinValid && (
                                (root.appMode === "text" && inputArea.text.length > 0) || 
                                (root.appMode === "image" && root.selectedImagePath !== "" && secretInput.text.length > 0)
                            )
                            contentItem: Text { text: "ENCRYPT"; font.pixelSize: fontSizeL; font.bold: true; font.letterSpacing: 1; color: encryptBtn.enabled ? colorTextWhite : colorTextMuted; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            background: Rectangle {
                                radius: radiusXXL
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: encryptBtn.enabled ? (encryptBtn.hovered ? colorPrimaryHover : colorPrimary) : colorBgInput }
                                    GradientStop { position: 1.0; color: encryptBtn.enabled ? (encryptBtn.hovered ? colorPrimaryActive : colorPrimaryHover) : colorBgInput }
                                }
                                border.width: encryptBtn.enabled ? 0 : 1; border.color: colorBorderDark
                            }
                            onClicked: { root.processing = true; processTimer.mode = "encrypt"; processTimer.start() }
                        }

                        Button {
                            id: decryptBtn
                            Layout.fillWidth: true; Layout.preferredHeight: 42
                            enabled: enigmorph.isPinValid && (
                                (root.appMode === "text" && inputArea.text.length > 0) || 
                                (root.appMode === "image" && root.selectedImagePath !== "")
                            )
                            contentItem: Text { text: "DECRYPT"; font.pixelSize: fontSizeL; font.bold: true; font.letterSpacing: 1; color: decryptBtn.enabled ? colorTextWhite : colorTextMuted; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                            background: Rectangle {
                                radius: radiusXXL
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: decryptBtn.enabled ? (decryptBtn.hovered ? colorSuccessHover : colorSuccess) : colorBgInput }
                                    GradientStop { position: 1.0; color: decryptBtn.enabled ? (decryptBtn.hovered ? colorSuccessActive : colorSuccessHover) : colorBgInput }
                                }
                                border.width: decryptBtn.enabled ? 0 : 1; border.color: colorBorderDark
                            }
                            onClicked: { root.processing = true; processTimer.mode = "decrypt"; processTimer.start() }
                        }
                    }

                    Rectangle {
                        visible: !enigmorph.isPinValid
                        Layout.fillWidth: true; height: 36; radius: radiusM; color: colorWarningBg; border.color: colorWarningBorder; border.width: 1
                        RowLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 8
                            Text { Layout.fillWidth: true; text: "Please enter a valid 4-digit PIN to proceed"; font.pixelSize: fontSizeS; font.bold: true; color: colorWarningText }
                        }
                    }
                }

                // VERTICAL DIVIDER
                Rectangle { Layout.preferredWidth: 2; Layout.fillHeight: true; color: colorBorderDark; radius: 1 }

                // --- RIGHT COLUMN: OUTPUT SECTION ---
                ColumnLayout {
                    Layout.fillWidth: true; Layout.fillHeight: true; spacing: 16

                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "OUTPUT RESULT"; font.pixelSize: fontSizeM; font.bold: true; font.letterSpacing: 1; color: colorTextLight }
                        
                        Rectangle {
                            visible: lastAction !== ""; width: statusText.contentWidth + 20; height: 22; radius: 11
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: lastAction === "encrypt" ? colorPrimary : colorSuccess }
                                GradientStop { position: 1.0; color: lastAction === "encrypt" ? "#7c3aed" : colorSuccessHover }
                            }
                            Text { id: statusText; anchors.centerIn: parent; text: lastAction === "encrypt" ? (root.appMode==="image"? "IMAGE SAVED":"ENCRYPTED") : "DECRYPTED"; font.pixelSize: fontSizeMicro; font.bold: true; color: colorTextWhite }
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        // Copy Button
                        Button {
                            padding: 0; Layout.preferredHeight: 24; Layout.preferredWidth: 60
                            visible: outputArea.text.length > 0
                            contentItem: Text { 
                                text: copySuccess ? "Copied!" : "Copy"; font.pixelSize: fontSizeS; font.bold: true; color: copySuccess ? colorSuccess : colorTextLight; 
                                anchors.centerIn: parent
                                verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
                            }
                            background: Rectangle { radius: radiusMax; color: parent.hovered ? (copySuccess ? Qt.rgba(16/255, 185/255, 129/255, 0.15) : Qt.rgba(255/255, 255/255, 255/255, 0.1)) : "transparent"; border.color: copySuccess ? colorSuccess : "transparent"; border.width: copySuccess ? 2 : 0 }
                            onClicked: { root.copyToClipboard(outputArea.text) }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true; radius: radiusXL; color: colorBgInput; border.color: colorBorderDark; border.width: 2
                        layer.enabled: outputArea.text.length > 0; layer.effect: MultiEffect { shadowEnabled: true; shadowColor: Qt.rgba(0,0,0,0.2); shadowBlur: 12 }

                        ColumnLayout {
                            visible: outputArea.text.length === 0; anchors.centerIn: parent; spacing: 8
                            Rectangle {
                                Layout.alignment: Qt.AlignHCenter; width: 45; height: 45; radius: radiusXL; color: colorBorderDark
                                Text { anchors.centerIn: parent; text: "⇄"; font.pixelSize: fontSizeIcon; color: colorTextWhite }
                            }
                            Text { Layout.alignment: Qt.AlignHCenter; text: "Result will appear here"; font.pixelSize: 13; font.weight: Font.DemiBold; color: colorTextMuted }
                        }

                        ScrollView {
                            visible: outputArea.text.length > 0; anchors.fill: parent; clip: true
                            ScrollBar.vertical: ScrollBar {
                                parent: parent; anchors.right: parent.right; anchors.rightMargin: 6; anchors.top: parent.top; anchors.topMargin: 6; anchors.bottom: parent.bottom; anchors.bottomMargin: 6; width: 8; policy: ScrollBar.AsNeeded
                                contentItem: Rectangle { implicitWidth: 8; implicitHeight: 100; radius: 3; color: parent.pressed ? colorPrimary : colorBorderDark; opacity: parent.active || parent.pressed ? 1.0 : 0.0 }
                                background: Item { implicitWidth: 6 }
                            }
                            TextArea {
                                id: outputArea; readOnly: true; wrapMode: Text.Wrap; font.pixelSize: fontSizeL; font.family: fontMono; selectByMouse: true; color: colorTextWhite
                                leftPadding: 24; rightPadding: 24; topPadding: 24; bottomPadding: 24; background: Rectangle { color: "transparent" }
                            }
                        }

                        Rectangle {
                            visible: processing; anchors.fill: parent; radius: parent.radius; color: "#cc0f172a"
                            ColumnLayout {
                                anchors.centerIn: parent; spacing: 15
                                Rectangle {
                                    Layout.alignment: Qt.AlignHCenter; width: 50; height: 50; radius: 25; color: "transparent"; border.width: 4; border.color: colorPrimary
                                    Rectangle {
                                        width: 4; height: 20; radius: 2; color: colorPrimary; anchors.horizontalCenter: parent.horizontalCenter; y: 6; transformOrigin: Item.Bottom
                                        RotationAnimation on rotation { loops: Animation.Infinite; from: 0; to: 360; duration: 1000 }
                                    }
                                }
                                Text { Layout.alignment: Qt.AlignHCenter; text: "Processing..."; font.pixelSize: fontSizeM; font.weight: Font.DemiBold; color: colorTextWhite }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Rectangle { width: 6; height: 6; radius: 3; color: colorSuccess; SequentialAnimation on opacity { loops: Animation.Infinite; NumberAnimation { to: 0.3; duration: 800 } NumberAnimation { to: 1.0; duration: 800 } } }
                        Text { text: "Algorithm: Dynamic Positional Shift (ASCII Base)"; font.pixelSize: fontSizeXS; color: colorTextLight; opacity: 0.7 }
                        Item { Layout.fillWidth: true }
                        Text { visible: outputArea.text.length > 0; text: outputArea.text.length + " characters"; font.pixelSize: fontSizeXS; font.family: fontMono; color: colorTextLight; opacity: 0.7 }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true; Layout.preferredHeight: 40; spacing: 2
            Text { Layout.alignment: Qt.AlignHCenter; text: "© " + new Date().getFullYear() + " Enigmorph Project"; font.pixelSize: fontSizeS; font.weight: Font.Medium; color: colorTextLight }
            Text { Layout.alignment: Qt.AlignHCenter; text: "Secure • Fast • Reliable"; font.pixelSize: fontSizeMicro; color: colorTextLight }
        }
    }

    Timer {
        id: processTimer
        interval: 300
        property string mode: ""
        onTriggered: {
            if (root.appMode === "text") {
                if (mode === "encrypt") {
                    outputArea.text = enigmorph.encrypt(inputArea.text)
                    lastAction = "encrypt"
                } else if (mode === "decrypt") {
                    outputArea.text = enigmorph.decrypt(inputArea.text)
                    lastAction = "decrypt"
                }
                processing = false
            } 
            else if (root.appMode === "image") {
                if (mode === "encrypt") {
                    saveImageDialog.open()
                } else {
                    var extractedCipher = enigmorph.extractSecret(root.selectedImagePath)
                    if (extractedCipher === "") {
                        outputArea.text = "Error: Tidak ditemukan pesan rahasia pada gambar ini!"
                        lastAction = "decrypt"
                    } else {
                        outputArea.text = enigmorph.decrypt(extractedCipher)
                        lastAction = "decrypt"
                    }
                    processing = false
                }
            }
        }
    }
}