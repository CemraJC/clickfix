; --- Load directives ---

#SingleInstance force
InstallMouseHook
SendMode "Input"
SetWorkingDir A_ScriptDir

; --- Actual program ---

ver := "4.0.0"
settings_file := "ClickFix_Settings.ini"
startup_shortcut := A_Startup . "\ClickFix.lnk"
settings := Map()

; Initialize Settings in the following way:
; array[key]   := ["Section", "Key", "Value", "OPT: Other variables" ...]
settings["lb"] := ["Mouse", "left_button", false]
settings["mb"] := ["Mouse", "middle_button", false]
settings["rb"] := ["Mouse", "right_button", false]
settings["fb"] := ["Mouse", "forward_button", false]
settings["bb"] := ["Mouse", "back_button", false]
settings["lpr"] := ["General", "left_pressure", 25, "Left click"]
settings["mpr"] := ["General", "middle_pressure", 25, "Middle click"]
settings["rpr"] := ["General", "right_pressure", 25, "Right click"]
settings["fpr"] := ["General", "forward_pressure", 25, "Forward click"]
settings["bpr"] := ["General", "back_pressure", 25, "Back click"]
settings["sww"] := ["General", "startup_run", false]
settings["dis"] := ["General", "disabled", false]

; Initialize Last-click times
last_m_down := 0
last_m_up := 0

last_l_down := 0
last_l_up := 0

last_r_down := 0
last_r_up := 0

last_f_down := 0
last_f_up := 0

last_b_down := 0
last_b_up := 0

; Let's assume that this is a first-run, since there's no settings
if !FileExist(settings_file)
{
    write_settings(settings)
    settingsGui()
    about()
}

; Initialize the program's functionality
read_settings(settings)

; Set up the right click menu
TrayMenu := A_TrayMenu
TrayMenu.Delete() ; Delete the standard items.
A_IconTip := "ClickFix - Tame your mouse"

TrayMenu.Add("About", about)

OptionsMenu := Menu()
OptionsMenu.Add("Fix Left Button", flb)
OptionsMenu.Add("Fix Middle Button", fmb)
OptionsMenu.Add("Fix Right Button", frb)
OptionsMenu.Add("Fix Forward Button", ffb)
OptionsMenu.Add("Fix Back Button", fbb)
OptionsMenu.Add()
OptionsMenu.Add("Start with Windows", sww)
TrayMenu.Add("Quick Options", OptionsMenu)
TrayMenu.Add("Full Settings", settingsGui)
TrayMenu.Default := "Full Settings"


TrayMenu.Add()
TrayMenu.Add("Restart", restart)
TrayMenu.Add("Toggle Active", toggle_enabled)
TrayMenu.Add()
TrayMenu.Add("Reset", reset)
TrayMenu.Add("Exit", exit)

; Set the App Icon
setTrayIcon()

