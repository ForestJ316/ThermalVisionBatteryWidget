#include "Hooks.h"
#include "Events.h"

namespace
{
	void MessageHandler(F4SE::MessagingInterface::Message* a_msg)
	{
		switch (a_msg->type)
		{
			case F4SE::MessagingInterface::kGameDataReady:
				EquipEvent::GetSingleton()->Install();
				Hooks::GetForms();
				break;
			case F4SE::MessagingInterface::kPostLoad:
				break;
			default:
				break;
		}
	}

	extern "C" DLLEXPORT bool F4SEAPI F4SEPlugin_Query(const F4SE::QueryInterface * a_f4se, F4SE::PluginInfo * a_info)
	{
		a_info->infoVersion = F4SE::PluginInfo::kVersion;
		a_info->name = Version::PROJECT.data();
		a_info->version = Version::MAJOR;

		if (a_f4se->IsEditor()) {
			return false;
		}

		const auto ver = a_f4se->RuntimeVersion();
		if (ver < F4SE::RUNTIME_1_10_163) {
			return false;
		}

		return true;
	}

	extern "C" DLLEXPORT bool F4SEAPI F4SEPlugin_Load(const F4SE::LoadInterface * a_f4se)
	{
		F4SE::Init(a_f4se);
		F4SE::AllocTrampoline(1 * 1024);

		if (!F4SE::GetMessagingInterface()->RegisterListener(MessageHandler))
		{
			return false;
		}

		Hooks::Install();

		return true;
	}
}
