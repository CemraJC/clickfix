; --- Load directives ---

#SingleInstance, force
#InstallMouseHook
SendMode, Input
SetWorkingDir %A_ScriptDir%

; --- Actual program ---

ver := "2.2.1"
settings_file = ClickFix_Settings.ini
startup_shortcut := A_Startup . "\ClickFix.lnk"
settings := Object()

; Initialize Settings in the following way:
; array[key]   := ["Section", "Key", "Value"]
settings["lb"] := ["Mouse", "left_button", false]
settings["mb"] := ["Mouse", "middle_button", false]
settings["rb"] := ["Mouse", "right_button", false]
settings["pr"] := ["General", "pressure", 25]
settings["sww"] := ["General", "startup_run", false]

; Initialize Last-click times
last_m_down := 0
last_m_up := 0

last_l_down := 0
last_l_up := 0

last_r_down := 0
last_r_up := 0

; Let's assume that this is a first-run, since there's no settings
if !FileExist(settings_file) {
    write_settings(settings)
    settingsGui()
    about()
}

; Initialize the program's functionality
read_settings(settings)

; Set up the right click menu
Menu, Tray, NoStandard

Menu, Tray, Add, About, about

Menu, options, Add, Fix Left Button, flb
Menu, options, Add, Fix Middle Button, fmb
Menu, options, Add, Fix Right Button, frb
Menu, options, Add
Menu, options, Add, Start with Windows, sww
Menu, Tray, Add, Quick Options, :options
Menu, Tray, Add, Full Settings, settingsGui
Menu, Tray, Default, Full Settings


Menu, Tray, Add,
Menu, Tray, Add, Restart, restart
Menu, Tray, Add,
Menu, Tray, Add, Reset, reset
Menu, Tray, Add, Exit, exit
Menu, Tray, Tip, ClickFix - Tame your mouse

; Define the settings GUI
settingsGui() {
    global

    ; Initialization
    Gui, Settings: New
    Gui, Settings: -Resize -MaximizeBox +OwnDialogs

    ; Title and Copyright
    Gui, Settings:font, s18, Arial
    Gui, Settings:Add, Text, Center W500, ClickFix Settings
    Gui, Settings:font, s8 c808080, Trebuchet MS
    Gui, Settings:Add, Text, Center W500 yp+26, Copyright (c) 2016 Jason Cemra

    ; Leading Paragraph
    Gui, Settings:font, s10 c101013, Arial
    Gui, Settings:Add, Text, Left W500 yp+22, Choose which mouse button needs fixing - you can select multiple.`nIf you're having issues, adjust the slider until your clicks are fixed!

    ; Standard Settings
    Gui, Settings:font, s8 c505050, Trebuchet MS
    Gui, Settings:Add, GroupBox, w235 h220, Standard Settings
    Gui, Settings:font, s10 c10101f, Trebuchet MS
    Gui, Settings:Add, Text, Left w210 xp+12 yp+22, Choose mouse buttons to fix:
    Gui, Add, Checkbox, yp+25 vcheck_left_button, Fix Left Mouse Button
    Gui, Add, Checkbox, yp+25 vcheck_middle_button, Fix Middle Mouse Button
    Gui, Add, Checkbox, yp+25 vcheck_right_button, Fix Right Mouse Button
    Gui, Settings:Add, Text, Left w210 yp+35, Other Settings:
    Gui, Add, Checkbox, yp+25 vcheck_start_with_windows, Start on Windows Startup
    Gui, Settings:font, s10 c810000, Arial
    Gui, Settings:Add, Button, yp+25 w210 gSettingsButtonReset, Reset everything to default

    ; Advanced Settings
    Gui, Settings:font, s8 c505050, Trebuchet MS
    Gui, Settings:Add, GroupBox, xp+245 y106 w235 h190, Advanced
    Gui, Settings:font, s10 c101013, Trebuchet MS
    Gui, Settings:Add, Text, Left w210 xp+12 yp+22, "Pressure" for the fix:
    Gui, Add, Slider, yp+20 xp-6 w218 vslide_pressure gSettingsPressureSlider, 20
    Gui, Settings:font, s8 c101013 w700, Arial
    Gui, Settings:Add, Link, Left w210 yp+32 xp+6 vslide_readout, Currently 0ms of delay.
    Gui, Settings:font, s8 c101013 w400, Arial
    Gui, Settings:Add, Text, Left w210 yp+18, Note that the pressure scale is not linear.
    Gui, Settings:Add, Text, Left w210 yp+18, Slide this more to the right if ClickFix isn't working properly all the time. Don't forget`nto hit "Apply" between changes.

    ; Buttons
    Gui, Settings:Add, Button, Default xp-12 Y302 w75, Ok
    Gui, Settings:Add, Button, xp+80 Y302 w75, Apply
    Gui, Settings:Add, Button, xp+80 Y302 w75, Cancel

    loadSettingsToGui()
    Gui, show, W530 H345 center, ClickFix Settings
}

