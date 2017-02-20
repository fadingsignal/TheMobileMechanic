Scriptname PortableWorkbench:PortableWorkbench_PowerArmor extends ObjectReference

Group Perks
	Perk Property PAWorkbenchOptionsPerk Auto
EndGroup

Group Sound_Effects
	Sound Property SoundBenchPlace Auto
	Sound Property SoundBenchPickUp Auto
	Sound Property UIModsComponentsMetalLight Auto		
EndGroup

Group Inventory_Items
	MiscObject Property WorkbenchInventoryItem Auto
EndGroup

;-- Internal Vars --
Int SoundWorkbenchPlaceREF
Int SoundWorkbenchPickupREF
Actor playerREF

Event OnInit()
	
	playerREF = Game.GetPlayer()
	
	;add the options perk, who knows if it will get removed but let's do it every time just in case
	If (!playerREF.HasPerk(PAWorkbenchOptionsPerk))
		playerREF.AddPerk(PAWorkbenchOptionsPerk)
	EndIf	
	
	Self.SetPosition(playerREF.X, playerREF.Y, playerREF.Z)

	MoveRelative(Self as ObjectReference, playerREF, 0, 65)
	MoveRelative(Self as ObjectReference, Self, 90, 75)

	Self.SetAngle(0, 0, (playerREF.GetAngleZ()))
	
	SoundBenchPlace.Play(Self)
	UIModsComponentsMetalLight.Play(Self)
	
EndEvent


Function PickUpEverything()

	;Return everything in the workbench to the player before disabling in case they stored stuff
	
	Self.BlockActivation(True, True) ;so they don't go spazz on the keys 
	
	UIModsComponentsMetalLight.Play(Self)
	
	;If there's anything in the Power Armor container, return it to the player
	
	If(Self.GetItemCount())
	
		;debug.Notification("PA bench has items in it")
	
		;Use a WHILE loop to wait until the container is completely empty, with a timeout in case something goes wrong
		
		;Play some ~sound effects~
		UIModsComponentsMetalLight.Play(Self)
		
		;Start the RemoveAllItems function
		Self.RemoveAllItems(PlayerRef as ObjectReference, True)
		
		int waitcounter = 0
		
		While(Self.GetItemCount() > 0 && waitcounter < 100)
			;debug.Notification("we wait")
			Utility.Wait(0.1)
			waitcounter += 1
		EndWhile 
		
		;Check the timeout, something went wrong, abort!  And return control to user.
		If(waitcounter >= 100)
			Self.BlockActivation(False, False)
			Return
		EndIf
	
		;Old hacky way using static wait times, was still causing freezing for some players
		
		;Self.RemoveAllItems(PlayerRef as ObjectReference, True)
		;Utility.Wait(0.5)
		
		;If(Self.GetItemCount()) ;if after 0.5 seconds there are still items, wait a full second -- while loops are still dangerous in Papyrus
		;	Utility.Wait(1.0)
		;	UIModsComponentsMetalLight.Play(Self)
		;EndIf
		
		;If(Self.GetItemCount()) ;if after 1.5 seconds there are still items, wait a full 2 seconds -- while loops are still dangerous in Papyrus
		;	Utility.Wait(2.0)
		;EndIf
		
	EndIf
		
	SoundBenchPickUp.Play(Self)
	
	Self.Disable()
	
	PlayerREF.AddItem(WorkbenchInventoryItem, 1, false)
	
	Utility.Wait(1.0)
	
	Self.Delete()
	
	

EndFunction 


;===========================================
; UTILITY FUNCTIONS
;===========================================

Function MoveRelative(ObjectReference objectToMove, ObjectReference targetObject, Float angleToMove, Float distanceToMove)
	;Angles are from the perspective of the object, not the player: 0 forward, 180 back, 90 left, 270 right (can't use negative numbers)

	Float offsetX = distanceToMove * Math.Sin(targetObject.GetAngleZ()+angleToMove)
	Float offsetY = distanceToMove * Math.Cos(targetObject.GetAngleZ()+angleToMove)
	
	objectToMove.MoveTo(targetObject, offsetX, offsetY, 0, True)

EndFunction