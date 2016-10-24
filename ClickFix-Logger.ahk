; --- Load directives ---

#SingleInstance, force
#InstallMouseHook
SendMode, Input
SetWorkingDir %A_ScriptDir%

; --- Actual Script ---
;
; Description:
;   This is a debugging + optimizing script that is solely for logging what clicks occur and when.
;   For security reasons, the clicks are not logged to a file - they are stored in memory.

Menu, Tray, NoStandard

Menu, Tray, Add, Restart, restart
Menu, Tray, Add, Clear Log, clearscreen
Menu, Tray, Add,
Menu, Tray, Add, Exit, exit
Menu, Tray, Tip, ClickFix Click Logger - Understand your mouse

loggerGui() {
    global

    ; Initialization
    Gui, Logger: New
    Gui, Logger: -Resize -MaximizeBox +OwnDialogs +AlwaysOnTop

    ; Title and Copyright
    Gui, Logger:font, s16, Arial
    Gui, Logger:Add, Text, W500, Click Log:
    Gui, Logger:font, s8, Arial
    Gui, Logger:Add, Button, xp+330 w60 h20 gclearscreen, Clear

    Gui, Logger:font, s8, Consolas
    Gui, Logger:Add, Edit, Readonly x20 yp+30 w390 h540 vlog_view, Click Somewhere!

    Gui, show, W430 H600 center, ClickFix Click Logger
}

loggerGui()

clearscreen() {
    global

    screen := ""
    Gui, Logger:Submit, NoHide
    GuiControl, Logger:, log_view, % screen
}

addLine(click) {
    global

    FormatTime, time, , hh:mm:ss tt (dd/MM/yyyy)
    screen := screen . "Detected a " . click . " click at " . time . "`n"

    Gui, Logger:Submit, NoHide
    GuiControl, Logger:, log_view, % screen
}

restart() {
    Reload
    ExitApp
}

LoggerGuiClose() {
    ExitApp
}

exit() {
    ExitApp
}

~LButton up::
addLine("left   ( up )")
return

~LButton::
addLine("left   (down)")
return

~RButton up::
addLine("right  ( up )")
return

~RButton::
addLine("right  (down)")
return

~MButton up::
addLine("middle ( up )")
return

~MButton::
addLine("middle (down)")
return