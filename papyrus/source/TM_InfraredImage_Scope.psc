ScriptName TM_InfraredImage_Scope Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ImageSpaceModifier Property TM_Scope_Infrared Auto Const
Spell Property TM_Spell_I Auto Const
Spell Property TM_Spell_I_OF_Scope_Time Auto Const
GlobalVariable Property TM_Bat_Health Auto
GlobalVariable Property TM_Infrared_Strength Auto
Potion Property CheatBattery Auto Const mandatory
Float Property BatHealth Auto
Float Property InfraredStrength Auto
Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectStart(Actor Target, Actor Caster)
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  InfraredStrength = TM_Infrared_Strength.GetValue()
  If player.HasSpell(TM_Spell_I as Form)
    If player.GetItemCount(CheatBattery as Form) > 0
      TM_Scope_Infrared.Apply(InfraredStrength)
      player.AddSpell(TM_Spell_I_OF_Scope_Time, False)
    ElseIf BatHealth > 0.0
      TM_Scope_Infrared.Apply(InfraredStrength)
      player.AddSpell(TM_Spell_I_OF_Scope_Time, False)
    EndIf
  EndIf
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
  Actor player = PlayerRef
  TM_Scope_Infrared.remove()
  player.RemoveSpell(TM_Spell_I_OF_Scope_Time)
EndEvent
