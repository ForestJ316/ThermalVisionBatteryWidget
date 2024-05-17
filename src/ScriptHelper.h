#pragma once

namespace Script
{
	using VM = RE::GameVM;
	using ObjectPtr = RE::BSTSmartPointer<RE::BSScript::Object>;
	using CallbackPtr = RE::BSTSmartPointer<RE::BSScript::IStackCallbackFunctor>;
	using Args = RE::BSTThreadScrapFunction<bool(RE::BSScrapArray<RE::BSScript::Variable>)>;

	inline size_t GetObjectHandle(RE::TESForm* a_form, const char* a_class, bool a_create = false)
	{
		if (auto vm = VM::GetSingleton(); auto vmHandle = vm->GetVM())
		{
			auto objectHandle = vmHandle->GetObjectHandlePolicy().GetHandleForObject(a_form->formType.underlying(), a_form);
			ObjectPtr object = nullptr;
			bool found = vmHandle->FindBoundObject(objectHandle, a_class, true, object, true);
			if (!found && a_create) {
				vmHandle->CreateObject(a_class, object);
				vmHandle->GetObjectBindPolicy().BindObject(object, objectHandle);
			}
			return objectHandle;
		}
		return size_t();
	}

	inline bool DispatchMethodCall(size_t a_handle, RE::BSFixedString a_objName, RE::BSFixedString a_fnName, CallbackPtr a_callback)
	{
		if (auto vm = VM::GetSingleton(); auto vmHandle = vm->GetVM())
		{
			return vmHandle->DispatchMethodCall(a_handle, a_objName, a_fnName, a_callback);
		}
		return false;
	}
}
