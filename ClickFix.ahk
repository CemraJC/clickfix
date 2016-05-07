#InstallMouseHook
#SingleInstance, force



ver := "1.1.2"
settings_file = ClickFix_Settings.ini
startup_shortcut := A_Startup . "\ClickFix.lnk"
settings := Object()

; Initialize Settings in the following way:
; array[key]   := ["Section", "Key", "Value"]
settings["lb"] := ["Mouse", "left_button", false]
settings["mb"] := ["Mouse", "middle_button", false]
settings["rb"] := ["Mouse", "right_button", false]
settings["sww"] := ["General", "startup_run", false]

; Let's assume that this is a first-run, since there's no settings
if !FileExist(settings_file) {
    write_settings(settings)
    about()
}

; Initialize the program's functionality
read_settings(settings)
update_sww_state(settings["sww"][3])
set_hotkey_states()


; Set up the right click menu
Menu, Tray, NoStandard

Menu, Tray, Add, About, about

Menu, options, Add, Fix Left Button, flb
Menu, options, Add, Fix Middle Button, fmb
Menu, options, Add, Fix Right Button, frb
Menu, options, Add
Menu, options, Add, Start with Windows, sww
Menu, Tray, Add, Options, :options

Menu, Tray, Add,
Menu, Tray, Add, Reset, reset
Menu, Tray, Add, Exit, exit
Menu, Tray, Tip, ClickFix - Tame your mouse


; Load in the menu state to reflect the settings
; Need a neater solution...
if (settings["lb"][3] == true) {
    Menu, options, Check, Fix Left Button
}

if (settings["mb"][3] == true) {
    Menu, options, Check, Fix Middle Button
}

if (settings["rb"][3] == true) {
    Menu, options, Check, Fix Right Button
}

if (settings["sww"][3] == true) {
    Menu, options, Check, Start With Windows
}

return



; Menu handlers - using labels to manipulate global variables
flb:
Menu, options, ToggleCheck, Fix Left Button
settings["lb"][3] := !settings["lb"][3]
save()
set_hotkey_states()
return

fmb:
Menu, options, ToggleCheck, Fix Middle Button
settings["mb"][3] := !settings["mb"][3]
save()
set_hotkey_states()
return

frb:
Menu, options, ToggleCheck, Fix Right Button
settings["rb"][3] := !settings["rb"][3]
save()
set_hotkey_states()
return

sww:
menu, options, ToggleCheck, Start With Windows
settings["sww"][3] := !settings["sww"][3]
save()
update_sww_state(settings["sww"][3])
return

reset:
MsgBox, 0x34, Are you sure?, This will completely wipe all settings and exit the program.
IfMsgBox, No
    return
FileDelete, %settings_file%
startup_shortcut_destroy()
ExitApp

exit:
save()
ExitApp



; Function definitions

save() {
    global settings
    write_settings(settings)
}

write_settings(settings) {
    global settings_file
    for index, var in settings {
        IniWrite, % var[3], %settings_file%, % var[1], % var[2]
    }
}

; FIX
read_settings(ByRef settings) {
    global settings_file
    for index, var in settings {
        IniRead, buffer, %settings_file%, % var[1], % var[2]
        var[3] := buffer
    }
}

set_hotkey_states() {
    global settings
    if (settings["lb"][3] == true) {
        Hotkey, LButton, On
    } else {
        Hotkey, LButton, Off
    }

    if (settings["mb"][3] == true) {
        Hotkey, MButton, On
    } else {
        Hotkey, MButton, Off
    }

    if (settings["rb"][3] == true) {
        Hotkey, RButton, On
    } else {
        Hotkey, RButton, Off
    }
}

; Makes sure the settings are refleched
update_sww_state(state){
    global startup_shortcut
    if (state) {
        FileGetShortcut, %startup_shortcut%, shortcut_path
        if (!FileExist(startup_shortcut) || shortcut_path != A_ScriptFullPath) {
            startup_shortcut_create()
        }
    } else {
        MsgBox % "Destroying shortcut! shortcut_path: " . shortcut_path . " A_ScriptFullPath: " . A_ScriptFullPath . " state: " . state
        startup_shortcut_destroy()
    }
}


startup_shortcut_create() {
    global startup_shortcut
    FileCreateShortcut, %A_ScriptFullPath%, %startup_shortcut%
}

startup_shortcut_destroy() {
    global startup_shortcut
    ; FileDelete, %startup_shortcut%
}

about(){
global ver
MsgBox, 0x40, Welcome to ClickFix!, % "Thank you for using ClickFix!`n`nTo get started, simply right click on the tray icon and under 'Options', select the name of the button on your mouse that's giving you grief. You can also choose to start ClickFix with Windows here. ClickFix will run in the background, keeping a leash on your mouse. It is always available from the taskbar tray area (if it's running)`n`nThis software is at version " . ver . ".`nCopyright 2016 Jason Cemra - released under the GPLv3.`nVery special thanks to the AutoHotKey crew, for making this program easy."
}



; The real logic of the program - hotkeys triggered by mouse events
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