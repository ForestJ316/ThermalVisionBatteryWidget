ScriptName TVF_BatteryWidgetScript Extends Quest

String Property Battery_Widget = "TVF_Battery_Widget.swf" AutoReadOnly
TM_Vision_Script Property TMVisionScript Auto Const Mandatory

String Property Battery_MCM = "TVF_BatteryWidget" AutoReadOnly

; HUDFramework
HUDFramework hud
Int Property Command_UpdateBattery = 100 AutoReadOnly
Int Property Command_ScaleBattery = 200 AutoReadOnly
Int Property Command_SetBatteryPos = 300 AutoReadOnly

Potion Property Battery Auto Const Mandatory
GlobalVariable Property BatteryCurrentPercent Auto
Actor Property PlayerRef Auto
ActorValue Property PipboyLightActive Auto
Bool bWasSettingChanged = False
Int iCurrentBatteryState = -1 ; Init -1
; Battery Rads
GlobalVariable Property BatteryGivesRads Auto
GlobalVariable Property BatteryRadsAmount Auto
Bool Property BatteryRadsDoFlash = False Auto
Bool bBatteryRadsFlashing = False

Event OnQuestInit()
	Self.RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")
	Self.RegisterForCustomEvent(TMVisionScript, "BatteryStateEvent")
	Self.RegisterForMenuOpenCloseEvent("PauseMenu")
	Self.RegisterForExternalEvent("OnMCMSettingChange|TVF_BatteryWidget", "OnMCMSettingChange")
	hud = HUDFramework.GetInstance()
    if hud
        hud.RegisterWidget(Self, Battery_Widget, 0, 0, abLoadNow = True, abAutoLoad = True)
    else
        Debug.MessageBox("HUDFramework is not installed!")
    endif
	iCurrentBatteryState = -1
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	Self.RegisterForCustomEvent(TMVisionScript, "BatteryStateEvent")
	Self.RegisterForMenuOpenCloseEvent("PauseMenu")
	Self.RegisterForExternalEvent("OnMCMSettingChange|TVF_BatteryWidget", "OnMCMSettingChange")
	hud = HUDFramework.GetInstance()
	if hud
		if !hud.IsWidgetRegistered(Battery_Widget)
			hud.RegisterWidget(Self, Battery_Widget, 0, 0, abLoadNow = True, abAutoLoad = True)
		endif
	else
		Debug.MessageBox("HUDFramework is not installed!")
	endif
	iCurrentBatteryState = -1
EndEvent

Function OnMCMSettingChange(String modName, String id)
	if modName == Battery_MCM
		bWasSettingChanged = True
	endif
EndFunction

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)
	if asMenuName == "PauseMenu" && !abOpening && bWasSettingChanged
		bWasSettingChanged = False
		MCMUpdateBatteryWidget()
	endif
EndEvent

; This function is called by HUDFramework when the widget is loaded.
Function HUD_WidgetLoaded(string asWidget)
    if (asWidget == Battery_Widget)
		MCMUpdateBatteryWidget()
    endif
EndFunction

Function MCMUpdateBatteryWidget()
	; Scale
	float mcmScale = MCM.GetModSettingFloat(Battery_MCM, "fWidgetScale:General")
	hud.SendMessage(Battery_Widget, Command_ScaleBattery, mcmScale, mcmScale)
	; Position
	int mainPos = MCM.GetModSettingInt(Battery_MCM, "iWidgetMainPos:General")
	if mainPos == 0
		hud.SendMessageString(Battery_Widget, Command_SetBatteryPos, "TopLeft")
	elseif mainPos == 1
		hud.SendMessageString(Battery_Widget, Command_SetBatteryPos, "TopRight")
	elseif mainPos == 2
		hud.SendMessageString(Battery_Widget, Command_SetBatteryPos, "BottomRight")
	elseif mainPos == 3
		hud.SendMessageString(Battery_Widget, Command_SetBatteryPos, "BottomLeft")
	endif
	float posX = MCM.GetModSettingFloat(Battery_MCM, "fWidgetPosX:General")
	float posY = MCM.GetModSettingFloat(Battery_MCM, "fWidgetPosY:General")
	hud.SetWidgetPosition(Battery_Widget, posX, posY)
	; Battery Rads
	BatteryGivesRads.SetValue(MCM.GetModSettingBool(Battery_MCM, "bEmptyBatteryGivesRads:General") as float)
	BatteryRadsAmount.SetValue(MCM.GetModSettingFloat(Battery_MCM, "fBatteryRadsAmount:General"))
	BatteryRadsDoFlash = MCM.GetModSettingBool(Battery_MCM, "bBatteryRadsDoFlash:General")
	if bBatteryRadsFlashing && (!BatteryRadsDoFlash || BatteryGivesRads.GetValue() == 0.0)
		bBatteryRadsFlashing = False
	endif
EndFunction

