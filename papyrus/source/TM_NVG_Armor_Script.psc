ScriptName TM_NVG_Armor_Script Extends ObjectReference

;-- Variables ---------------------------------------
Int NVGTimeCheck = 78

;-- Properties --------------------------------------
Group Properties
  Armor Property TM_NVG_Armor Auto Const mandatory
EndGroup

Spell Property TM_Spell_I_Vision_OF Auto Const mandatory
Spell Property TM_Spell_T_Vision_OF Auto Const mandatory
Spell Property TM_Spell_NV_Vision_OF Auto Const mandatory
Keyword Property TM_NVG_D Auto Const mandatory
Keyword Property TM_NVG_U Auto Const mandatory
Keyword Property TM_Animations_Enabled Auto Const mandatory
objectmod Property TM_NVG_Up Auto Const mandatory
objectmod Property TM_NVG_Down Auto Const mandatory

Actor Property PlayerRef Auto

;-- Functions ---------------------------------------

Event OnEquipped(Actor akActor)
  Self.StartTimer(0.5, NVGTimeCheck)
EndEvent

Event OnUnequipped(Actor akActor)
  Self.CancelTimer(NVGTimeCheck)
EndEvent

Event OnUnload()
  Self.CancelTimer(NVGTimeCheck)
EndEvent

Event OnTimer(Int aiTimerID)
  Actor player = PlayerRef
  If aiTimerID == NVGTimeCheck
    If player.HasSpell(TM_Spell_NV_Vision_OF as Form)
      If player.HasKeyword(TM_NVG_D)
        
      Else
        player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Down)
        player.AddKeyword(TM_NVG_D)
        player.RemoveKeyword(TM_NVG_U)
      EndIf
    ElseIf player.HasSpell(TM_Spell_T_Vision_OF as Form)
      If player.HasKeyword(TM_NVG_D)
        
      Else
        player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Down)
        player.AddKeyword(TM_NVG_D)
        player.RemoveKeyword(TM_NVG_U)
      EndIf
    ElseIf player.HasSpell(TM_Spell_I_Vision_OF as Form)
      If player.HasKeyword(TM_NVG_D)
        
      Else
        player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Down)
        player.AddKeyword(TM_NVG_D)
        player.RemoveKeyword(TM_NVG_U)
      EndIf
    ElseIf player.HasKeyword(TM_NVG_U)
      
    Else
      player.AttachModToInventoryItem(TM_NVG_Armor as Form, TM_NVG_Up)
      player.AddKeyword(TM_NVG_U)
      player.RemoveKeyword(TM_NVG_D)
    EndIf
  EndIf
  If player.HasKeyword(TM_Animations_Enabled)
    
  Else
    Self.StartTimer(0.5, NVGTimeCheck)
  EndIf
EndEvent
