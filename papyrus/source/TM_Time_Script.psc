ScriptName TM_Time_Script Extends ObjectReference

;-- Variables ---------------------------------------
Int FirstPersonState = 0 Const
matswap:remapdata MinLast
matswap:remapdata[] Remapping
matswap:remapdata SecFirst
matswap:remapdata SecLast
matswap TM_MatSwap
Int ThirdPerson1State = 7 Const
Int ThirdPerson2State = 8 Const
Int VATSState = 2 Const
Int WatchTimeCheck = 28

;-- Properties --------------------------------------
Group Properties
  Armor Property TM_Watch Auto Const mandatory
EndGroup

Spell Property TM_Spell_I Auto Const mandatory
Spell Property TM_Spell_T Auto Const mandatory
Spell Property TM_Spell_NV Auto Const mandatory
Spell Property TM_Spell_I_Vision_OF Auto Const mandatory
Spell Property TM_Spell_T_Vision_OF Auto Const mandatory
Spell Property TM_Spell_NV_Vision_OF Auto Const mandatory
Keyword Property TM_WatchTime_Check Auto Const mandatory
Keyword Property TM_Charge_Check Auto Const mandatory
Keyword Property TM_WatchTime_Performance Auto Const mandatory
GlobalVariable Property TM_Charge_Sec Auto
GlobalVariable Property TM_Charge_50Sec Auto
GlobalVariable Property TM_Charge_Min Auto

Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnInit()
  TM_MatSwap = Game.GetFormFromFile(272656, "Thermal_Scope_Addon.esp") as matswap
EndEvent

Event OnEquipped(Actor akActor)
  Actor player = PlayerRef
  Self.SetWatchTime()
  If player.HasKeyword(TM_WatchTime_Performance)
    Self.StartTimer(10.0, WatchTimeCheck)
  Else
    Self.StartTimer(1.0, WatchTimeCheck)
  EndIf
EndEvent

Event OnUnequipped(Actor akActor)
  Self.CancelTimer(WatchTimeCheck)
EndEvent

Event OnLoad()
  If Self.Is3DLoaded()
    TM_MatSwap = Game.GetFormFromFile(272656, "Thermal_Scope_Addon.esp") as matswap
  EndIf
EndEvent

Event OnUnload()
  Self.CancelTimer(WatchTimeCheck)
EndEvent

Event OnPlayerCameraState(Int aiOldState, Int aiNewState)
  Actor player = PlayerRef
  If aiNewState == FirstPersonState
    If player.HasKeyword(TM_WatchTime_Performance)
      Self.StartTimer(10.0, WatchTimeCheck)
    Else
      Self.StartTimer(1.0, WatchTimeCheck)
    EndIf
  ElseIf aiNewState == VATSState
    Self.CancelTimer(WatchTimeCheck)
  ElseIf aiNewState == ThirdPerson1State
    Self.CancelTimer(WatchTimeCheck)
  ElseIf aiNewState == ThirdPerson2State
    Self.CancelTimer(WatchTimeCheck)
  EndIf
EndEvent

Event OnTimer(Int aiTimerID)
  Actor player = PlayerRef
  If aiTimerID == WatchTimeCheck
    If player.HasSpell(TM_Spell_NV_Vision_OF as Form)
      Self.SetWatchTime()
    ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
      Self.SetWatchTime()
    ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
      Self.SetWatchTime()
    ElseIf player.HasSpell(TM_Spell_NV as Form)
      Self.SetWatchTime()
    ElseIf player.HasSpell(TM_Spell_T as Form)
      Self.SetWatchTime()
    ElseIf player.HasSpell(TM_Spell_I as Form)
      Self.SetWatchTime()
    ElseIf player.HasKeyword(TM_WatchTime_Check)
      Self.SetWatchTime()
    ElseIf player.HasKeyword(TM_Charge_Check)
      Self.SetWatchTime()
      player.RemoveKeyword(TM_Charge_Check)
    EndIf
  EndIf
  If player.HasKeyword(TM_WatchTime_Performance)
    Self.StartTimer(10.0, WatchTimeCheck)
  Else
    Self.StartTimer(1.0, WatchTimeCheck)
  EndIf
EndEvent

Function SetWatchTime()
  Float ChargeSec = TM_Charge_Sec.GetValue()
  Float Charge50Sec = TM_Charge_50Sec.GetValue()
  Float ChargeMinCheck = TM_Charge_Min.GetValue()
  Int ChargeSecCheck = ChargeSec as Int
  Int Charge50SecCheck = Charge50Sec as Int
  Int ChargeMinCheck2 = ChargeMinCheck as Int
  Remapping = new matswap:remapdata[0]
  MinLast = new matswap:remapdata
  MinLast.Source = "TM_Vision\\Watch\\Min\\0.bgsm"
  MinLast.Target = ("TM_Vision\\Watch\\Min\\" + ChargeMinCheck2 as String) + ".bgsm"
  Remapping.add(MinLast, 1)
  SecFirst = new matswap:remapdata
  SecFirst.Source = "TM_Vision\\Watch\\Sec2\\0.bgsm"
  SecFirst.Target = ("TM_Vision\\Watch\\Sec2\\" + Charge50SecCheck as String) + ".bgsm"
  Remapping.add(SecFirst, 1)
  SecLast = new matswap:remapdata
  SecLast.Source = "TM_Vision\\Watch\\Sec\\0.bgsm"
  SecLast.Target = ("TM_Vision\\Watch\\Sec\\" + ChargeSecCheck as String) + ".bgsm"
  Remapping.add(SecLast, 1)
  Self.Swap()
EndFunction

Function Swap()
  Actor player = PlayerRef
  TM_MatSwap.SetRemapData(Remapping)
  player.ApplyMaterialSwap(TM_MatSwap, False)
EndFunction
