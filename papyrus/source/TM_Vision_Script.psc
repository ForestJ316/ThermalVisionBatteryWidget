ScriptName TM_Vision_Script Extends Quest

;-- Variables ---------------------------------------
Bool ActiveVisionOnOffLocked = False
Bool CycleLocked = False
Int FirstPersonState = 0 Const
Bool GogglesOnOffLocked = False
Int LightCheck = 22
Bool OverlayOnOffLocked = False
Bool RechargeLocked = False
Int ScopeCheck = 21
Bool ScopeCycleLocked = False
Bool ScopeOnOffLocked = False
Int ThirdPerson1State = 7 Const
Int ThirdPerson2State = 8 Const

;-- Properties --------------------------------------
Group KeyCodes
  Int Property N = 78 AutoReadOnly
  Int Property H = 72 AutoReadOnly
  Int Property U = 85 AutoReadOnly
  Int Property L = 76 AutoReadOnly
EndGroup

Spell Property TM_Spell_I Auto Const
Spell Property TM_Spell_T Auto Const
Spell Property TM_Spell_NV Auto Const
Spell Property TM_Spell_I_Vision_OF Auto Const
Spell Property TM_Spell_T_Vision_OF Auto Const
Spell Property TM_Spell_NV_Vision_OF Auto Const
Spell Property TM_Spell_I_OF_Vision_Time Auto Const
Spell Property TM_Spell_T_OF_Vision_Time Auto Const
Spell Property TM_Spell_I_OF_Scope_Time Auto Const
Spell Property TM_Spell_T_OF_Scope_Time Auto Const
Spell Property TM_Spell_Recharge Auto Const
Keyword Property TM_LowBat Auto Const mandatory
Keyword Property TM_Overlay_Off Auto Const mandatory
Keyword Property TM_OnOff Auto Const mandatory
Keyword Property TM_Thermal Auto Const mandatory
Keyword Property TM_Infrared Auto Const mandatory
Keyword Property TM_NV Auto Const mandatory
Keyword Property TM_Cycle_Image Auto Const mandatory
Keyword Property TM_Cycle_Enabled Auto Const mandatory
Keyword Property TM_Scope_OnOff Auto Const mandatory
Keyword Property TM_Thermal_Scope Auto Const mandatory
Keyword Property TM_Infrared_Scope Auto Const mandatory
Keyword Property TM_NV_Scope Auto Const mandatory
Keyword Property TM_Scope_Cycle_Enabled Auto Const mandatory
Keyword Property TM_Active_Vision_Enabled Auto Const mandatory
Keyword Property TM_Cycle_Sound Auto Const mandatory
Keyword Property TM_Cycle Auto Const mandatory
Keyword Property TM_Animations_Enabled Auto Const mandatory
Keyword Property TM_Recharge Auto Const mandatory
Keyword Property TM_Light_Empty_State Auto Const mandatory
Keyword Property TM_Debug_Enabled Auto Const mandatory
Keyword Property TM_NVG_Equipped Auto Const mandatory
Keyword Property TM_OF_Check Auto Const mandatory
Keyword Property TM_WatchTime_Check Auto Const mandatory
Keyword Property TM_WatchTime_Performance Auto Const mandatory
Keyword Property TM_Charge_Check Auto Const mandatory
Keyword Property TM_1st Auto Const mandatory
Keyword Property TM_3rd Auto Const mandatory
Armor Property TM_Armor_Overlay Auto Const
Armor Property TM_Armor_Dummy Auto Const
Armor Property TM_FlashLight_On Auto Const
Armor Property TM_FlashLight_Off Auto Const
Armor Property TM_Watch Auto Const
Armor Property TM_NVG_Armor Auto Const mandatory
objectmod Property TM_NVG_Up Auto Const mandatory
objectmod Property TM_NVG_Down Auto Const mandatory
Sound Property TM_Bat_Warning Auto Const
Sound Property TM_Scope_Switch Auto Const
Sound Property TM_Cycle_Switch Auto Const
Sound Property TM_Vision_ON Auto Const
Sound Property TM_Vision_OFF Auto Const
Potion Property Battery Auto Const mandatory
Potion Property CheatBattery Auto Const mandatory
Potion Property Recharge_Device Auto Const mandatory
Potion Property NVG_Goggles_Upgrade Auto Const mandatory
Idle Property NVG_On Auto Const
Idle Property NVG_On_3rd Auto Const
Idle Property NVG_On_3rd_WD Auto Const
Idle Property NVG_Off Auto Const
Idle Property NVG_Off_3rd Auto Const
Idle Property NVG_Off_3rd_WD Auto Const
Idle Property NVG_Recharge Auto Const
Idle Property NVG_Recharge_100 Auto Const
Idle Property NVG_Recharge_75 Auto Const
Idle Property NVG_Recharge_50 Auto Const
Idle Property NVG_Recharge_25 Auto Const
Idle Property NVG_Recharge_3rd Auto Const
Idle Property NVG_Equip Auto Const
Idle Property Watch_Check Auto Const
Idle Property Watch_Check_3rd Auto Const
Idle Property Watch_Check_3rd_WD Auto Const
Idle Property WeapSheath Auto Const
GlobalVariable Property TM_Bat_Health Auto
GlobalVariable Property TM_MCM_Bat_Health Auto
GlobalVariable Property TM_NV_Strength Auto
GlobalVariable Property TM_Thermal_Strength Auto
GlobalVariable Property TM_Infrared_Strength Auto
GlobalVariable Property TM_Charge_Sec Auto
GlobalVariable Property TM_Charge_Sec_Set Auto
GlobalVariable Property TM_Charge_50Sec Auto
GlobalVariable Property TM_Charge_50Sec_Set Auto
GlobalVariable Property TM_Charge_Min Auto
ActorValue Property PipboyLightActive Auto
ActorValue Property TM_Recharge_Stage Auto
Float Property BatHealth Auto
Float Property MCMBatHealth Auto
Float Property NVStrength Auto
Float Property ThermalStrength Auto
Float Property InfraredStrength Auto
Float Property LightHealth = 0.0 Auto
Float Property RechargeStage Auto
Float Property RechargePercent Auto
Float Property ChargeSec Auto
Float Property ChargeSecSet Auto
Float Property Charge50Sec Auto
Float Property Charge50SecSet Auto
Float Property ChargeMinCheck Auto
Bool Property LowBatSoundEnabled = True Auto
Bool Property OnOffSoundEnabled = True Auto
Bool Property ScopeOnOffSoundEnabled = True Auto
Bool Property VisionHotkeyEndabled = False Auto
Bool Property ScopeHotkeyEndabled = False Auto
Bool Property CycleSoundEnabled = True Auto
Bool Property AnimationsEnabled = True Auto
Bool Property FlashlightEnabled = False Auto
Bool Property DebugNotificationEnabled = True Auto
Bool Property OverlayEnabled = True Auto
Bool Property WatchPerformanceEnabled = False Auto

; Patched
Actor Property PlayerRef Auto
CustomEvent BatteryStateEvent
Bool bRechargedWithDevice = False
GlobalVariable Property TVF_BatteryGivesRads Auto

;-- Functions ---------------------------------------

