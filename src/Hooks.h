#pragma once

#include "ScriptHelper.h"
#include "Events.h"

// Offsets
typedef __int64(_fastcall* tTogglePipboyLight)(RE::PlayerCharacter* a_player);
static REL::Relocation<tTogglePipboyLight> TogglePipboyLight{ REL::ID(520007) };

// Hooks
class Hooks
{
public:
	static void Install()
	{
		_PlayerTogglePipboyLight = F4SE::GetTrampoline().write_call<5>(REL::ID(1546751).address() + 0x2717, PlayerTogglePipboyLight);
	}
	
	static void GetForms()
	{
		auto dataHandler = RE::TESDataHandler::GetSingleton();
		BatteryQuestForm = dataHandler->LookupForm<RE::TESQuest>(0x800, "TVF_BatteryWidget.esp");
		BatteryCurrentPercent = dataHandler->LookupForm<RE::TESGlobal>(0x801, "TVF_BatteryWidget.esp");
	}

private:
	static inline RE::TESQuest* BatteryQuestForm;
	static inline RE::TESGlobal* BatteryCurrentPercent;
	
	// Pipboy light hook
	static void PlayerTogglePipboyLight(RE::PlayerCharacter* a_player)
	{
		if (EquipEvent::emptyFlashlightEquipped && !RE::PlayerCharacter::GetSingleton()->IsPipboyLightOn() && BatteryCurrentPercent && BatteryCurrentPercent->value == 0.0f)
		{
			FlashEmptyBattery();
			return;
		}
		_PlayerTogglePipboyLight(a_player);
	}
	static inline REL::Relocation<decltype(PlayerTogglePipboyLight)> _PlayerTogglePipboyLight;

	static void FlashEmptyBattery()
	{
		if (!BatteryQuestForm) return;
		auto Handle = Script::GetObjectHandle(BatteryQuestForm, "TVF_BatteryWidgetScript", true);
		if (Handle)
			Script::DispatchMethodCall(Handle, "TVF_BatteryWidgetScript"sv, "FlashEmptyBattery"sv, nullptr);
	}

};