; GUI Actions
settingsPressureSlider() {
    global
    GuiControl, Settings:, slide_readout, % slidePressureReadout(slide_pressure)
}
settingsButtonOk() {
    if (pullSettingsFromGui()) {
        Gui, Settings:Destroy
    }
}
settingsButtonApply(){
    pullSettingsFromGui()
}
loadSettingsToGui(){
    global
    GuiControl, Settings:, check_left_button, % settings["lb"][3]
    GuiControl, Settings:, check_middle_button, % settings["mb"][3]
    GuiControl, Settings:, check_right_button, % settings["rb"][3]
    GuiControl, Settings:, slide_pressure, % settings["pr"][3]
    GuiControl, Settings:, slide_readout, % slidePressureReadout(settings["pr"][3])
    GuiControl, Settings:, check_start_with_windows, % settings["sww"][3]
}
pullSettingsFromGui(){
    global
    Gui, Settings:Submit, NoHide
    if (slidePressureScale(slide_pressure) >= 150) {
        MsgBox, 0x31, Severe Lag Warning!, Warning! Setting the fix pressure above 150ms can make the mouse frustrating to use and may cause problems with double clicking.
        IfMsgBox, Cancel
            return false
    }
    settings["lb"][3] := check_left_button
    settings["mb"][3] := check_middle_button
    settings["rb"][3] := check_right_button
    settings["pr"][3] := slide_pressure
    settings["sww"][3] := check_start_with_windows
    save()
    update_sww_state(settings["sww"][3])
    updateTrayMenuState()
    return true
}
settingsButtonCancel(){
    Gui, Settings:Destroy
}
settingsButtonReset() {
    Gui, Settings: +OwnDialogs
    reset()
}
slidePressureReadout(unscaled) {
    suffix := ""
    if (slidePressureScale(unscaled) >= 150) {
        suffix := "!"
    }
    return "Currently " . slidePressureScale(unscaled) . "ms of delay" . suffix
}
slidePressureScale(pressure){
    return Ceil(1.0202**(pressure + 250) - 140)
}
; Load in the menu state to reflect the settings
; Need a neater solution...
updateTrayMenuState(){
    global
    if (settings["lb"][3] == true) {
        Menu, options, Check, Fix Left Button
    } else {
        Menu, options, UnCheck, Fix Left Button
    }

    if (settings["mb"][3] == true) {
        Menu, options, Check, Fix Middle Button
    } else {
        Menu, options, UnCheck, Fix Middle Button
    }

    if (settings["rb"][3] == true) {
        Menu, options, Check, Fix Right Button
    } else {
        Menu, options, UnCheck, Fix Right Button
    }

    if (settings["sww"][3] == true) {
        Menu, options, Check, Start With Windows
    } else {
        Menu, options, UnCheck, Start With Windows
    }
}

updateTrayMenuState()
Sleep, 500  ; There seems to be an issue with the startup shortcut disappearing
update_sww_state(settings["sww"][3])