; Define the settings GUI
settingsGui(name := "", pos := "", mu := "") {
    global

    ; Initialization
    MainGui := Gui()
    MainGui.Opt("-Resize -MaximizeBox +OwnDialogs")

    ; Title and Copyright
    MainGui.SetFont("s19", "Arial")
    MainGui.Add("Text", "Center W500 yp-2", "ClickFix Settings")
    MainGui.SetFont("s8 c808080", "Trebuchet MS")
    MainGui.Add("Text", "Center W500 yp+28", "Copyright (c) 2023 Jason Cemra")

    ; Leading Paragraph
    MainGui.SetFont("s10 c101013", "Arial")
    MainGui.Add("Text", "Left W500 yp+16", "Choose which mouse button needs fixing - you can select multiple.`nIf you're having issues, adjust the corresponding slider until your clicks are fixed, and`nRemember to click the Apply or Ok button!")

    ; Standard Settings
    MainGui.SetFont("s8 c505050", "Trebuchet MS")
    MainGui.Add("GroupBox", "yp+49 w235 h210", "Standard Settings")
    MainGui.SetFont("s10 c10101f", "Trebuchet MS")
    MainGui.Add("Text", "Left w210 xp+12 yp+22", "Choose mouse buttons to fix:")

    cb := MainGui.Add("Checkbox", "yp+25 vcheck_left_button", "Left Click")
    cb.OnEvent("Click", settingsCheckBoxes)
    cb := MainGui.Add("Checkbox", "yp+25 vcheck_middle_button", "Middle Click")
    cb.OnEvent("Click", settingsCheckBoxes)
    cb := MainGui.Add("Checkbox", "yp+25 vcheck_right_button", "Right Click")
    cb.OnEvent("Click", settingsCheckBoxes)
    cb := MainGui.Add("Checkbox", "yp+25 vcheck_forward_button", "Forward Button")
    cb.OnEvent("Click", settingsCheckBoxes)
    cb := MainGui.Add("Checkbox", "yp+25 vcheck_back_button", "Back Button")
    cb.OnEvent("Click", settingsCheckBoxes)

    MainGui.Add("Text", "Left w210 yp+19", "Other Settings:")
    MainGui.Add("Checkbox", "yp+21 vcheck_start_with_windows", "Start on Windows Startup")
    MainGui.SetFont("s8 c810000", "Arial")
    ResetBtn := MainGui.Add("Button", "yp+30 w236 xp-12", "Reset everything to default")
    ResetBtn.OnEvent("Click", settingsButtonReset)

    ; Buttons
    MainGui.SetFont("s8 c101013 w340", "Arial")
    OkBtn := MainGui.Add("Button", "Default xp Y338 w75", "Ok")
    OkBtn.OnEvent("Click", settingsButtonOk)
    ApplyBtn := MainGui.Add("Button", "xp+80 Y338 w75", "Apply")
    ApplyBtn.OnEvent("Click", settingsButtonApply)
    CancelBtn := MainGui.Add("Button", "xp+80 Y338 w75", "Cancel")
    CancelBtn := CancelBtn.OnEvent("Click", settingsButtonCancel)

    ; Advanced Settings
    MainGui.SetFont("s8 c505050", "Trebuchet MS")
    MainGui.Add("GroupBox", "xp+85 y92 w235 h275", "Advanced/Tweaking Settings")
    MainGui.SetFont("s10 c101013", "Trebuchet MS")
    MainGui.Add("Text", "Left w210 xp+12 yp+22", "`"Pressure`" for each mouse button:")
    MainGui.SetFont("s7 c101013 w700", "Arial")
    MainGui.Add("Link", "Left w210 yp+25 vslide_readout_l", "Left click has 0ms of delay.")
    sl := MainGui.Add("Slider", "yp+13 xp-7 w218 vslide_pressure_l", "20")
    sl.OnEvent("Change", settingsPressureSlider)
    MainGui.Add("Link", "Left w210 yp+32 xp+7 vslide_readout_m", "Middle click has 0ms of delay.")
    sl := MainGui.Add("Slider", "yp+13 xp-7 w218 vslide_pressure_m", "20")
    sl.OnEvent("Change", settingsPressureSlider)
    MainGui.Add("Link", "Left w210 yp+32 xp+7 vslide_readout_r", "Right click has 0ms of delay.")
    sl := MainGui.Add("Slider", "yp+13 xp-7 w218 vslide_pressure_r", "20")
    sl.OnEvent("Change", settingsPressureSlider)
    MainGui.Add("Link", "Left w210 yp+32 xp+7 vslide_readout_f", "Forward click has 0ms of delay.")
    sl := MainGui.Add("Slider", "yp+13 xp-7 w218 vslide_pressure_f", "20")
    sl.OnEvent("Change", settingsPressureSlider)
    MainGui.Add("Link", "Left w210 yp+32 xp+7 vslide_readout_b", "Back click has 0ms of delay.")
    sl := MainGui.Add("Slider", "yp+13 xp-7 w218 vslide_pressure_b", "20")
    sl.OnEvent("Change", settingsPressureSlider)

    loadSettingsToGui()
    settingsCheckBoxes()
    MainGui.Title := "ClickFix Settings"
    MainGui.Show("W530 H380 Center")

    ; Show a warning if the program is disabled
    If (settings["dis"][3]) {
        MsgBox("ClickFix Disabled. Press Ctrl + Shift + ~ to toggle this.", "Warning", 0x30)
    }
}

; GUI Actions
settingsCheckBoxes(ctxt := "", val := "")
{
    global
    MainGui.Submit(false)
    MainGui["check_left_button"].Enabled := MainGui["slide_pressure_l"].Value
    MainGui["check_middle_button"].Enabled := MainGui["slide_pressure_m"].Value
    MainGui["check_right_button"].Enabled := MainGui["slide_pressure_r"].Value
    MainGui["check_forward_button"].Enabled := MainGui["slide_pressure_f"].Value
    MainGui["check_back_button"].Enabled := MainGui["slide_pressure_b"].Value
    settingsPressureSlider()
}

settingsPressureSlider(ctxt := "", val := "")
{
    global
    bufferSlidePressure()
    MainGui["slide_readout_l"].Text := slidePressureReadout(settings["lpr"], MainGui["check_left_button"].Value)
    MainGui["slide_readout_m"].Text := slidePressureReadout(settings["mpr"], MainGui["check_middle_button"].Value)
    MainGui["slide_readout_r"].Text := slidePressureReadout(settings["rpr"], MainGui["check_right_button"].Value)
    MainGui["slide_readout_f"].Text := slidePressureReadout(settings["fpr"], MainGui["check_forward_button"].Value)
    MainGui["slide_readout_b"].Text := slidePressureReadout(settings["bpr"], MainGui["check_back_button"].Value)
}

settingsButtonOk(ctxt := "", val := "")
{
    if (pullSettingsFromGui()) {
        MainGui.Destroy()
    }
}

settingsButtonApply(ctxt := "", val := "")
{
    pullSettingsFromGui()
}

settingsButtonCancel(ctxt := "", val := "")
{
    MainGui.Destroy()
}

settingsButtonReset(ctxt := "", val := "")
{
    MainGui.Opt("+OwnDialogs")
    reset()
}

loadSettingsToGui()
{
    global

    try {
        MainGui["check_left_button"].Visible
    } catch as e {
        ; GUI doesn't exist
        return
    }

    MainGui["check_left_button"].Value := settings["lb"][3]
    MainGui["check_middle_button"].Value := settings["mb"][3]
    MainGui["check_right_button"].Value := settings["rb"][3]
    MainGui["check_forward_button"].Value := settings["fb"][3]
    MainGui["check_back_button"].Value := settings["bb"][3]
    MainGui["slide_pressure_l"].Value := settings["lpr"][3]
    MainGui["slide_pressure_m"].Value := settings["mpr"][3]
    MainGui["slide_pressure_r"].Value := settings["rpr"][3]
    MainGui["slide_pressure_f"].Value := settings["fpr"][3]
    MainGui["slide_pressure_b"].Value := settings["bpr"][3]
    MainGui["slide_readout_l"].Text := slidePressureReadout(settings["lpr"], settings["lb"][3])
    MainGui["slide_readout_m"].Text := slidePressureReadout(settings["mpr"], settings["mb"][3])
    MainGui["slide_readout_r"].Text := slidePressureReadout(settings["rpr"], settings["rb"][3])
    MainGui["slide_readout_f"].Text := slidePressureReadout(settings["fpr"], settings["fb"][3])
    MainGui["slide_readout_b"].Text := slidePressureReadout(settings["bpr"], settings["bb"][3])
    MainGui["check_start_with_windows"].Value := settings["sww"][3]
}

pullSettingsFromGui()
{
    global
    MainGui.Submit(false)
    settings["lb"][3] := MainGui["check_left_button"].Value
    settings["mb"][3] := MainGui["check_middle_button"].Value
    settings["rb"][3] := MainGui["check_right_button"].Value
    settings["fb"][3] := MainGui["check_forward_button"].Value
    settings["bb"][3] := MainGui["check_back_button"].Value
    bufferSlidePressure()
    settings["sww"][3] := MainGui["check_start_with_windows"].Value
    save()
    update_sww_state(settings["sww"][3])
    updateTrayMenuState()
    return true
}

bufferSlidePressure()
{
    global
    MainGui.Submit(false)
    settings["lpr"][3] := MainGui["slide_pressure_l"].Value
    settings["mpr"][3] := MainGui["slide_pressure_m"].Value
    settings["rpr"][3] := MainGui["slide_pressure_r"].Value
    settings["fpr"][3] := MainGui["slide_pressure_f"].Value
    settings["bpr"][3] := MainGui["slide_pressure_b"].Value
}

slidePressureReadout(obj, toggler := 1)
{
    suffix := "."
    if (slidePressureScale(obj[3]) >= 150 && toggler == 1) {
        suffix := "!"
    }
    if (toggler == 0) {
        value := "no delay (fix disabled)"
    } else {
        value := slidePressureScale(obj[3]) . "ms of delay"
    }
    return obj[4] . " has " . value . suffix
}

slidePressureScale(pressure)
{
    return Ceil(1.0202**(pressure + 250) - 140)
}

; Load in the menu state to reflect the settings
; Need a neater solution...
updateTrayMenuState()
{
    global
    if (settings["lb"][3] == true) {
        OptionsMenu.Check("Fix Left Button")
    } else {
        OptionsMenu.UnCheck("Fix Left Button")
    }

    if (settings["mb"][3] == true) {
        OptionsMenu.Check("Fix Middle Button")
    } else {
        OptionsMenu.UnCheck("Fix Middle Button")
    }

    if (settings["rb"][3] == true) {
        OptionsMenu.Check("Fix Right Button")
    } else {
        OptionsMenu.UnCheck("Fix Right Button")
    }

    if (settings["fb"][3] == true) {
        OptionsMenu.Check("Fix Forward Button")
    } else {
        OptionsMenu.UnCheck("Fix Forward Button")
    }

    if (settings["bb"][3] == true) {
        OptionsMenu.Check("Fix Back Button")
    } else {
        OptionsMenu.UnCheck("Fix Back Button")
    }

    if (settings["sww"][3] == true) {
        OptionsMenu.Check("Start With Windows")
    } else {
        OptionsMenu.UnCheck("Start With Windows")
    }
}

setTrayIcon()
{
    global
    If (settings["dis"][3]) {
        TraySetIcon "./icon/ClickFix-icon-disabled.ico"
    } else {
        TraySetIcon "./icon/ClickFix-icon.ico"
    }
}

updateTrayMenuState()
Sleep 500  ; There seems to be an issue with the startup shortcut disappearing
update_sww_state(settings["sww"][3])

; Use a hotkey to enable/disable the software functionality
toggle_enabled(name := "", pos := "", mu := "")
{
    settings["dis"][3] := !settings["dis"][3]
    setTrayIcon()
    save()
}

^+`::
{
    toggle_enabled()
}


; Menu handlers - using labels to manipulate global variables
flb(name := "", pos := "", mu := "")
{
    global
    OptionsMenu.ToggleCheck("Fix Left Button")
    settings["lb"][3] := !settings["lb"][3]
    save()
    loadSettingsToGui()
}

fmb(name := "", pos := "", mu := "")
{
    global
    OptionsMenu.ToggleCheck("Fix Middle Button")
    settings["mb"][3] := !settings["mb"][3]
    save()
    loadSettingsToGui()
}

frb(name := "", pos := "", mu := "")
{
    global
    OptionsMenu.ToggleCheck("Fix Right Button")
    settings["rb"][3] := !settings["rb"][3]
    save()
    loadSettingsToGui()
}

ffb(name := "", pos := "", mu := "")
{
    global
    OptionsMenu.ToggleCheck("Fix Forward Button")
    settings["fb"][3] := !settings["fb"][3]
    save()
    loadSettingsToGui()
}

fbb(name := "", pos := "", mu := "")
{
    global
    OptionsMenu.ToggleCheck("Fix Back Button")
    settings["bb"][3] := !settings["bb"][3]
    save()
    loadSettingsToGui()
}

sww(name := "", pos := "", mu := "")
{
    global
    OptionsMenu.ToggleCheck("Start With Windows")
    settings["sww"][3] := !settings["sww"][3]
    save()
    update_sww_state(settings["sww"][3])
    loadSettingsToGui()
}

reset(name := "", pos := "", mu := "")
{
    global
    Result := MsgBox("This will completely wipe all settings and exit the program.", "Are you sure?", 0x34)
    if Result = "No"
        return
    FileDelete settings_file
    startup_shortcut_destroy()
    ExitApp
}

exit(name := "", pos := "", mu := "")
{
    save()
    ExitApp
}



; Function definitions

save()
{
    global settings
    write_settings(settings)
}

write_settings(settings)
{
    global settings_file
    for index, var in settings {
        IniWrite var[3], settings_file, var[1], var[2]
    }
}

read_settings(settings)
{
    global settings_file
    for index, var in settings {
        result := IniRead(settings_file, var[1], var[2])
        var[3] := result
    }
}

update_sww_state(state)
{
    global startup_shortcut
    if (state) {
        try {
            FileGetShortcut startup_shortcut, &shortcut_path
        } catch as e {
            ; Ignore
        }
        if (!FileExist(startup_shortcut) || shortcut_path != A_ScriptFullPath) {
            startup_shortcut_create()
        }
    } else {
        startup_shortcut_destroy()
    }
}


startup_shortcut_create()
{
    global startup_shortcut
    FileCreateShortcut A_ScriptFullPath, startup_shortcut, A_WorkingDir
}

startup_shortcut_destroy()
{
    global startup_shortcut
    try {
        FileDelete startup_shortcut
    } catch as e {
        ; Ignore
    }
}

about(name := "", pos := "", mu := "")
{
    global ver
    try {
        MainGui.Opt("+OwnDialogs")
    } catch as e {
        ; GUI doesn't exist - ignore
    }
    MsgBox "Thank you for using ClickFix!`n`nClickFix is always available from the taskbar tray area (if it's running). Remember, ClickFix makes an unusable mouse into a bearable one until a replacement can be made. You may experience issues with the mouse not clicking at times - simply right click on the tray icon to restart the program.`n`nThis software is at version " . ver . ".`nCopyright 2023 Jason Cemra - released under the GPLv3.`nSpecial thanks to the AutoHotKey crew, for making this program easy to write.`n`nNote: You may need to hit ESC to let go of the ClickFix settings window.", "Welcome to ClickFix!", 0x40
}

restart(name := "", pos := "", mu := "")
{
    Reload
    ExitApp
}



; The real logic of the program - hotkeys triggered by mouse events
#HotIf settings["mb"][3] and !settings["dis"][3]
MButton::
{
    global
    if (A_TickCount - last_m_down >= slidePressureScale(settings["mpr"][3]) && A_TickCount - last_m_up >= slidePressureScale(settings["mpr"][3])) {
        Send "{Blind}{MButton Down}"
        last_m_down := A_TickCount
    }
}

MButton up::
{
    global
    if (A_TickCount - last_m_up >= slidePressureScale(settings["mpr"][3])) {
        Send "{Blind}{MButton Up}"
        last_m_up := A_TickCount
    }
}

#HotIf settings["lb"][3] and !settings["dis"][3]
LButton::
{
    global
    Critical
    if (A_TickCount - last_l_down >= slidePressureScale(settings["lpr"][3]) && A_TickCount - last_l_up >= slidePressureScale(settings["lpr"][3])) {
        Send "{Blind}{LButton Down}"
        last_l_down := A_TickCount
    }
}

LButton up::
{
    global
    if (A_TickCount - last_l_up >= slidePressureScale(settings["lpr"][3])) {
        Send "{Blind}{LButton Up}"
        last_l_up := A_TickCount
    }
}

#HotIf settings["rb"][3] and !settings["dis"][3]
*RButton::
{
    global
    if (A_TickCount - last_r_down >= slidePressureScale(settings["rpr"][3]) && A_TickCount - last_r_up >= slidePressureScale(settings["rpr"][3])) {
        Send "{Blind}{RButton Down}"
        last_r_down := A_TickCount
    }
}

*RButton up::
{
    global
    if (A_TickCount - last_r_up >= slidePressureScale(settings["rpr"][3])) {
        Send "{Blind}{RButton Up}"
        last_r_up := A_TickCount
    }
}

#HotIf settings["fb"][3] and !settings["dis"][3]
*XButton2::
{
    global
    if (A_TickCount - last_f_down >= slidePressureScale(settings["fpr"][3]) && A_TickCount - last_f_up >= slidePressureScale(settings["fpr"][3])) {
        Send "{Blind}{XButton2 Down}"
        last_f_down := A_TickCount
    }
}

*XButton2 up::
{
    global
    if (A_TickCount - last_f_up >= slidePressureScale(settings["fpr"][3])) {
        Send "{Blind}{XButton2 Up}"
        last_f_up := A_TickCount
    }
}

#HotIf settings["bb"][3] and !settings["dis"][3]
*XButton1::
{
    global
    if (A_TickCount - last_b_down >= slidePressureScale(settings["bpr"][3]) && A_TickCount - last_b_up >= slidePressureScale(settings["bpr"][3])) {
        Send "{Blind}{XButton1 Down}"
        last_b_down := A_TickCount
    }
}

*XButton1 up::
{
    global
    if (A_TickCount - last_b_up >= slidePressureScale(settings["bpr"][3])) {
        Send "{Blind}{XButton1 Up}"
        last_b_up := A_TickCount
    }
}