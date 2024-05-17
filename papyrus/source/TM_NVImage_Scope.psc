ScriptName TM_NVImage_Scope Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
ImageSpaceModifier Property TM_Scope_Nightvision Auto Const
Spell Property TM_Spell_NV Auto Const
GlobalVariable Property TM_Bat_Health Auto
GlobalVariable Property TM_NV_Strength Auto
Potion Property CheatBattery Auto Const mandatory
Float Property BatHealth Auto
Float Property NVStrength Auto

Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectStart(Actor Target, Actor Caster)
  Actor player = PlayerRef
  BatHealth = TM_Bat_Health.GetValue()
  NVStrength = TM_NV_Strength.GetValue()
  If player.HasSpell(TM_Spell_NV as Form)
    If player.GetItemCount(CheatBattery as Form) > 0
      TM_Scope_Nightvision.Apply(NVStrength)
    ElseIf BatHealth > 0.0
      TM_Scope_Nightvision.Apply(NVStrength)
    EndIf
  EndIf
EndEvent

Event OnEffectFinish(Actor Target, Actor Caster)
  TM_Scope_Nightvision.remove()
EndEvent