Event OnInit()
  Actor player = PlayerRef
  Self.RegisterForRemoteEvent(player, "OnPlayerLoadGame")
  Self.RegisterForCameraState()
  Self.LowBatSound()
  Self.GoggleSoundOnOff()
  Self.ScopeSoundOnOff()
  Self.CycleSound()
  Self.AnimationsOnOff()
  Self.FlashLightOnOff()
  Self.DebugNotificationOnOff()
  Self.OFCheck()
  Self.Recharge()
  Self.FillRechargeDevice()
  Self.ChargeMinSecFill()
  player.AddKeyword(TM_NV)
  player.AddKeyword(TM_NV_Scope)
  player.AddKeyword(TM_Charge_Check)
  player.AddItem(Battery as Form, 5, False)
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
  SendBatteryEvent(TM_Bat_Health.GetValue(), TM_MCM_Bat_Health.GetValue(), True)
  Actor player = PlayerRef
  Self.RegisterForCameraState()
  Self.clearall()
  Self.LowBatSound()
  Self.GoggleSoundOnOff()
  Self.ScopeSoundOnOff()
  Self.CycleSound()
  Self.AnimationsOnOff()
  Self.FlashLightOnOff()
  Self.DebugNotificationOnOff()
  Self.OFCheck()
  player.AddKeyword(TM_Charge_Check)
EndEvent

Function SendBatteryEvent(float akBatHealth, float akMCMBatHealth, bool bIsLoadGame = False)
  Var[] args = new Var[3]
  args[0] = akMCMBatHealth
  args[1] = akBatHealth
  args[2] = bIsLoadGame
  SendCustomEvent("BatteryStateEvent", args)
EndFunction

Event OnKeyUp(Int keyCode, Float time)
  Actor player = PlayerRef
  If keyCode == 78 && time > 0.400000006
    Self.GogglesOnOff()
  ElseIf keyCode == 78 && time > 0.0
    Self.CycleMode()
  ElseIf keyCode == 85 && time > 0.400000006
    Self.ScopeOnOff()
  ElseIf keyCode == 85 && time > 0.0
    Self.ScopeCycleMode()
  ElseIf keyCode == 72 && time > 0.400000006
    Self.OverlayOnOff()
  ElseIf keyCode == 72 && time > 0.0
    Self.ActiveVisionOnOff()
  ElseIf keyCode == 76 && time > 0.400000006
    Self.RechargeDevice()
  ElseIf keyCode == 76 && time > 0.0
    Self.ChargePercent()
  EndIf
  Self.UnregisterForKey(78)
  Self.UnregisterForKey(72)
  Self.UnregisterForKey(85)
  Self.UnregisterForKey(76)
EndEvent

Function VisionHotkeyMCM()
  Self.RegisterForKey(78)
EndFunction

Function ScopeHotkeyMCM()
  Self.RegisterForKey(85)
EndFunction

Function OverlayHotkeyMCM()
  Self.RegisterForKey(72)
EndFunction

Function RechargeHotkeyMCM()
  Self.RegisterForKey(76)
EndFunction

Function FlashLightOnOff()
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
  player.RemoveItem(TM_FlashLight_On as Form, 1, True, None)
  Self.CancelTimer(LightCheck)
  bakautil.UnregisterForPipboyLightEvent(Self as Var)
  Utility.Wait(0.100000001)
  If FlashlightEnabled
    bakautil.RegisterForPipboyLightEvent(Self as Var)
    If BatHealth > 0.0
      player.EquipItem(TM_FlashLight_On as Form, True, True)
    ElseIf BatHealth == 0.0
      player.EquipItem(TM_FlashLight_Off as Form, True, True)
    EndIf
  EndIf
EndFunction

Function OnPipboyLightEvent(Bool abIsActive)
  Actor player = PlayerRef
  LightHealth = player.GetValue(PipboyLightActive)
  BatHealth = TM_Bat_Health.GetValue()
  If LightHealth == 1.0
    player.AddKeyword(TM_WatchTime_Check)
    Self.StartTimer(1.0, LightCheck)
    If player.HasKeyword(TM_Debug_Enabled)
      If BatHealth == 0.0
        Debug.Notification("Flashlight empty.")
      EndIf
    EndIf
  ElseIf LightHealth == 0.0
    player.Removekeyword(TM_WatchTime_Check)
    Self.CancelTimer(LightCheck)
    If BatHealth == 0.0
	  If player.IsEquipped(TM_FlashLight_On as Form)
	    player.EquipItem(TM_FlashLight_Off as Form, True, True)
        player.RemoveItem(TM_FlashLight_On as Form, 1, True, None)
	  EndIf
	  SendBatteryEvent(BatHealth, MCMBatHealth)
	  If player.HasKeyword(TM_Debug_Enabled)
        Debug.Notification("Flashlight empty.")
      EndIf
    EndIf
  EndIf
EndFunction

Function AnimationsOnOff()
  Actor player = PlayerRef
  player.Removekeyword(TM_Animations_Enabled)
  Utility.Wait(0.100000001)
  If AnimationsEnabled
    player.AddKeyword(TM_Animations_Enabled)
  EndIf
  If player.IsEquipped(TM_NVG_Armor as Form)
    player.UnequipItem(TM_NVG_Armor as Form, False, True)
    Utility.Wait(0.100000001)
    player.EquipItem(TM_NVG_Armor as Form, False, True)
  EndIf
EndFunction

Function WatchTimePerfomance()
  Actor player = PlayerRef
  player.Removekeyword(TM_WatchTime_Performance)
  Utility.Wait(0.100000001)
  If WatchPerformanceEnabled
    player.AddKeyword(TM_WatchTime_Performance)
  EndIf
EndFunction

Function DebugNotificationOnOff()
  Actor player = PlayerRef
  player.Removekeyword(TM_Debug_Enabled)
  Utility.Wait(0.100000001)
  If DebugNotificationEnabled
    player.AddKeyword(TM_Debug_Enabled)
  EndIf
EndFunction

Function CycleSound()
  Actor player = PlayerRef
  player.Removekeyword(TM_Cycle)
  Utility.Wait(0.100000001)
  If CycleSoundEnabled
    player.AddKeyword(TM_Cycle)
  EndIf
EndFunction

Function LowBatSound()
  Actor player = PlayerRef
  player.Removekeyword(TM_LowBat)
  Utility.Wait(0.100000001)
  If LowBatSoundEnabled
    player.AddKeyword(TM_LowBat)
  EndIf
EndFunction

Function GoggleSoundOnOff()
  Actor player = PlayerRef
  player.Removekeyword(TM_OnOff)
  Utility.Wait(0.100000001)
  If OnOffSoundEnabled
    player.AddKeyword(TM_OnOff)
  EndIf
EndFunction

Function ScopeSoundOnOff()
  Actor player = PlayerRef
  player.Removekeyword(TM_Scope_OnOff)
  Utility.Wait(0.100000001)
  If ScopeOnOffSoundEnabled
    player.AddKeyword(TM_Scope_OnOff)
  EndIf
EndFunction

Function OFCheck()
  Actor player = PlayerRef
  player.Removekeyword(TM_OF_Check)
  Utility.Wait(0.100000001)
  If OverlayEnabled
    player.AddKeyword(TM_OF_Check)
  EndIf
EndFunction