return



; Menu handlers - using labels to manipulate global variables
flb:
Menu, options, ToggleCheck, Fix Left Button
settings["lb"][3] := !settings["lb"][3]
save()
loadSettingsToGui()
return

fmb:
Menu, options, ToggleCheck, Fix Middle Button
settings["mb"][3] := !settings["mb"][3]
save()
loadSettingsToGui()
return

frb:
Menu, options, ToggleCheck, Fix Right Button
settings["rb"][3] := !settings["rb"][3]
save()
loadSettingsToGui()
return

sww:
menu, options, ToggleCheck, Start With Windows
settings["sww"][3] := !settings["sww"][3]
save()
update_sww_state(settings["sww"][3])
loadSettingsToGui()
return

reset(){
    global
    MsgBox, 0x34, Are you sure?, This will completely wipe all settings and exit the program.
    IfMsgBox, No
        return
    FileDelete, %settings_file%
    startup_shortcut_destroy()
    ExitApp
}

exit:
save()
ExitApp
return



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

read_settings(ByRef settings) {
    global settings_file
    for index, var in settings {
        IniRead, buffer, %settings_file%, % var[1], % var[2]
        var[3] := buffer
    }
}

update_sww_state(state){
    global startup_shortcut
    if (state) {
        FileGetShortcut, %startup_shortcut%, shortcut_path
        if (!FileExist(startup_shortcut) || shortcut_path != A_ScriptFullPath) {
            startup_shortcut_create()
        }
    } else {
        startup_shortcut_destroy()
    }
}


startup_shortcut_create() {
    global startup_shortcut
    FileCreateShortcut, %A_ScriptFullPath%, %startup_shortcut%, %A_WorkingDir%
}

startup_shortcut_destroy() {
    global startup_shortcut
    FileDelete, %startup_shortcut%
}

about() {
    global ver
    Gui, Settings:+OwnDialogs
    MsgBox, 0x40, Welcome to ClickFix!, % "Thank you for using ClickFix!`n`nClickFix is always available from the taskbar tray area (if it's running). Whether ClickFix works for you or it doesn't, send me a message! I'm always looking for ways to improve the software: cemrajc+clickfix@gmail.com.`n`nThis software is at version " . ver . ".`nCopyright 2016 Jason Cemra - released under the GPLv3.`nSpecial thanks to the AutoHotKey crew, for making this program easy."
}

restart() {
    Reload
    ExitApp
}



; The real logic of the program - hotkeys triggered by mouse events
#If, settings["mb"][3]
MButton::
if (A_TickCount - last_m_down >= slidePressureScale(settings["pr"][3]) && A_TickCount - last_m_up >= slidePressureScale(settings["pr"][3])) {
    Send {MButton Down}
    last_m_down := A_TickCount
}
return

MButton up::
Send {MButton Up}
if (A_TickCount - last_m_up >= slidePressureScale(settings["pr"][3])) {
    last_m_up := A_TickCount
}
return

#If, settings["lb"][3]
LButton::
if (A_TickCount - last_l_down >= slidePressureScale(settings["pr"][3]) && A_TickCount - last_l_up >= slidePressureScale(settings["pr"][3])) {
    Send {LButton Down}
    last_l_down := A_TickCount
}
return

LButton up::
Send {LButton Up}
if (A_TickCount - last_l_up >= slidePressureScale(settings["pr"][3])) {
    last_l_up := A_TickCount
}
return

#If, settings["rb"][3]
RButton::
if (A_TickCount - last_r_down >= slidePressureScale(settings["pr"][3]) && A_TickCount - last_r_up >= slidePressureScale(settings["pr"][3])) {
    Send {RButton Down}
    last_r_down := A_TickCount
}
return

RButton up::
Send {RButton Up}
if (A_TickCount - last_r_up >= slidePressureScale(settings["pr"][3])) {
    last_r_up := A_TickCount
}
return
