ScriptName TVF_BatteryWidgetRads Extends ActiveMagicEffect

TVF_BatteryWidgetScript Property WidgetScript Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	WidgetScript.FlashBatteryRads(True)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	WidgetScript.FlashBatteryRads(False)
EndEvent
