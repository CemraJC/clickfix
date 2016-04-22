#InstallMouseHook
#SingleInstance, force

settings_file = ClickFix_Settings.ini
ver := "1.0.2"
left_button := 1
right_button := 1
middle_button := 1

; Set up the right click menu
Menu, Tray, NoStandard
; Menu, Tray, Add, Options
Menu, Tray, Add, About, about
Menu, options, Add, Fix Left Button, flb
Menu, options, Add, Fix Middle Button, fmb
Menu, options, Add, Fix Right Button, frb
Menu, Tray, Add, Options, :options
Menu, Tray, Add,
Menu, Tray, Add, Reset, reset
Menu, Tray, Add, Exit, exit

if !FileExist(settings_file) {
    write_settings("false", "false", "false")
    about()
}
read_settings(left_button, middle_button, right_button)
set_hotkey_states()

; Load in the menu state to reflect the settings
if (left_button == "true") {
    Menu, options, Check, Fix Left Button
}

if (right_button == "true") {
    Menu, options, Check, Fix Right Button
}

if (middle_button == "true") {
    Menu, options, Check, Fix Middle Button
}
return

flb:
menu, options, ToggleCheck, Fix Left Button
toggle(left_button)
save()
set_hotkey_states()
return

fmb:
menu, options, ToggleCheck, Fix Middle Button
toggle(middle_button)
save()
set_hotkey_states()
return

frb:
menu, options, ToggleCheck, Fix Right Button
toggle(right_button)
save()
set_hotkey_states()
return




reset:
MsgBox, 0x34, Are you sure?, This will completely wipe all settings and exit the program.
IfMsgBox, No
    return
FileDelete, %settings_file%
ExitApp

exit:
save()
ExitApp

save() {
    global left_button
    global middle_button
    global right_button
    write_settings(left_button, middle_button, right_button)
}

write_settings(l, m, r) {
    global settings_file
    IniWrite, %l%, %settings_file%, Mouse, left_button
    IniWrite, %m%, %settings_file%, Mouse, middle_button
    IniWrite, %r%, %settings_file%, Mouse, right_button
}

read_settings(ByRef l, ByRef m, ByRef r) {
    global settings_file
    IniRead, l, %settings_file%, Mouse, left_button
    IniRead, m, %settings_file%, Mouse, middle_button
    IniRead, r, %settings_file%, Mouse, right_button
}

set_hotkey_states() {
    global left_button
    global middle_button
    global right_button
    if (left_button == "true") {
        Hotkey, LButton, On
    } else {
        Hotkey, LButton, Off
    }

    if (middle_button == "true") {
        Hotkey, MButton, On
    } else {
        Hotkey, MButton, Off
    }

    if (right_button == "true") {
        Hotkey, RButton, On
    } else {
        Hotkey, RButton, Off
    }
}

toggle(ByRef var) {
    if (var == "true") {
        var := "false"
        return
    } else if (var == "false") {
        var := "true"
        return
    }
}

toggle_start_with_windows(state){
    ; Toggles start with windows
}

about(){
global ver
MsgBox, 0x40, Welcome to ClickFix!, % "There is a real issue in modern society - wild mice.`nThey constantly rebel against the loving hand of their keeper and click without instruction - destroying their usefulness. Well, I say no more! With ClickFix, we hope to tame your wild mouse and make it usable again - at least until you can get another.`n`nTo get started, simply right click on the tray icon and under 'Options' click the name of the button on your mouse that's giving you grief. You can choose to start ClickFix with Windows in this menu as well (for convenience). ClickFix will run in the background, keeping a leash on your mouse.`n`nThis script is at version " . ver . ".`nCopyright 2016 Jason Cemra - released under the GPL.`nVery special thanks to the AutoHotKey crew, for making this script easy."
}

; Stop the middle mouse from re-clicking constantly
MButton::
Click Middle Down
is_down := 1
while (is_down) {
    Sleep 35
    is_down := GetKeyState("MButton", "P")
}
Sleep 50
Click Middle Up
return

LButton::
Click Left Down
is_down := 1
while (is_down) {
    Sleep 5
    is_down := GetKeyState("LButton", "P")
}
Sleep 10
Click Left Up
return

RButton::
Click Right Down
is_down := 1
while (is_down) {
    Sleep 5
    is_down := GetKeyState("RButton", "P")
}
Sleep 10
Click Right Up
return