#include "Events.h"

void EquipEvent::Install()
{
	RE::BSTEventSource<RE::TESEquipEvent>* eventSource = RE::TESEquipEvent::GetEventSource();

	if (eventSource)
	{
		eventSource->RegisterSink(EquipEvent::GetSingleton());
	}
	EquipEvent::GetSingleton()->emptyFlashlight = RE::TESDataHandler::GetSingleton()->LookupForm<RE::TESObjectARMO>(0x3AF5C, "Thermal_Scope_Addon.esp");
	EquipEvent::GetSingleton()->fullFlashlight = RE::TESDataHandler::GetSingleton()->LookupForm<RE::TESObjectARMO>(0x3A7BC, "Thermal_Scope_Addon.esp");
}

EquipEvent::EventResult EquipEvent::ProcessEvent(const RE::TESEquipEvent& a_event, RE::BSTEventSource<RE::TESEquipEvent>*)
{
	if (!a_event.actor || a_event.actor->As<RE::Actor>() != RE::PlayerCharacter::GetSingleton())
		return EventResult::kContinue;

	if (a_event.baseObject && emptyFlashlight && fullFlashlight)
	{
		if (a_event.baseObject == emptyFlashlight->formID && a_event.equipped)
			emptyFlashlightEquipped = true;
		else if (a_event.baseObject == fullFlashlight->formID && a_event.equipped)
			emptyFlashlightEquipped = false;
	}
	return EventResult::kContinue;
}