Function RechargeDevice()
  Actor player = PlayerRef
  MCMBatHealth = TM_MCM_Bat_Health.GetValue()
  BatHealth = TM_Bat_Health.GetValue()
  RechargePercent = player.GetValuePercentage(TM_Recharge_Stage)
  If player.GetItemCount(Recharge_Device as Form) > 0
    If player.HasSpell(TM_Spell_Recharge as Form)
      
    Else
      player.AddSpell(TM_Spell_Recharge, False)
      If player.IsEquipped(TM_FlashLight_On as Form)
        
      ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
        
      Else
        player.EquipItem(TM_Armor_Dummy as Form, True, True)
      EndIf
      If player.HasKeyword(TM_1st)
        If RechargePercent == 1 as Float
          If player.HasKeyword(TM_Debug_Enabled)
            Debug.Notification("Battery already full.")
          EndIf
        ElseIf RechargePercent < 0.050000001
          player.PlayIdle(NVG_Recharge)
        ElseIf RechargePercent < 0.25
          player.PlayIdle(NVG_Recharge_25)
        ElseIf RechargePercent < 0.5
          player.PlayIdle(NVG_Recharge_50)
        ElseIf RechargePercent < 0.75
          player.PlayIdle(NVG_Recharge_75)
        ElseIf RechargePercent < 1 as Float
          player.PlayIdle(NVG_Recharge_100)
        EndIf
      ElseIf player.HasKeyword(TM_3rd)
        If player.IsWeaponDrawn()
          If RechargePercent == 1 as Float
            If player.HasKeyword(TM_Debug_Enabled)
              Debug.Notification("Battery already full.")
            EndIf
          Else
            If !player.IsRunning()
              player.PlayIdle(WeapSheath)
              Utility.Wait(2.0)
            Else
              player.PlayIdle(WeapSheath)
              Utility.Wait(0.100000001)
            EndIf
            player.PlayIdle(NVG_Recharge_3rd)
            Utility.Wait(3.400000095)
            player.DrawWeapon()
          EndIf
        ElseIf RechargePercent == 1 as Float
          If player.HasKeyword(TM_Debug_Enabled)
            Debug.Notification("Battery already full.")
          EndIf
        Else
          player.PlayIdle(NVG_Recharge_3rd)
        EndIf
      EndIf
    EndIf
	bRechargedWithDevice = True
	SendBatteryEvent(MCMBatHealth, MCMBatHealth) ; Recharge to max
  Else
    Debug.MessageBox("No Recharge Device found in your inventory.")
  EndIf
EndFunction

Function ActiveVisionOnOff()
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  If ActiveVisionOnOffLocked == False
    ActiveVisionOnOffLocked = True
    If player.IsInPowerArmor()
      
    ElseIf player.GetItemCount(CheatBattery as Form) > 0
      If player.HasKeyword(TM_Cycle)
        TM_Cycle_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasSpell(TM_Spell_NV_Vision_OF as Form)
        player.AddKeyword(TM_Cycle_Image)
        player.AddKeyword(TM_Active_Vision_Enabled)
        player.RemoveSpell(TM_Spell_NV_Vision_OF)
      ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
        player.AddKeyword(TM_Cycle_Image)
        player.AddKeyword(TM_Active_Vision_Enabled)
        player.RemoveSpell(TM_Spell_T_Vision_OF)
        player.RemoveSpell(TM_Spell_T_OF_Vision_Time)
      ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
        player.AddKeyword(TM_Cycle_Image)
        player.AddKeyword(TM_Active_Vision_Enabled)
        player.RemoveSpell(TM_Spell_I_Vision_OF)
        player.RemoveSpell(TM_Spell_I_OF_Vision_Time)
      ElseIf player.HasKeyword(TM_Active_Vision_Enabled)
        If player.HasKeyword(TM_NV)
          player.AddKeyword(TM_Cycle_Image)
          player.AddSpell(TM_Spell_NV_Vision_OF, False)
          player.Removekeyword(TM_Active_Vision_Enabled)
          If player.HasKeyword(TM_Overlay_Off)
            player.UnequipItem(TM_Armor_Overlay as Form, False, True)
          EndIf
        ElseIf player.HasKeyword(TM_Thermal)
          player.AddKeyword(TM_Cycle_Image)
          player.AddSpell(TM_Spell_T_Vision_OF, False)
          player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          player.Removekeyword(TM_Active_Vision_Enabled)
          If player.HasKeyword(TM_Overlay_Off)
            player.UnequipItem(TM_Armor_Overlay as Form, False, True)
          EndIf
        ElseIf player.HasKeyword(TM_Infrared)
          player.AddKeyword(TM_Cycle_Image)
          player.AddSpell(TM_Spell_I_Vision_OF, False)
          player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          player.Removekeyword(TM_Active_Vision_Enabled)
          If player.HasKeyword(TM_Overlay_Off)
            player.UnequipItem(TM_Armor_Overlay as Form, False, True)
          EndIf
        EndIf
      EndIf
    ElseIf BatHealth > 0.0
      If player.HasKeyword(TM_Cycle)
        TM_Cycle_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasSpell(TM_Spell_NV_Vision_OF as Form)
        player.AddKeyword(TM_Cycle_Image)
        player.AddKeyword(TM_Active_Vision_Enabled)
        player.RemoveSpell(TM_Spell_NV_Vision_OF)
      ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
        player.AddKeyword(TM_Cycle_Image)
        player.AddKeyword(TM_Active_Vision_Enabled)
        player.RemoveSpell(TM_Spell_T_Vision_OF)
        player.RemoveSpell(TM_Spell_T_OF_Vision_Time)
      ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
        player.AddKeyword(TM_Cycle_Image)
        player.AddKeyword(TM_Active_Vision_Enabled)
        player.RemoveSpell(TM_Spell_I_Vision_OF)
        player.RemoveSpell(TM_Spell_I_OF_Vision_Time)
      ElseIf player.HasKeyword(TM_Active_Vision_Enabled)
        If player.HasKeyword(TM_NV)
          player.AddKeyword(TM_Cycle_Image)
          player.AddSpell(TM_Spell_NV_Vision_OF, False)
          player.Removekeyword(TM_Active_Vision_Enabled)
          If player.HasKeyword(TM_Overlay_Off)
            player.UnequipItem(TM_Armor_Overlay as Form, False, True)
          EndIf
        ElseIf player.HasKeyword(TM_Thermal)
          player.AddKeyword(TM_Cycle_Image)
          player.AddSpell(TM_Spell_T_Vision_OF, False)
          player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          player.Removekeyword(TM_Active_Vision_Enabled)
          If player.HasKeyword(TM_Overlay_Off)
            player.UnequipItem(TM_Armor_Overlay as Form, False, True)
          EndIf
        ElseIf player.HasKeyword(TM_Infrared)
          player.AddKeyword(TM_Cycle_Image)
          player.AddSpell(TM_Spell_I_Vision_OF, False)
          player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          player.Removekeyword(TM_Active_Vision_Enabled)
          If player.HasKeyword(TM_Overlay_Off)
            player.UnequipItem(TM_Armor_Overlay as Form, False, True)
          EndIf
        EndIf
      EndIf
    EndIf
    Utility.Wait(1.0)
    ActiveVisionOnOffLocked = False
  EndIf
EndFunction

