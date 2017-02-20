Scriptname PortableWorkbench:ScrapBoxInventory extends ObjectReference

Container Property JunkScrapBox Auto

; Events ===================================

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	;Only run if it's dropped, not placed into a new container
	If (!akNewContainer)
		Game.GetPlayer().PlaceAtMe(JunkScrapBox as Form, 1, True, False, False)
		Self.Delete()
	EndIf
EndEvent
