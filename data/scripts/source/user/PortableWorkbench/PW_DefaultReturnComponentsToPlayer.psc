Scriptname PortableWorkbench:PW_DefaultReturnComponentsToPlayer extends ObjectReference
{Place this on crafting furniture that should return its components items to the player when exiting.}

Actor playerREF

Event OnInit()
	playerREF = Game.GetPlayer()
EndEvent

Event OnActivate(ObjectReference akActionRef)
		
	Self.RegisterForMenuOpenCloseEvent("ExamineMenu") ; Weapons and Armor (yeah really... no other events exist for this)
	Self.RegisterForMenuOpenCloseEvent("CookingMenu") ; Cooking and Chem Station (same)
	
EndEvent

Event OnMenuOpenCloseEvent(string asMenuName, bool abOpening)

	If (asMenuName == "CookingMenu" || asMenuName == "ExamineMenu")
	
		If(!abOpening)
		
			;return components stored in the bench to the player
			Self.RemoveAllItems(PlayerRef as ObjectReference, True)
			UnregisterForMenuOpenCloseEvent("CookingMenu") 
			UnregisterForMenuOpenCloseEvent("ExamineMenu")
			
			;Parent unblocks activation before activating so the bloody OnActivate event actually fires, so let's re-block ourselves
			;This would ideally all happen in the parent script but I don't want to refactor the entire thing right now
			Self.BlockActivation(True, True)
		EndIf
	EndIf
	
EndEvent

