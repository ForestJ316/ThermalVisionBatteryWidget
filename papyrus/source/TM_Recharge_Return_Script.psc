ScriptName TM_Recharge_Return_Script Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property Recharge_Device Auto Const mandatory
Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectFinish(Actor Target, Actor Caster)
  ; Empty function
EndEvent

Event OnEffectStart(Actor Target, Actor Caster)
  PlayerRef.AddItem(Recharge_Device as Form, 1, True)
  Debug.MessageBox("Please use the mcm hotkey.")
EndEvent
