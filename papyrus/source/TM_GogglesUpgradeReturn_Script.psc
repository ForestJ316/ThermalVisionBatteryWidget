ScriptName TM_GogglesUpgradeReturn_Script Extends activemagiceffect

;-- Variables ---------------------------------------

;-- Properties --------------------------------------
Potion Property NVG_Goggles_Upgrade Auto Const mandatory
Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEffectFinish(Actor Target, Actor Caster)
  ; Empty function
EndEvent

Event OnEffectStart(Actor Target, Actor Caster)
  PlayerRef.AddItem(NVG_Goggles_Upgrade as Form, 1, True)
  Debug.MessageBox("There is no need to use this item.")
EndEvent