Function OverlayOnOff()
  Actor player = PlayerRef
  If OverlayOnOffLocked == False
    OverlayOnOffLocked = True
    If player.HasKeyword(TM_OF_Check)
      If player.IsInPowerArmor()
        
      ElseIf player.HasKeyword(TM_Overlay_Off)
        player.Removekeyword(TM_Overlay_Off)
        If player.HasSpell(TM_Spell_T_Vision_OF as Form)
          player.EquipItem(TM_Armor_Overlay as Form, False, True)
        ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
          player.EquipItem(TM_Armor_Overlay as Form, False, True)
        ElseIf player.HasSpell(TM_Spell_NV_Vision_OF as Form)
          player.EquipItem(TM_Armor_Overlay as Form, False, True)
        EndIf
        If player.HasKeyword(TM_Debug_Enabled)
          Debug.Notification("Overlay On.")
        EndIf
      ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
        player.UnequipItem(TM_Armor_Overlay as Form, False, True)
        player.AddKeyword(TM_Overlay_Off)
      ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
        player.UnequipItem(TM_Armor_Overlay as Form, False, True)
        player.AddKeyword(TM_Overlay_Off)
      ElseIf player.HasSpell(TM_Spell_NV_Vision_OF as Form)
        player.UnequipItem(TM_Armor_Overlay as Form, False, True)
        player.AddKeyword(TM_Overlay_Off)
      Else
        player.AddKeyword(TM_Overlay_Off)
        If player.HasKeyword(TM_Debug_Enabled)
          Debug.Notification("Overlay Off.")
        EndIf
      EndIf
    EndIf
    Utility.Wait(1.0)
    OverlayOnOffLocked = False
  EndIf
EndFunction

Function CycleMode()
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  If CycleLocked == False
    CycleLocked = True
    If player.GetItemCount(NVG_Goggles_Upgrade as Form) > 0
      If player.HasKeyword(TM_Active_Vision_Enabled)
        
      ElseIf player.HasKeyword(TM_Cycle_Enabled)
        player.AddKeyword(TM_Cycle_Image)
        player.AddKeyword(TM_Cycle_Sound)
        Utility.Wait(0.100000001)
        If player.HasKeyword(TM_Cycle)
          TM_Cycle_Switch.Play(player as ObjectReference)
        EndIf
        If player.HasKeyword(TM_NV)
          player.Removekeyword(TM_NV)
          player.AddKeyword(TM_Thermal)
          player.RemoveSpell(TM_Spell_NV_Vision_OF)
          player.AddSpell(TM_Spell_T_Vision_OF, False)
          If player.GetItemCount(CheatBattery as Form) > 0
            player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          ElseIf BatHealth > 0.0
            player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          ElseIf BatHealth == 0.0
            If player.GetItemCount(Battery as Form) > 0
              player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
            EndIf
          EndIf
        ElseIf player.HasKeyword(TM_Thermal)
          player.Removekeyword(TM_Thermal)
          player.AddKeyword(TM_Infrared)
          player.RemoveSpell(TM_Spell_T_Vision_OF)
          player.RemoveSpell(TM_Spell_T_OF_Vision_Time)
          player.AddSpell(TM_Spell_I_Vision_OF, False)
          If player.GetItemCount(CheatBattery as Form) > 0
            player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          ElseIf BatHealth > 0.0
            player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          ElseIf BatHealth == 0.0
            If player.GetItemCount(Battery as Form) > 0
              player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
            EndIf
          EndIf
        ElseIf player.HasKeyword(TM_Infrared)
          player.Removekeyword(TM_Infrared)
          player.AddKeyword(TM_NV)
          player.RemoveSpell(TM_Spell_I_Vision_OF)
          player.RemoveSpell(TM_Spell_I_OF_Vision_Time)
          player.AddSpell(TM_Spell_NV_Vision_OF, False)
        EndIf
      EndIf
    Else
      Debug.MessageBox("No Thermal/Infrared upgrade found in your inventory.")
    EndIf
    Utility.Wait(1.0)
    CycleLocked = False
  EndIf
EndFunction

Function PlayAnimOn()
  Actor player = PlayerRef
  If player.HasKeyword(TM_1st)
    player.PlayIdle(NVG_On)
    If player.IsEquipped(TM_NVG_Armor as Form)
      Utility.Wait(0.300000012)
      player.RemoveAllModsFromInventoryItem(TM_NVG_Armor as Form)
      Utility.Wait(0.899999976)
      player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Down)
    EndIf
  ElseIf player.HasKeyword(TM_3rd)
    If player.HasKeyword(TM_OF_Check)
      If player.HasKeyword(TM_Overlay_Off)
        
      Else
        player.EquipItem(TM_Armor_Overlay as Form, False, True)
      EndIf
    EndIf
    If player.IsWeaponDrawn()
      player.PlayIdle(NVG_On_3rd_WD)
    Else
      player.PlayIdle(NVG_On_3rd)
    EndIf
    If player.IsEquipped(TM_NVG_Armor as Form)
      If player.GetItemCount(CheatBattery as Form) > 0
        If player.HasKeyword(TM_OnOff)
          TM_Vision_ON.Play(player as ObjectReference)
        EndIf
      ElseIf BatHealth > 0.0
        If player.HasKeyword(TM_OnOff)
          TM_Vision_ON.Play(player as ObjectReference)
        EndIf
      ElseIf BatHealth == 0.0
        If player.GetItemCount(Battery as Form) > 0
          If player.HasKeyword(TM_OnOff)
            TM_Vision_ON.Play(player as ObjectReference)
          EndIf
        EndIf
      EndIf
      Utility.Wait(0.300000012)
      player.RemoveAllModsFromInventoryItem(TM_NVG_Armor as Form)
      Utility.Wait(0.899999976)
      player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Down)
    ElseIf player.GetItemCount(CheatBattery as Form) > 0
      If player.HasKeyword(TM_OnOff)
        TM_Vision_ON.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth > 0.0
      If player.HasKeyword(TM_OnOff)
        TM_Vision_ON.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth == 0.0
      If player.GetItemCount(Battery as Form) > 0
        If player.HasKeyword(TM_OnOff)
          TM_Vision_ON.Play(player as ObjectReference)
        EndIf
      EndIf
    EndIf
  EndIf
EndFunction

Function PlayAnimOff()
  Actor player = PlayerRef
  If player.HasKeyword(TM_1st)
    player.PlayIdle(NVG_Off)
    If player.IsEquipped(TM_NVG_Armor as Form)
      Utility.Wait(0.300000012)
      player.RemoveAllModsFromInventoryItem(TM_NVG_Armor as Form)
      Utility.Wait(0.899999976)
      player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Up)
    EndIf
  ElseIf player.HasKeyword(TM_3rd)
    If player.IsWeaponDrawn()
      player.PlayIdle(NVG_Off_3rd_WD)
    Else
      player.PlayIdle(NVG_Off_3rd)
    EndIf
    If player.IsEquipped(TM_NVG_Armor as Form)
      Utility.Wait(0.300000012)
      player.RemoveAllModsFromInventoryItem(TM_NVG_Armor as Form)
      Utility.Wait(0.899999976)
      player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Up)
    EndIf
  EndIf
EndFunction

Event OnPlayerCameraState(Int aiOldState, Int aiNewState)
  Actor player = PlayerRef
  If aiNewState == FirstPersonState
    player.AddKeyword(TM_1st)
    player.Removekeyword(TM_3rd)
  ElseIf aiNewState == ThirdPerson1State
    player.AddKeyword(TM_3rd)
    player.Removekeyword(TM_1st)
  ElseIf aiNewState == ThirdPerson2State
    player.AddKeyword(TM_3rd)
    player.Removekeyword(TM_1st)
  EndIf
EndEvent

