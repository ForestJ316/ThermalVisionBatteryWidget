ScriptName TM_NVImage_Vision_OF Extends activemagiceffect

;-- Variables ---------------------------------------
Int BatteryCheck = 10
Int FirstPersonState = 0 Const
Int ThirdPerson1State = 7 Const
Int ThirdPerson2State = 8 Const
Int VATSState = 2 Const

;-- Properties --------------------------------------
ImageSpaceModifier Property TM_Vision_Nightvision Auto Const
ImageSpaceModifier Property TM_Vision_Black Auto Const
Spell Property TM_Spell_NV_Vision_OF Auto Const
VisualEffect Property TM_VisorVFX_Spark Auto Const
Keyword Property TM_Bat_Empty_State Auto Const mandatory
Keyword Property TM_LowBat Auto Const mandatory
Keyword Property TM_Overlay_Off Auto Const mandatory
Keyword Property TM_OnOff Auto Const mandatory
Keyword Property TM_Cycle_Image Auto Const mandatory
Keyword Property TM_Cycle_Enabled Auto Const mandatory
Keyword Property TM_Active_Vision_Enabled Auto Const mandatory
Keyword Property TM_Cycle_Sound Auto Const mandatory
Keyword Property TM_Animations_Enabled Auto Const mandatory
Keyword Property TM_Recharge Auto Const mandatory
Keyword Property TM_Debug_Enabled Auto Const mandatory
Keyword Property TM_OF_Check Auto Const mandatory
Keyword Property TM_3rd Auto Const mandatory
Armor Property TM_Armor_Overlay Auto Const
Armor Property TM_FlashLight_On Auto Const
Armor Property TM_FlashLight_Off Auto Const
Sound Property TM_Vision_ON Auto Const
Sound Property TM_Vision_OFF Auto Const
Sound Property TM_Bat_Warning Auto Const
Potion Property Battery Auto Const mandatory
Potion Property CheatBattery Auto Const mandatory
GlobalVariable Property TM_Bat_Health Auto
GlobalVariable Property TM_MCM_Bat_Health Auto
GlobalVariable Property TM_NV_Strength Auto
GlobalVariable Property TM_Charge_Sec Auto
GlobalVariable Property TM_Charge_Sec_Set Auto
GlobalVariable Property TM_Charge_50Sec Auto
GlobalVariable Property TM_Charge_50Sec_Set Auto
GlobalVariable Property TM_Charge_Min Auto
ActorValue Property TM_Recharge_Stage Auto
Float Property BatHealth Auto
Float Property MCMBatHealth Auto
Float Property NVStrength Auto
Float Property ChargeSec Auto
Float Property ChargeSecSet Auto
Float Property Charge50Sec Auto
Float Property Charge50SecSet Auto
Float Property ChargeMinCheck Auto
Bool Property FlashlightEnabled = True Auto

Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnInit()
  Self.RegisterForCameraState()
EndEvent

Event OnPlayerLoadGame()
  Self.RegisterForCameraState()
EndEvent

Event OnRaceSwitchComplete()
  Actor player = PlayerRef
  If player.IsInPowerArmor()
    TM_VisorVFX_Spark.Stop(player as ObjectReference)
  ElseIf player.HasSpell(TM_Spell_NV_Vision_OF as Form)
    TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
  EndIf
EndEvent

