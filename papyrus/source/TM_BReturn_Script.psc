ScriptName TM_BReturn_Script Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property Battery Auto Const mandatory
Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectFinish(Actor Target, Actor Caster)
  ; Empty function
EndEvent

Event OnEffectStart(Actor Target, Actor Caster)
  PlayerRef.AddItem(Battery as Form, 1, True)
  Debug.MessageBox("Batteries are automatically replaced. There is no need to use them.")
EndEvent