Function GogglesOnOff()
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  If GogglesOnOffLocked == False
    GogglesOnOffLocked = True
    CycleLocked = True
    If player.GetItemCount(NVG_Goggles_Upgrade as Form) == 0
      If player.HasKeyword(TM_Thermal)
        player.Removekeyword(TM_Thermal)
        Utility.Wait(0.100000001)
        player.AddKeyword(TM_NV)
      ElseIf player.HasKeyword(TM_Infrared)
        player.Removekeyword(TM_Infrared)
        Utility.Wait(0.100000001)
        player.AddKeyword(TM_NV)
      EndIf
      Utility.Wait(0.100000001)
    EndIf
    If player.GetItemCount(TM_NVG_Armor as Form) > 0
      If player.HasKeyword(TM_NVG_Equipped)
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        Self.PlayAnim()
        player.Removekeyword(TM_NVG_Equipped)
        Utility.Wait(1.0)
        player.AddSpell(TM_Spell_NV_Vision_OF, False)
        If player.HasKeyword(TM_OnOff)
          Utility.Wait(0.699999988)
          TM_Vision_ON.Play(player as ObjectReference)
        EndIf
        If FlashlightEnabled
          If player.IsEquipped(TM_FlashLight_On as Form)
            
          ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
            player.EquipItem(TM_FlashLight_On as Form, True, True)
            player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
          EndIf
        EndIf
      ElseIf player.HasSpell(TM_Spell_NV_Vision_OF as Form)
        player.RemoveSpell(TM_Spell_NV_Vision_OF)
        player.Removekeyword(TM_Cycle_Image)
        If player.IsInPowerArmor()
          Self.GoggleSoundOff()
        ElseIf player.RemoveSpell(TM_Spell_NV_Vision_OF)
          If player.HasKeyword(TM_Animations_Enabled)
            Utility.Wait(0.5)
            Self.GoggleSoundOff()
            Self.PlayAnimOff()
          Else
            Self.GoggleSoundOff()
          EndIf
        EndIf
      ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
        player.RemoveSpell(TM_Spell_T_Vision_OF)
        player.RemoveSpell(TM_Spell_T_OF_Vision_Time)
        player.Removekeyword(TM_Cycle_Image)
        If player.IsInPowerArmor()
          Self.GoggleSoundOff()
        ElseIf player.RemoveSpell(TM_Spell_T_Vision_OF)
          If player.HasKeyword(TM_Animations_Enabled)
            Utility.Wait(0.5)
            Self.GoggleSoundOff()
            Self.PlayAnimOff()
          Else
            Self.GoggleSoundOff()
          EndIf
        EndIf
      ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
        player.RemoveSpell(TM_Spell_I_Vision_OF)
        player.RemoveSpell(TM_Spell_I_OF_Vision_Time)
        player.Removekeyword(TM_Cycle_Image)
        If player.IsInPowerArmor()
          Self.GoggleSoundOff()
        ElseIf player.RemoveSpell(TM_Spell_I_Vision_OF)
          If player.HasKeyword(TM_Animations_Enabled)
            Utility.Wait(0.5)
            Self.GoggleSoundOff()
            Self.PlayAnimOff()
          Else
            Self.GoggleSoundOff()
          EndIf
        EndIf
      ElseIf player.HasKeyword(TM_Active_Vision_Enabled)
        player.Removekeyword(TM_Cycle_Image)
        If player.IsInPowerArmor()
          
        ElseIf player.HasKeyword(TM_Animations_Enabled)
          Utility.Wait(0.5)
          player.Removekeyword(TM_Active_Vision_Enabled)
          player.UnequipItem(TM_Armor_Overlay as Form, False, True)
          Self.PlayAnimOff()
        Else
          player.Removekeyword(TM_Active_Vision_Enabled)
          player.UnequipItem(TM_Armor_Overlay as Form, False, True)
        EndIf
      ElseIf player.HasKeyword(TM_NV)
        player.AddSpell(TM_Spell_NV_Vision_OF, False)
        If player.IsInPowerArmor()
          Self.GoggleSoundOn()
          If BatHealth == 0.0
            If player.GetItemCount(CheatBattery as Form) > 0
              
            ElseIf player.GetItemCount(Battery as Form) > 0
              
            Else
              player.AddKeyword(TM_Recharge)
            EndIf
          EndIf
        ElseIf player.HasSpell(TM_Spell_NV_Vision_OF as Form)
          If player.HasKeyword(TM_Animations_Enabled)
            Self.PlayAnimOn()
            Self.GoggleSoundOn()
          Else
            Self.GoggleSoundOn()
          EndIf
          If BatHealth == 0.0
            If player.GetItemCount(CheatBattery as Form) > 0
              
            ElseIf player.GetItemCount(Battery as Form) > 0
              
            Else
              player.AddKeyword(TM_Recharge)
            EndIf
          EndIf
        EndIf
      ElseIf player.HasKeyword(TM_Thermal)
        player.AddSpell(TM_Spell_T_Vision_OF, False)
        If player.IsInPowerArmor()
          Self.GoggleSoundOn()
          If player.GetItemCount(CheatBattery as Form) > 0
            player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          ElseIf BatHealth > 0.0
            player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          ElseIf BatHealth == 0.0
            If player.GetItemCount(Battery as Form) > 0
              player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
            Else
              player.AddKeyword(TM_Recharge)
            EndIf
          EndIf
        ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
          If player.HasKeyword(TM_Animations_Enabled)
            Self.PlayAnimOn()
            Self.GoggleSoundOn()
          Else
            Self.GoggleSoundOn()
          EndIf
          If player.GetItemCount(CheatBattery as Form) > 0
            player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          ElseIf BatHealth > 0.0
            Utility.Wait(1.200000048)
            player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
          ElseIf BatHealth == 0.0
            If player.GetItemCount(Battery as Form) > 0
              Utility.Wait(1.200000048)
              player.AddSpell(TM_Spell_T_OF_Vision_Time, False)
            Else
              player.AddKeyword(TM_Recharge)
            EndIf
          EndIf
        EndIf
      ElseIf player.HasKeyword(TM_Infrared)
        player.AddSpell(TM_Spell_I_Vision_OF, False)
        If player.IsInPowerArmor()
          Self.GoggleSoundOn()
          If player.GetItemCount(CheatBattery as Form) > 0
            player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          ElseIf BatHealth > 0.0
            player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          ElseIf BatHealth == 0.0
            If player.GetItemCount(Battery as Form) > 0
              player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
            Else
              player.AddKeyword(TM_Recharge)
            EndIf
          EndIf
        ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
          If player.HasKeyword(TM_Animations_Enabled)
            Self.PlayAnimOn()
            Self.GoggleSoundOn()
          Else
            Self.GoggleSoundOn()
          EndIf
          If player.GetItemCount(CheatBattery as Form) > 0
            player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          ElseIf BatHealth > 0.0
            Utility.Wait(1.200000048)
            player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
          ElseIf BatHealth == 0.0
            If player.GetItemCount(Battery as Form) > 0
              Utility.Wait(1.200000048)
              player.AddSpell(TM_Spell_I_OF_Vision_Time, False)
            Else
              player.AddKeyword(TM_Recharge)
            EndIf
          EndIf
        EndIf
      Else
        Debug.MessageBox("Something went wrong! Please open up the TM Vision mcm menu and press the Mod update/reset button once and close the mcm menu!")
      EndIf
    Else
      Debug.MessageBox("No Nightvision Goggles found in your inventory.")
    EndIf
    Utility.Wait(1.0)
    GogglesOnOffLocked = False
    CycleLocked = False
  EndIf