Event OnEffectStart(Actor Target, Actor Caster)
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  NVStrength = TM_NV_Strength.GetValue()
  player.AddKeyword(TM_Cycle_Enabled)
  If player.HasKeyword(TM_Active_Vision_Enabled)
    player.RemoveKeyword(TM_Active_Vision_Enabled)
  EndIf
  If player.IsInPowerArmor()
    If player.GetItemCount(CheatBattery as Form) > 0
      TM_Vision_Nightvision.Apply(NVStrength)
      If player.HasKeyword(TM_Bat_Empty_State)
        player.RemoveKeyword(TM_Bat_Empty_State)
      EndIf
    ElseIf BatHealth > 0.0
      TM_Vision_Nightvision.Apply(NVStrength)
      If player.HasKeyword(TM_Bat_Empty_State)
        player.RemoveKeyword(TM_Bat_Empty_State)
      EndIf
    ElseIf BatHealth == 0.0
      If player.GetItemCount(Battery as Form) > 0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        TM_Vision_Nightvision.Apply(NVStrength)
        player.RemoveItem(Battery as Form, 1, True, None)
        If FlashlightEnabled
          If player.IsEquipped(TM_FlashLight_On as Form)
            
          ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
            player.EquipItem(TM_FlashLight_On as Form, True, True)
            player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
          EndIf
        EndIf
        If player.HasKeyword(TM_Bat_Empty_State)
          player.RemoveKeyword(TM_Bat_Empty_State)
        EndIf
      EndIf
    EndIf
  ElseIf player.HasSpell(TM_Spell_NV_Vision_OF as Form)
    If player.HasKeyword(TM_Overlay_Off)
      If player.HasKeyword(TM_Cycle_Image)
        
      ElseIf player.HasKeyword(TM_Animations_Enabled)
        If player.HasKeyword(TM_3rd)
          
        Else
          Utility.Wait(0.800000012)
          TM_Vision_Black.Apply(1.0)
          Utility.Wait(0.400000006)
          TM_Vision_Black.remove()
        EndIf
      EndIf
    ElseIf player.HasKeyword(TM_Cycle_Image)
      If player.HasKeyword(TM_Overlay_Off)
        
      ElseIf player.HasKeyword(TM_OF_Check)
        player.EquipItem(TM_Armor_Overlay as Form, False, True)
      EndIf
    ElseIf player.HasKeyword(TM_Animations_Enabled)
      If player.HasKeyword(TM_3rd)
        
      Else
        Utility.Wait(0.800000012)
        TM_Vision_Black.Apply(1.0)
        If player.HasKeyword(TM_OF_Check)
          player.EquipItem(TM_Armor_Overlay as Form, False, True)
        EndIf
        Utility.Wait(0.400000006)
        TM_Vision_Black.remove()
      EndIf
    ElseIf player.HasKeyword(TM_OF_Check)
      player.EquipItem(TM_Armor_Overlay as Form, False, True)
    EndIf
    If player.GetItemCount(CheatBattery as Form) > 0
      TM_Vision_Nightvision.Apply(NVStrength)
      TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
      If player.HasKeyword(TM_Bat_Empty_State)
        player.RemoveKeyword(TM_Bat_Empty_State)
      EndIf
    ElseIf BatHealth > 0.0
      TM_Vision_Nightvision.Apply(NVStrength)
      TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
      If player.HasKeyword(TM_Bat_Empty_State)
        player.RemoveKeyword(TM_Bat_Empty_State)
      EndIf
    ElseIf BatHealth == 0.0
      If player.GetItemCount(Battery as Form) > 0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        TM_Vision_Nightvision.Apply(NVStrength)
        TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
        player.RemoveItem(Battery as Form, 1, True, None)
        If FlashlightEnabled
          If player.IsEquipped(TM_FlashLight_On as Form)
            
          ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
            player.EquipItem(TM_FlashLight_On as Form, True, True)
            player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
          EndIf
        EndIf
        If player.HasKeyword(TM_Bat_Empty_State)
          player.RemoveKeyword(TM_Bat_Empty_State)
        EndIf
      EndIf
    EndIf
    If player.HasKeyword(TM_Active_Vision_Enabled)
      
    ElseIf player.HasKeyword(TM_Cycle_Sound)
      player.RemoveKeyword(TM_Cycle_Sound)
    Else
      player.RemoveKeyword(TM_Cycle_Image)
    EndIf
  EndIf
  If player.GetItemCount(CheatBattery as Form) > 0
    
  Else
    Self.StartTimer(1.0, BatteryCheck)
  EndIf
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
  Actor player = PlayerRef
  player.RemoveKeyword(TM_Cycle_Enabled)
  BatHealth = TM_Bat_Health.GetValue()
  If player.HasKeyword(TM_Active_Vision_Enabled)
    
  Else
    player.UnequipItem(TM_Armor_Overlay as Form, False, True)
  EndIf
  If player.HasKeyword(TM_Animations_Enabled)
    Utility.Wait(0.5)
    TM_Vision_Nightvision.remove()
    TM_VisorVFX_Spark.Stop(player as ObjectReference)
  Else
    TM_Vision_Nightvision.remove()
    TM_VisorVFX_Spark.Stop(player as ObjectReference)
  EndIf
