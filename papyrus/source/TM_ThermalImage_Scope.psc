ScriptName TM_ThermalImage_Scope Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ImageSpaceModifier Property TM_Scope_Thermal Auto Const
Spell Property TM_Spell_T Auto Const
Spell Property TM_Spell_T_OF_Scope_Time Auto Const
Potion Property CheatBattery Auto Const mandatory
GlobalVariable Property TM_Bat_Health Auto
GlobalVariable Property TM_Thermal_Strength Auto
Float Property BatHealth Auto
Float Property ThermalStrength Auto

Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectStart(Actor Target, Actor Caster)
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  ThermalStrength = TM_Thermal_Strength.GetValue()
  If player.HasSpell(TM_Spell_T as Form)
    If player.GetItemCount(CheatBattery as Form) > 0
      TM_Scope_Thermal.Apply(ThermalStrength)
      player.AddSpell(TM_Spell_T_OF_Scope_Time, False)
    ElseIf BatHealth > 0.0
      TM_Scope_Thermal.Apply(ThermalStrength)
      player.AddSpell(TM_Spell_T_OF_Scope_Time, False)
    EndIf
  EndIf
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
  Actor player = PlayerRef
  TM_Scope_Thermal.remove()
  player.RemoveSpell(TM_Spell_T_OF_Scope_Time)
EndEvent