EndFunction

Function GoggleSoundOn()
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  If player.IsInPowerArmor()
    If player.GetItemCount(CheatBattery as Form) > 0
      If player.HasKeyword(TM_OnOff)
        TM_Vision_ON.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth > 0.0
      If player.HasKeyword(TM_OnOff)
        TM_Vision_ON.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth == 0.0
      If player.GetItemCount(Battery as Form) > 0
        If player.HasKeyword(TM_OnOff)
          TM_Vision_ON.Play(player as ObjectReference)
        EndIf
      EndIf
    EndIf
  ElseIf player.HasKeyword(TM_3rd)
    
  ElseIf player.HasKeyword(TM_Animations_Enabled)
    If player.GetItemCount(CheatBattery as Form) > 0
      If player.HasKeyword(TM_OnOff)
        Utility.Wait(0.699999988)
        TM_Vision_ON.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth > 0.0
      If player.HasKeyword(TM_OnOff)
        Utility.Wait(0.699999988)
        TM_Vision_ON.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth == 0.0
      If player.GetItemCount(Battery as Form) > 0
        If player.HasKeyword(TM_OnOff)
          Utility.Wait(0.699999988)
          TM_Vision_ON.Play(player as ObjectReference)
        EndIf
      EndIf
    EndIf
  ElseIf player.GetItemCount(CheatBattery as Form) > 0
    If player.HasKeyword(TM_OnOff)
      TM_Vision_ON.Play(player as ObjectReference)
    EndIf
  ElseIf BatHealth > 0.0
    If player.HasKeyword(TM_OnOff)
      TM_Vision_ON.Play(player as ObjectReference)
    EndIf
  ElseIf BatHealth == 0.0
    If player.GetItemCount(Battery as Form) > 0
      If player.HasKeyword(TM_OnOff)
        TM_Vision_ON.Play(player as ObjectReference)
      EndIf
    EndIf
  EndIf
EndFunction

Function GoggleSoundOff()
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  If player.IsInPowerArmor()
    If player.GetItemCount(CheatBattery as Form) > 0
      If player.HasKeyword(TM_OnOff)
        TM_Vision_OFF.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth > 0.0
      If player.HasKeyword(TM_OnOff)
        TM_Vision_OFF.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth == 0.0
      
    EndIf
  ElseIf player.HasKeyword(TM_Animations_Enabled)
    If player.GetItemCount(CheatBattery as Form) > 0
      If player.HasKeyword(TM_OnOff)
        Utility.Wait(0.300000012)
        TM_Vision_OFF.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth > 0.0
      If player.HasKeyword(TM_OnOff)
        Utility.Wait(0.300000012)
        TM_Vision_OFF.Play(player as ObjectReference)
      EndIf
    ElseIf BatHealth == 0.0
      
    EndIf
  ElseIf player.GetItemCount(CheatBattery as Form) > 0
    If player.HasKeyword(TM_OnOff)
      TM_Vision_OFF.Play(player as ObjectReference)
    EndIf
  ElseIf BatHealth > 0.0
    If player.HasKeyword(TM_OnOff)
      TM_Vision_OFF.Play(player as ObjectReference)
    EndIf
  ElseIf BatHealth == 0.0
    
  EndIf
EndFunction

Function ScopeCycleMode()
  Actor player = PlayerRef
  If ScopeCycleLocked == False
    ScopeCycleLocked = True
    If player.HasKeyword(TM_Scope_Cycle_Enabled)
      If player.HasKeyword(TM_Cycle)
        TM_Cycle_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasKeyword(TM_NV_Scope)
        player.Removekeyword(TM_NV_Scope)
        player.AddKeyword(TM_Thermal_Scope)
        player.RemoveSpell(TM_Spell_NV)
        player.AddSpell(TM_Spell_T, False)
      ElseIf player.HasKeyword(TM_Thermal_Scope)
        player.Removekeyword(TM_Thermal_Scope)
        player.AddKeyword(TM_Infrared_Scope)
        player.RemoveSpell(TM_Spell_T)
        player.AddSpell(TM_Spell_I, False)
      ElseIf player.HasKeyword(TM_Infrared_Scope)
        player.Removekeyword(TM_Infrared_Scope)
        player.AddKeyword(TM_NV_Scope)
        player.RemoveSpell(TM_Spell_I)
        player.AddSpell(TM_Spell_NV, False)
      EndIf
    EndIf
    Utility.Wait(1.0)
    ScopeCycleLocked = False
  EndIf
EndFunction

Function ScopeOnOff()
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  If ScopeOnOffLocked == False
    ScopeOnOffLocked = True
    If BatHealth == 0.0
      If player.GetItemCount(CheatBattery as Form) > 0
        
      ElseIf player.GetItemCount(Battery as Form) > 0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        player.RemoveItem(Battery as Form, 1, True, None)
        Utility.Wait(0.100000001)
      EndIf
    EndIf
    If player.HasSpell(TM_Spell_NV as Form)
      player.RemoveSpell(TM_Spell_NV)
      player.Removekeyword(TM_Scope_Cycle_Enabled)
      If player.GetItemCount(CheatBattery as Form) > 0
        
      Else
        Self.CancelTimer(ScopeCheck)
      EndIf
      If player.HasKeyword(TM_Scope_OnOff)
        TM_Scope_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasKeyword(TM_Debug_Enabled)
        Debug.Notification("Scope Off.")
      EndIf
    ElseIf player.HasSpell(TM_Spell_T as Form)
      player.RemoveSpell(TM_Spell_T)
      player.Removekeyword(TM_Scope_Cycle_Enabled)
      If player.GetItemCount(CheatBattery as Form) > 0
        
      Else
        Self.CancelTimer(ScopeCheck)
      EndIf
      If player.HasKeyword(TM_Scope_OnOff)
        TM_Scope_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasKeyword(TM_Debug_Enabled)
        Debug.Notification("Scope Off.")
      EndIf
    ElseIf player.HasSpell(TM_Spell_I as Form)
      player.RemoveSpell(TM_Spell_I)
      player.Removekeyword(TM_Scope_Cycle_Enabled)
      If player.GetItemCount(CheatBattery as Form) > 0
        
      Else
        Self.CancelTimer(ScopeCheck)
      EndIf
      If player.HasKeyword(TM_Scope_OnOff)
        TM_Scope_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasKeyword(TM_Debug_Enabled)
        Debug.Notification("Scope Off.")
      EndIf
    ElseIf player.HasKeyword(TM_NV_Scope)
      player.AddSpell(TM_Spell_NV, False)
      player.AddKeyword(TM_Scope_Cycle_Enabled)
      If player.GetItemCount(CheatBattery as Form) > 0
        
      Else
        Self.StartTimer(1.0, ScopeCheck)
      EndIf
      If player.HasKeyword(TM_Scope_OnOff)
        TM_Scope_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasKeyword(TM_Debug_Enabled)
        Debug.Notification("Scope On.")
      EndIf
    ElseIf player.HasKeyword(TM_Thermal_Scope)
      player.AddSpell(TM_Spell_T, False)
      player.AddKeyword(TM_Scope_Cycle_Enabled)
      If player.GetItemCount(CheatBattery as Form) > 0
        
      Else
        Self.StartTimer(1.0, ScopeCheck)
      EndIf
      If player.HasKeyword(TM_Scope_OnOff)
        TM_Scope_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasKeyword(TM_Debug_Enabled)
        Debug.Notification("Scope On.")
      EndIf
    ElseIf player.HasKeyword(TM_Infrared_Scope)
      player.AddSpell(TM_Spell_I, False)
      player.AddKeyword(TM_Scope_Cycle_Enabled)
      If player.GetItemCount(CheatBattery as Form) > 0
        
      Else
        Self.StartTimer(1.0, ScopeCheck)
      EndIf
      If player.HasKeyword(TM_Scope_OnOff)
        TM_Scope_Switch.Play(player as ObjectReference)
      EndIf
      If player.HasKeyword(TM_Debug_Enabled)
        Debug.Notification("Scope On.")
      EndIf
    Else
      Debug.MessageBox("Something went wrong! Please open up the TM Vision mcm menu and press the Mod update/reset button once and close the mcm menu!")
    EndIf
    Utility.Wait(1.0)
    ScopeOnOffLocked = False
  EndIf
