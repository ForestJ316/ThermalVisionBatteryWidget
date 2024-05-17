#pragma once


class EquipEvent : public RE::BSTEventSink<RE::TESEquipEvent>
{
private:
	using EventResult = RE::BSEventNotifyControl;

public:
	static EquipEvent* GetSingleton()
	{
		static EquipEvent singleton;
		return std::addressof(singleton);
	}
	EventResult ProcessEvent(const RE::TESEquipEvent& a_event, RE::BSTEventSource<RE::TESEquipEvent>* a_eventSource);

	static void Install();

	RE::TESObjectARMO* emptyFlashlight;
	RE::TESObjectARMO* fullFlashlight;
	static inline bool emptyFlashlightEquipped = false;
};
