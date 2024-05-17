ScriptName TM_Recharge_Script Extends activemagiceffect

;-- Variables ---------------------------------------
Int ArmorCheck = 10

;-- Properties --------------------------------------
Spell Property TM_Spell_Recharge Auto Const
Keyword Property TM_Charge_Check Auto Const mandatory
Armor Property TM_Armor_Dummy Auto Const
Armor Property TM_FlashLight_On Auto Const
Armor Property TM_FlashLight_Off Auto Const
GlobalVariable Property TM_Bat_Health Auto
GlobalVariable Property TM_MCM_Bat_Health Auto
GlobalVariable Property TM_Charge_Sec Auto
GlobalVariable Property TM_Charge_Sec_Set Auto
GlobalVariable Property TM_Charge_50Sec Auto
GlobalVariable Property TM_Charge_50Sec_Set Auto
GlobalVariable Property TM_Charge_Min Auto
ActorValue Property TM_Recharge_Stage Auto
Float Property BatHealth Auto
Float Property MCMBatHealth Auto
Float Property ChargeSec Auto
Float Property ChargeSecSet Auto
Float Property Charge50Sec Auto
Float Property Charge50SecSet Auto
Bool Property FlashlightEnabled = True Auto

Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectFinish(Actor Target, Actor Caster)
  ; Empty function
EndEvent

Event OnEffectStart(Actor Target, Actor Caster)
  Actor player = PlayerRef
  Self.StartTimer(4.099999905, ArmorCheck)
  Utility.Wait(1.100000024)
  Self.Recharge()
  Self.FillRechargeDevice()
  Self.ChargeMinSecFill()
  player.AddKeyword(TM_Charge_Check)
  If FlashlightEnabled
    If player.IsEquipped(TM_FlashLight_On as Form)
      
    ElseIf player.IsEquipped(TM_FlashLight_Off as Form)
      player.EquipItem(TM_FlashLight_On as Form, True, True)
      player.RemoveItem(TM_FlashLight_Off as Form, 1, True, None)
    EndIf
  EndIf
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

Event OnTimer(Int aiTimerID)
  Actor player = PlayerRef
  If aiTimerID == ArmorCheck
    player.RemoveSpell(TM_Spell_Recharge)
    player.RemoveItem(TM_Armor_Dummy as Form, 1, True, None)
  EndIf
EndEvent