EndFunction

Event OnTimer(Int aiTimerID)
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  ChargeSec = TM_Charge_Sec.GetValue()
  Charge50Sec = TM_Charge_50Sec.GetValue()
  ChargeMinCheck = TM_Charge_Min.GetValue()
  LightHealth = player.GetValue(PipboyLightActive)
  Float BatteryGivesRads = TVF_BatteryGivesRads.GetValue()
  If aiTimerID == ScopeCheck
    If BatHealth > 0.0
      If player.HasSpell(TM_Spell_NV_Vision_OF as Form)
        
      ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
        
      ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
        
      Else
        BatHealth -= 1.0
        player.DamageValue(TM_Recharge_Stage, 1 as Float)
        If ChargeSec == 0.0
          If Charge50Sec == 0.0
            If ChargeMinCheck == 0 as Float
              
            Else
              ChargeMinCheck -= 1.0
              Self.Charge50SecFill()
              Self.ChargeSecFill()
            EndIf
          Else
            Charge50Sec -= 1.0
            Self.ChargeSecFill()
          EndIf
        Else
          ChargeSec -= 1.0
        EndIf
      EndIf
      If BatHealth == 60.0
        If player.HasKeyword(TM_Debug_Enabled)
          Debug.Notification("WARNING! 60 seconds charge left.")
        EndIf
        If player.HasKeyword(TM_LowBat)
          TM_Bat_Warning.Play(player as ObjectReference)
        EndIf
      EndIf
    ElseIf BatHealth == 0.0
      If player.GetItemCount(Battery as Form) > 0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        player.RemoveItem(Battery as Form, 1, True, None)
        If FlashlightEnabled
          If player.IsEquipped(TM_FlashLight_On as Form)
            
          ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
            player.EquipItem(TM_FlashLight_On as Form, True, True)
            player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
          EndIf
        EndIf
      ElseIf FlashlightEnabled
        If player.IsEquipped(TM_FlashLight_On as Form)
		  If BatteryGivesRads == 0.0 || LightHealth == 0.0
            player.EquipItem(TM_FlashLight_Off as Form, True, True)
            player.RemoveItem(TM_FlashLight_On as Form, 1, True, None)
		  EndIf
        EndIf
      EndIf
    EndIf
    Self.StartTimer(1.0, ScopeCheck)
  ElseIf aiTimerID == LightCheck
    If player.GetItemCount(CheatBattery as Form) > 0
      If player.IsEquipped(TM_FlashLight_Off as Form)
        player.EquipItem(TM_FlashLight_On as Form, True, True)
        player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
        player.Removekeyword(TM_Light_Empty_State)
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
      EndIf
      If BatHealth == 0.0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
      EndIf
    ElseIf player.HasKeyword(TM_Light_Empty_State)
      If player.GetItemCount(Battery as Form) > 0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        player.EquipItem(TM_FlashLight_On as Form, True, True)
        player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
        player.Removekeyword(TM_Light_Empty_State)
      ElseIf player.GetItemCount(Battery as Form) == 0
        If BatHealth > 0.0
          player.EquipItem(TM_FlashLight_On as Form, True, True)
          player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
          player.Removekeyword(TM_Light_Empty_State)
        EndIf
      EndIf
	  if LightHealth == 1.0
        Self.StartTimer(1.0, LightCheck)
	  endif
    ElseIf BatHealth > 0.0
      If player.IsEquipped(TM_FlashLight_On as Form)
        
      ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
        player.EquipItem(TM_FlashLight_On as Form, True, True)
        player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
      EndIf
      If player.HasSpell(TM_Spell_NV_Vision_OF as Form)
        
      ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
        
      ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
        
      ElseIf player.HasSpell(TM_Spell_NV as Form)
        
      ElseIf player.HasSpell(TM_Spell_T as Form)
        
      ElseIf player.HasSpell(TM_Spell_I as Form)
        
      Else
        BatHealth -= 1.0
        player.DamageValue(TM_Recharge_Stage, 1 as Float)
        If ChargeSec == 0.0
          If Charge50Sec == 0.0
            If ChargeMinCheck == 0 as Float
              
            Else
              ChargeMinCheck -= 1.0
              Self.Charge50SecFill()
              Self.ChargeSecFill()
            EndIf
          Else
            Charge50Sec -= 1.0
            Self.ChargeSecFill()
          EndIf
        Else
          ChargeSec -= 1.0
        EndIf
      EndIf
      If BatHealth == 60.0
        If player.HasKeyword(TM_Debug_Enabled)
          Debug.Notification("WARNING! 60 seconds charge left.")
        EndIf
        If player.HasKeyword(TM_LowBat)
          TM_Bat_Warning.Play(player as ObjectReference)
        EndIf
      EndIf
	  
	  if LightHealth == 1.0
		Self.StartTimer(1.0, LightCheck)
	  endif
    ElseIf BatHealth == 0.0
      If player.GetItemCount(Battery as Form) > 0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        player.RemoveItem(Battery as Form, 1, True, None)
		If player.IsEquipped(TM_FlashLight_Off as Form)
            player.EquipItem(TM_FlashLight_On as Form, True, True)
            player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
		EndIf
		if LightHealth == 1.0
		  Self.StartTimer(1.0, LightCheck)
		endif
      Else
		If BatteryGivesRads == 0.0 || LightHealth == 0.0
          player.EquipItem(TM_FlashLight_Off as Form, True, True)
          player.RemoveItem(TM_FlashLight_On as Form, 1, True, None)
		EndIf

		if LightHealth == 1.0
		  Self.StartTimer(1.0, LightCheck)
		endif
      EndIf
    EndIf
  EndIf
  TM_Charge_Min.SetValue(ChargeMinCheck)
  TM_Charge_Sec.SetValue(ChargeSec)
  TM_Charge_50Sec.SetValue(Charge50Sec)
  TM_Bat_Health.SetValue(BatHealth)
  if !bRechargedWithDevice
	SendBatteryEvent(BatHealth, MCMBatHealth)
  else
    bRechargedWithDevice = False
  endif
EndEvent