EndEvent

Event OnPlayerCameraState(Int aiOldState, Int aiNewState)
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  If aiNewState == FirstPersonState
    If player.IsInPowerArmor()
      TM_VisorVFX_Spark.Stop(player as ObjectReference)
    ElseIf player.HasSpell(TM_Spell_NV_Vision_OF as Form)
      If player.GetItemCount(CheatBattery as Form) > 0
        TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
      ElseIf BatHealth > 0.0
        TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
      Else
        TM_VisorVFX_Spark.Stop(player as ObjectReference)
      EndIf
    EndIf
  ElseIf aiNewState == VATSState
    TM_VisorVFX_Spark.Stop(player as ObjectReference)
  ElseIf aiNewState == ThirdPerson1State
    TM_VisorVFX_Spark.Stop(player as ObjectReference)
  ElseIf aiNewState == ThirdPerson2State
    TM_VisorVFX_Spark.Stop(player as ObjectReference)
  EndIf
EndEvent

Event OnTimer(Int aiTimerID)
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  NVStrength = TM_NV_Strength.GetValue()
  ChargeSec = TM_Charge_Sec.GetValue()
  Charge50Sec = TM_Charge_50Sec.GetValue()
  ChargeMinCheck = TM_Charge_Min.GetValue()
  If aiTimerID == BatteryCheck
    If player.HasKeyword(TM_Bat_Empty_State)
      If player.GetItemCount(Battery as Form) > 0
        Self.Recharge()
        Self.FillRechargeDevice()
        Self.ChargeMinSecFill()
        If player.HasKeyword(TM_OnOff)
          TM_Vision_ON.Play(player as ObjectReference)
        EndIf
        TM_Vision_Nightvision.Apply(NVStrength)
        TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
        player.RemoveItem(Battery as Form, 1, True, None)
        player.RemoveKeyword(TM_Bat_Empty_State)
        If FlashlightEnabled
          If player.IsEquipped(TM_FlashLight_On as Form)
            
          ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
            player.EquipItem(TM_FlashLight_On as Form, True, True)
            player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
          EndIf
        EndIf
      ElseIf player.GetItemCount(Battery as Form) == 0
        If BatHealth > 0.0
          If player.HasKeyword(TM_OnOff)
            TM_Vision_ON.Play(player as ObjectReference)
          EndIf
          If FlashlightEnabled
            If player.IsEquipped(TM_FlashLight_On as Form)
              
            ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
              player.EquipItem(TM_FlashLight_On as Form, True, True)
              player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
            EndIf
          EndIf
          TM_VisorVFX_Spark.Play(player as ObjectReference, -1.0, None)
          TM_Vision_Nightvision.Apply(NVStrength)
          player.RemoveKeyword(TM_Bat_Empty_State)
        EndIf
      EndIf
    ElseIf BatHealth > 0.0
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
      If player.HasKeyword(TM_Recharge)
        player.RemoveKeyword(TM_Recharge)
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
      Else
        If player.HasKeyword(TM_Recharge)
          player.RemoveKeyword(TM_Recharge)
        ElseIf player.HasKeyword(TM_OnOff)
          TM_Vision_OFF.Play(player as ObjectReference)
        EndIf
        If FlashlightEnabled
          If player.IsEquipped(TM_FlashLight_On as Form)
            player.EquipItem(TM_FlashLight_Off as Form, True, True)
            player.RemoveItem(TM_FlashLight_On as Form, 1, True, None)
          EndIf
        EndIf
        TM_Vision_Nightvision.remove()
        TM_VisorVFX_Spark.Stop(player as ObjectReference)
        player.RemoveKeyword(TM_Bat_Empty_State)
        player.AddKeyword(TM_Bat_Empty_State)
      EndIf
    EndIf
  EndIf
  Self.StartTimer(1.0, BatteryCheck)
  TM_Bat_Health.SetValue(BatHealth)
  TM_Charge_Min.SetValue(ChargeMinCheck)
  TM_Charge_Sec.SetValue(ChargeSec)
  TM_Charge_50Sec.SetValue(Charge50Sec)
EndEvent

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
