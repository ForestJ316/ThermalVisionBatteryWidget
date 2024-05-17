ScriptName TM_CBReturn_Script Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property CheatBattery Auto Const mandatory
Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectFinish(Actor Target, Actor Caster)
  ; Empty function
EndEvent

Event OnEffectStart(Actor Target, Actor Caster)
  PlayerRef.AddItem(CheatBattery as Form, 1, True)
  Debug.MessageBox("There is no need to use the cheat battery.")
EndEvent