Function ChargePercent()
  Actor player = PlayerRef
  ChargeSec = TM_Charge_Sec.GetValue()
  Charge50Sec = TM_Charge_50Sec.GetValue()
  ChargeMinCheck = TM_Charge_Min.GetValue()
  Int ChargeSecCheck = ChargeSec as Int
  Int Charge50SecCheck = Charge50Sec as Int
  Int ChargeMinCheck2 = ChargeMinCheck as Int
  If player.HasKeyword(TM_1st)
    If player.IsEquipped(TM_Watch as Form)
      player.PlayIdle(Watch_Check)
    Else
      Debug.Notification(((("0" + ChargeMinCheck2 as String) + " min and " + Charge50SecCheck as String) + "" + ChargeSecCheck as String) + " sec battery charge left")
    EndIf
  ElseIf player.HasKeyword(TM_3rd)
    If player.IsEquipped(TM_Watch as Form)
      If player.IsWeaponDrawn()
        player.PlayIdle(Watch_Check_3rd_WD)
        Debug.Notification(((("0" + ChargeMinCheck2 as String) + " min and " + Charge50SecCheck as String) + "" + ChargeSecCheck as String) + " sec battery charge left")
      Else
        player.PlayIdle(Watch_Check_3rd)
        Debug.Notification(((("0" + ChargeMinCheck2 as String) + " min and " + Charge50SecCheck as String) + "" + ChargeSecCheck as String) + " sec battery charge left")
      EndIf
    Else
      Debug.Notification(((("0" + ChargeMinCheck2 as String) + " min and " + Charge50SecCheck as String) + "" + ChargeSecCheck as String) + " sec battery charge left")
    EndIf
  EndIf
EndFunction

Function ChargeSecFill()
  ChargeSecSet = TM_Charge_Sec_Set.GetValue()
  TM_Charge_Sec.SetValue(ChargeSecSet)
  ChargeSec = TM_Charge_Sec.GetValue()
  TM_Charge_Sec.SetValue(ChargeSec)
  TM_Charge_Sec_Set.SetValue(ChargeSecSet)
EndFunction

Function Charge50SecFill()
  Charge50SecSet = TM_Charge_50Sec_Set.GetValue()
  TM_Charge_50Sec.SetValue(Charge50SecSet)
  Charge50Sec = TM_Charge_50Sec.GetValue()
  TM_Charge_50Sec.SetValue(Charge50Sec)
  TM_Charge_50Sec_Set.SetValue(Charge50SecSet)
EndFunction

Function Recharge()
  MCMBatHealth = TM_MCM_Bat_Health.GetValue()
  TM_Bat_Health.SetValue(MCMBatHealth)
  BatHealth = TM_Bat_Health.GetValue()
  TM_Bat_Health.SetValue(BatHealth)
  TM_MCM_Bat_Health.SetValue(MCMBatHealth)
EndFunction

Function FillRechargeDevice()
  Actor player = PlayerRef
  MCMBatHealth = TM_MCM_Bat_Health.GetValue()
  player.SetValue(TM_Recharge_Stage, MCMBatHealth)
  TM_MCM_Bat_Health.SetValue(MCMBatHealth)
  player.RestoreValue(TM_Recharge_Stage, MCMBatHealth)
  TM_MCM_Bat_Health.SetValue(MCMBatHealth)
EndFunction

Function ChargeMinSecFill()
  BatHealth = TM_Bat_Health.GetValue()
  MCMBatHealth = TM_MCM_Bat_Health.GetValue()
  Float Bh = TM_Bat_Health.GetValue()
  Float Bmin = Bh / 60 as Float
  Int ChargeMin = Bmin as Int
  If BatHealth == MCMBatHealth
    ChargeMin -= 1
  EndIf
  TM_Charge_Min.SetValue(ChargeMin as Float)
  ChargeMinCheck = TM_Charge_Min.GetValue()
  TM_Charge_Min.SetValue(ChargeMinCheck)
  ChargeSecSet = TM_Charge_Sec_Set.GetValue()
  TM_Charge_Sec.SetValue(ChargeSecSet)
  ChargeSec = TM_Charge_Sec.GetValue()
  TM_Charge_Sec.SetValue(ChargeSec)
  TM_Charge_Sec_Set.SetValue(ChargeSecSet)
  Charge50SecSet = TM_Charge_50Sec_Set.GetValue()
  TM_Charge_50Sec.SetValue(Charge50SecSet)
  Charge50Sec = TM_Charge_50Sec.GetValue()
  TM_Charge_50Sec.SetValue(Charge50Sec)
  TM_Charge_50Sec_Set.SetValue(Charge50SecSet)
EndFunction

Function PlayAnim()
  Actor player = PlayerRef
  Game.ForceFirstPerson()
  player.PlayIdle(NVG_Equip)
EndFunction

Function UpdateClear()
  Actor player = PlayerRef
  If player.HasKeyword(TM_Thermal)
    player.Removekeyword(TM_Thermal)
    Utility.Wait(0.100000001)
    player.AddKeyword(TM_NV)
  ElseIf player.HasKeyword(TM_Infrared)
    player.Removekeyword(TM_Infrared)
    Utility.Wait(0.100000001)
    player.AddKeyword(TM_NV)
  EndIf
  Utility.Wait(0.100000001)
EndFunction

Function ModUpdate()
  Actor player = PlayerRef
  Self.clearall()
  player.Removekeyword(TM_NV)
  player.Removekeyword(TM_Thermal)
  player.Removekeyword(TM_Infrared)
  player.Removekeyword(TM_NV_Scope)
  player.Removekeyword(TM_Thermal_Scope)
  player.Removekeyword(TM_Infrared_Scope)
  Self.CancelTimer(ScopeCheck)
  Self.CancelTimer(LightCheck)
  Utility.Wait(0.100000001)
  player.AddKeyword(TM_NV)
  player.AddKeyword(TM_NV_Scope)
  player.AddKeyword(TM_Charge_Check)
  Self.LowBatSound()
  Self.GoggleSoundOnOff()
  Self.ScopeSoundOnOff()
  Self.CycleSound()
  Self.AnimationsOnOff()
  Self.FlashLightOnOff()
  Self.DebugNotificationOnOff()
  Self.OFCheck()
  Self.Recharge()
  Self.FillRechargeDevice()
  Self.ChargeMinSecFill()
  OverlayOnOffLocked = False
  CycleLocked = False
  GogglesOnOffLocked = False
  ScopeOnOffLocked = False
  ScopeCycleLocked = False
  ActiveVisionOnOffLocked = False
  If player.IsEquipped(TM_FlashLight_On as Form)
    
  ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
    player.EquipItem(TM_FlashLight_On as Form, True, True)
    player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
  EndIf
  Debug.MessageBox("Mod update/reset complete")
EndFunction

Function clearall()
  Actor player = PlayerRef
  player.UnequipItem(TM_Armor_Overlay as Form, False, True)
  player.RemoveSpell(TM_Spell_NV)
  player.RemoveSpell(TM_Spell_T)
  player.RemoveSpell(TM_Spell_I)
  player.RemoveSpell(TM_Spell_T_Vision_OF)
  player.RemoveSpell(TM_Spell_I_Vision_OF)
  player.RemoveSpell(TM_Spell_NV_Vision_OF)
  player.RemoveSpell(TM_Spell_I_OF_Vision_Time)
  player.RemoveSpell(TM_Spell_T_OF_Vision_Time)
  player.RemoveSpell(TM_Spell_I_OF_Scope_Time)
  player.RemoveSpell(TM_Spell_T_OF_Scope_Time)
EndFunction