Event TM_Vision_Script.BatteryStateEvent(TM_Vision_Script akSender, Var[] akArgs)
	float batteryHealthMax = akArgs[0] as float
	float batteryHealth = akArgs[1] as float
	bool bIsLoadGame = akArgs[2] as bool
	float batteryPercent = batteryHealth / batteryHealthMax
	BatteryCurrentPercent.SetValue(batteryPercent)
	float flashlightActive = PlayerRef.GetValue(PipboyLightActive)
	
	if batteryPercent > 0.95 && iCurrentBatteryState != 100
		iCurrentBatteryState = 100
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery100")
	elseif batteryPercent <= 0.95 && batteryPercent > 0.90 && iCurrentBatteryState != 95
		iCurrentBatteryState = 95
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery95")
	elseif batteryPercent <= 0.90 && batteryPercent > 0.85 && iCurrentBatteryState != 90
		iCurrentBatteryState = 90
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery90")
	elseif batteryPercent <= 0.85 && batteryPercent > 0.80 && iCurrentBatteryState != 85
		iCurrentBatteryState = 85
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery85")
	elseif batteryPercent <= 0.80 && batteryPercent > 0.75 && iCurrentBatteryState != 80
		iCurrentBatteryState = 80
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery80")
	elseif batteryPercent <= 0.75 && batteryPercent > 0.70 && iCurrentBatteryState != 75
		iCurrentBatteryState = 75
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery75")
	elseif batteryPercent <= 0.70 && batteryPercent > 0.65 && iCurrentBatteryState != 70
		iCurrentBatteryState = 70
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery70")
	elseif batteryPercent <= 0.65 && batteryPercent > 0.60 && iCurrentBatteryState != 65
		iCurrentBatteryState = 65
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery65")
	elseif batteryPercent <= 0.60 && batteryPercent > 0.55 && iCurrentBatteryState != 60
		iCurrentBatteryState = 60
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery60")
	elseif batteryPercent <= 0.55 && batteryPercent > 0.50 && iCurrentBatteryState != 55
		iCurrentBatteryState = 55
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery55")
	elseif batteryPercent <= 0.50 && batteryPercent > 0.45 && iCurrentBatteryState != 50
		iCurrentBatteryState = 50
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery50")
	elseif batteryPercent <= 0.45 && batteryPercent > 0.40 && iCurrentBatteryState != 45
		iCurrentBatteryState = 45
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery45")
	elseif batteryPercent <= 0.40 && batteryPercent > 0.35 && iCurrentBatteryState != 40
		iCurrentBatteryState = 40
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery40")
	elseif batteryPercent <= 0.35 && batteryPercent > 0.30 && iCurrentBatteryState != 35
		iCurrentBatteryState = 35
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery35")
	elseif batteryPercent <= 0.30 && batteryPercent > 0.25 && iCurrentBatteryState != 30
		iCurrentBatteryState = 30
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery30")
	elseif batteryPercent <= 0.25 && batteryPercent > 0.20 && iCurrentBatteryState != 25
		iCurrentBatteryState = 25
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery25")
	elseif batteryPercent <= 0.20 && batteryPercent > 0.15 && iCurrentBatteryState != 20
		iCurrentBatteryState = 20
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery20")
	elseif batteryPercent <= 0.15 && batteryPercent > 0.10 && iCurrentBatteryState != 15
		iCurrentBatteryState = 15
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery15")
	elseif batteryPercent <= 0.10 && batteryPercent > 0.05 && iCurrentBatteryState != 10
		iCurrentBatteryState = 10
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery10")
	elseif batteryPercent <= 0.05 && batteryPercent > 0.0 && iCurrentBatteryState != 5
		iCurrentBatteryState = 5
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery5")
	elseif batteryPercent == 0.0 && flashlightActive == 1.0
		iCurrentBatteryState = 0
		if !bBatteryRadsFlashing
			hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery0")
		endif
	elseif batteryPercent == 0.0 && flashlightActive == 0.0
		iCurrentBatteryState = 0
		if !bBatteryRadsFlashing
			if !bIsLoadGame
				hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "BatteryEmptyAnim")
			else
				hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery0")
			endif
		endif
	endif
EndEvent

Function FlashEmptyBattery()
	if PlayerRef.GetItemCount(Battery) > 0
		TMVisionScript.OnTimer(22)
	else
		hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "BatteryEmptyAnim")
	endif
EndFunction

Function FlashBatteryRads(bool bEffectStart)
	if BatteryGivesRads.GetValue() == 1.0 && BatteryRadsDoFlash
		if bEffectStart
			bBatteryRadsFlashing = True
			hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "BatteryRadsLoop")
		else
			bBatteryRadsFlashing = False
			hud.SendMessageString(Battery_Widget, Command_UpdateBattery, "Battery0")
		endif
	endif
EndFunction
