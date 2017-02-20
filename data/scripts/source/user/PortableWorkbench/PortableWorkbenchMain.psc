Scriptname PortableWorkbench:PortableWorkbenchMain extends ObjectReference
{Runs on an activator and places / activates invisible furniture to act as a craft-all station.}

;============
;Portable Workbench
;by fadingsignal
;============
;TO DO:
;- Make a fail safe timer (15 seconds?) when disabling activation in case something misfires
;- Consider re-writing using States which would be easier to control
;============

Group Menus
	Message Property WorkbenchMenu Auto
	Message Property WorkbenchSubMenuScrap Auto
	Message Property WorkbenchSubMenuScrapAuto Auto
	Message Property WorkbenchSubMenuScrapSelectedPrompt Auto
EndGroup

Group Inventory_Items
	MiscObject Property WorkbenchInventoryItem Auto
EndGroup

Group Sound_Effects
	Sound Property SoundBenchPlace Auto
	Sound Property SoundBenchPickUp Auto
	Sound Property UIModsComponentAdhesive Auto
	Sound Property UIModsComponentsAsbestos Auto
	Sound Property UIModsComponentsCeramic Auto
	Sound Property UIModsComponentsCircuitry Auto
	Sound Property UIModsComponentsScrews Auto
	Sound Property UIModsComponentsTeflon Auto
	Sound Property UIModsComponentsMetalLight Auto	
EndGroup

Group Containers
	Container Property ScrapContainer Auto ;temp container to add scrap and remove from 
EndGroup

Group Workbench_Furniture
	Furniture Property WorkbenchArmor Auto
	Furniture Property WorkbenchChem Auto
	Furniture Property WorkbenchFood Auto
	Furniture Property WorkbenchWeapon Auto
EndGroup

Group Scrap_Formlists
	Form Property WorkshopConsumeScavenge Auto Const
	Formlist Property ShipmentItemList Auto Const
	MiscObject Property CementBag Auto Const
EndGroup

Group Scrap_Properties
	component Property c_Acid Auto Const
	component Property c_Adhesive Auto Const
	component Property c_Aluminum Auto Const
	component Property c_AntiBallisticFiber Auto Const
	component Property c_Antiseptic Auto Const
	component Property c_Asbestos Auto Const
	component Property c_Bone Auto Const
	component Property c_Ceramic Auto Const
	component Property c_Circuitry Auto Const
	component Property c_Cloth Auto Const
	component Property c_Concrete Auto Const
	component Property c_Copper Auto Const
	component Property c_Cork Auto Const
	component Property c_Crystal Auto Const
	component Property c_Fertilizer Auto Const
	component Property c_Fiberglass Auto Const
	component Property c_FiberOptics Auto Const
	component Property c_Gears Auto Const
	component Property c_Glass Auto Const
	component Property c_Gold Auto Const
	component Property c_Lead Auto Const
	component Property c_Leather Auto Const
	component Property c_NuclearMaterial Auto Const
	component Property c_Oil Auto Const
	component Property c_Plastic Auto Const
	component Property c_Rubber Auto Const
	component Property c_Screws Auto Const
	component Property c_Silver Auto Const
	component Property c_Springs Auto Const
	component Property c_Steel Auto Const
	component Property c_Wood Auto Const
	MiscObject Property c_Acid_scrap Auto Const
	MiscObject Property c_Adhesive_scrap Auto Const
	MiscObject Property c_Aluminum_scrap Auto Const
	MiscObject Property c_AntiBallisticFiber_scrap Auto Const
	MiscObject Property c_Antiseptic_scrap Auto Const
	MiscObject Property c_Asbestos_scrap Auto Const
	MiscObject Property c_Bone_scrap Auto Const
	MiscObject Property c_Ceramic_scrap Auto Const
	MiscObject Property c_Circuitry_scrap Auto Const
	MiscObject Property c_Cloth_scrap Auto Const
	MiscObject Property c_Concrete_scrap Auto Const
	MiscObject Property c_Copper_scrap Auto Const
	MiscObject Property c_Cork_scrap Auto Const
	MiscObject Property c_Crystal_scrap Auto Const
	MiscObject Property c_Fertilizer_scrap Auto Const
	MiscObject Property c_Fiberglass_scrap Auto Const
	MiscObject Property c_FiberOptics_scrap Auto Const
	MiscObject Property c_Gears_scrap Auto Const
	MiscObject Property c_Glass_scrap Auto Const
	MiscObject Property c_Gold_scrap Auto Const
	MiscObject Property c_Lead_scrap Auto Const
	MiscObject Property c_Leather_scrap Auto Const
	MiscObject Property c_NuclearMaterial_scrap Auto Const
	MiscObject Property c_Oil_scrap Auto Const
	MiscObject Property c_Plastic_scrap Auto Const
	MiscObject Property c_Rubber_scrap Auto Const
	MiscObject Property c_Screws_scrap Auto Const
	MiscObject Property c_Silver_scrap Auto Const
	MiscObject Property c_Springs_scrap Auto Const
	MiscObject Property c_Steel_scrap Auto Const
	MiscObject Property c_Wood_scrap Auto Const
EndGroup


;--- Internal Variables  ---
ObjectReference WorkbenchArmorREF
ObjectReference WorkbenchChemREF
ObjectReference WorkbenchFoodREF
ObjectReference WorkbenchWeaponREF
ObjectReference ScrapContainerREF

Actor playerREF

Int SoundWorkbenchPlaceREF
Int SoundWorkbenchPickupREF

;--- Scrap Variables ---
int CountAntiBallisticFiber
int CountSprings
int CountFertilizer
int CountCrystal
int CountAdhesive
int CountAluminum
int CountAntiseptic
int CountOil
int CountSteel
int CountSilver
int CountScrews
int CountRubber
int CountPlastic
int CountNuclearMaterial
int CountLeather
int CountFiberglass
int CountLead
int CountGold
int CountGlass
int CountGears
int CountFiberOptics
int CountCopper
int CountConcrete
int CountCloth
int CountCeramic
int CountBone
int CountAcid
int CountWood
int CountCork
int CountCircuitry
int CountAsbestos


Event OnInit()
	;Place the workbenches down at once, this feels better than listening to remote events and such
	
	playerREF = Game.GetPlayer()
	
	Self.SetPosition(playerREF.X, playerREF.Y, playerREF.Z)
	MoveRelative(Self as ObjectReference, playerRef, 0, 50)
	Self.SetAngle(0, 0, (playerREF.GetAngleZ()))
	
	InitializeBenchesAndContainers()

	SoundWorkbenchPlaceREF = SoundBenchPlace.Play(Self)
	UIModsComponentsMetalLight.Play(Self)
	
EndEvent

Event OnActivate(ObjectReference AkActionRef)
	ShowMainMenu()
EndEvent

Function ShowMainMenu(Int iButton = 0)
	
	iButton = WorkbenchMenu.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	;Alphabetical
	
	;These furniture refs have to be unblocked in order for internal OnActivate events to fire, but they re-'self-block' when exiting in their code (look at furn forms)
	
	If iButton == 0 ;Armor
		WorkbenchArmorREF.BlockActivation(False, True)
		WorkbenchArmorREF.Activate(playerREF, False)
	ElseIf iButton == 1 ;Chem
		WorkbenchChemREF.BlockActivation(False, True)
		WorkbenchChemREF.Activate(playerREF, False)
	ElseIf iButton == 2 ;Food
		WorkbenchFoodREF.BlockActivation(False, True)
		WorkbenchFoodREF.Activate(playerREF, False)
	ElseIf iButton == 3 ;Scrap
		ShowScrapMenu()	
	ElseIf iButton == 4 ;Weapon
		WorkbenchWeaponREF.BlockActivation(False, True)
		WorkbenchWeaponREF.Activate(playerREF, False)
	ElseIf iButton == 5 ;Pick Up
		PickUpEverything()
	ElseIf iButton == 7 ;Cancel
		;empty
	EndIf
	
EndFunction 

Function ShowScrapMenu(Int iButton = 0)

	iButton = WorkbenchSubMenuScrap.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;scrap all Auto
		ScrapAllAutoWithPrompt()
	ElseIf iButton == 1 ;scrap selected
		OpenScrapContainerListenForClose()
	ElseIf iButton == 2 ;open container (debug)
		;this will confuse
	ElseIf iButton == 3 ;cancel
		;do nothing
	EndIf

EndFunction


Function InitializeBenchesAndContainers()

	;Game.GetPlayer().PlaceAtMe(JunkScrapBox as Form, 1, True, False, False)

	WorkbenchArmorREF = PlaceAtMe(WorkbenchArmor, 1, True, False, False)
	WorkbenchArmorREF.BlockActivation(True, True)
	
	WorkbenchChemREF = PlaceAtMe(WorkbenchChem, 1, True, False, False)
	WorkbenchChemREF.BlockActivation(True, True)
	
	WorkbenchFoodREF = PlaceAtMe(WorkbenchFood, 1, True, False, False)
	WorkbenchFoodREF.BlockActivation(True, True)
	
	WorkbenchWeaponREF = PlaceAtMe(WorkbenchWeapon, 1, True, False, False)
	WorkbenchWeaponREF.BlockActivation(True, True)
	
	;Scrap
	ScrapContainerREF = PlaceAtMe(ScrapContainer, 1, True, False, False)
	
	;I don't need to do this because the container is pushed underground anyway
	ScrapContainerREF.BlockActivation(True, True)
	
	;Having the container too far underground made it not work at certain geographic heights HAHAHAHAHAHAHA!
	;ScrapContainerREF.SetPosition(ScrapContainerREF.X, ScrapContainerREF.Y, 0) ;hide your bad self
	
EndFunction


Function PickUpEverything()

	WorkbenchArmorREF.Disable()
	WorkbenchArmorREF.Delete()

	WorkbenchChemREF.Disable()
	WorkbenchChemREF.Delete()
	
	WorkbenchFoodREF.Disable()
	WorkbenchFoodREF.Delete()
	
	WorkbenchWeaponREF.Disable()
	WorkbenchWeaponREF.Delete()
	
	;If there is anything in the scrap bench left over, return it
	;There is no functional case where this can happen, so it's a fail-safe
	ReturnAllItemsInContainerToPlayer()

	SoundWorkbenchPickupREF = SoundBenchPickUp.Play(Self)
	UIModsComponentsMetalLight.Play(Self)
	
	ScrapContainerREF.Disable()
	ScrapContainerREF.Delete()
	
	Self.Disable()
	Self.Delete()

	;Add the item back to inventory immediately
	PlayerREF.AddItem(WorkbenchInventoryItem, 1, false)	
	
EndFunction

;===========================================
; SCRAPPING STUFF
;===========================================

Function ScrapAllAutoWithPrompt(int iButton = 0)

	iButton = WorkbenchSubMenuScrapAuto.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;continue
		ScrapAllAuto()
	Else
		; Do nothing, go back to scrap menu
		ShowScrapMenu()
	EndIf

EndFunction

Function ScrapAllAuto()

	;Temporarily block activation so over-excited people don't try to re-run functions while they're still processing
	Self.BlockActivation(True, True)

	;are these two functions going to execute simultaneously?  LET'S FIND OUT.
	;I think people with slow computers have problems here
	
	TransferJunkFromPlayerToScrapBox()
	
	UIModsComponentsCircuitry.Play(ScrapContainerREF)
	UIModsComponentsAsbestos.Play(ScrapContainerREF)
	UIModsComponentsTeflon.Play(ScrapContainerREF)	
	UIModsComponentsMetalLight.Play(ScrapContainerREF)
	UIModsComponentsCeramic.Play(ScrapContainerREF)
	UIModsComponentsScrews.Play(ScrapContainerREF)	
		
	;Utility.Wait(2.0)
	ScrapAllJunkInContainerReturnToPlayer()
	
	Self.BlockActivation(False, False)
	Debug.MessageBox("Scrapping Complete")
EndFunction

Function TransferJunkFromPlayerToScrapBox()

	;Transfer all junk from player to container and wait
	PlayerRef.RemoveItem(WorkshopConsumeScavenge, -1, True, ScrapContainerREF as ObjectReference)
	
	int waitcounter = 0
	
	While(PlayerRef.GetItemCount(WorkshopConsumeScavenge) > 0 && waitcounter < 100)
		Utility.Wait(0.1)
		waitcounter += 1
	EndWhile
	
	;Check the timeout, something went wrong, abort!  And return control to user.
	If(waitcounter >= 100)
		debug.messagebox("Something went wrong!")
	EndIf	
	
	;Return items to the player's inventory that we don't want to scrap
	ScrapContainerREF.RemoveItem(CementBag as Form, -1, True, PlayerREF as ObjectReference) ;return cement bags ...?  On the fence about this.
	ScrapContainerREF.RemoveItem(ShipmentItemList, -1, True, PlayerREF as ObjectReference) ;return shipments to player, don't scrap those
	
	waitcounter = 0
	
	While(ScrapContainerREF.GetItemCount(CementBag) > 0 && ScrapContainerREF.GetItemCount(ShipmentItemList) > 0 && waitcounter < 100)
		Utility.Wait(0.1)
		waitcounter += 1
	EndWhile	

	;Check the timeout, something went wrong, abort!  And return control to user.
	If(waitcounter >= 100)
		debug.messagebox("Something went wrong!")
	EndIf
	
	;Utility.Wait(0.3) ;Another little pause to give ample time
	
	;Activate ourself to Open the container so we can make sure to grab what we don't want to scrap (NAH)
	;ScrapContainerREF.Activate(PlayerRef as ObjectReference, True)
EndFunction

Function OpenScrapContainerListenForClose()

	;Open the container we use for scrapping
	;When outdoors using an early game, containers let you move around while they're open, and don't fire the OnClose event -- how the fuck?
	
	ScrapContainerREF.BlockActivation(false)
	ScrapContainerREF.Activate(PlayerRef as ObjectReference, True)
	
	;Register for the event of the container to close, so we can start the process automatically
	RegisterForRemoteEvent(ScrapContainerREF, "OnClose")
	
EndFunction

Event ObjectReference.OnClose(objectReference akSender, ObjectReference akActionRef)

	If akSender == ScrapContainerREF
		
		;Unregister now that we've caught the event
		UnregisterForRemoteEvent(ScrapContainerREF, "OnClose")
		
		If(ScrapContainerREF.GetItemCount())
				;Block activation while stuff is scrapping
				Self.BlockActivation(True, True)
				ScrapJunkInContainerWithPrompt()
				Utility.Wait(0.1)
				Self.BlockActivation(False, False)
				ScrapContainerREF.BlockActivation(true, true)
				Debug.MessageBox("Scrapping Complete")
		EndIf
		
	EndIf
EndEvent

Function ScrapJunkInContainerWithPrompt(int iButton = 0)

	iButton = WorkbenchSubMenuScrapSelectedPrompt.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)
	
	If iButton == 0 ;continue
		ScrapAllJunkInContainerReturnToPlayer()
		;Utility.Wait(4.0) ;Adding lots of wait time because people have lockups
		;Because the player can put ANYTHING in there, including weapons or non-junk we need to return what's left over afterward unfortunately
		;If I could simply add a filter for keyword of scrappable junk items only, that would be ideal but I still can't figure out how to do that even in Skyrim -_-
		ReturnAllItemsInContainerToPlayer()
	Else
		ReturnAllItemsInContainerToPlayer()
	EndIf

EndFunction

Function ReturnAllItemsInContainerToPlayer()
	;Abort!  Return everything and cancel.
	ScrapContainerREF.RemoveAllItems(PlayerRef as ObjectReference, True)
	
	int waitcounter = 0
	
	While(ScrapContainerREF.GetItemCount() > 0 && waitcounter < 100)
		Utility.Wait(0.1)
		waitcounter += 1
	EndWhile 
	
	;Check the timeout, something went wrong, abort!  And return control to user.
	If(waitcounter >= 100)
		Return
	EndIf	
	
EndFunction


Function ScrapAllJunkInContainerReturnToPlayer()

	;scrap all the stuff and drop it back into the player's inventory
	
	UIModsComponentAdhesive.Play(ScrapContainerREF)

		CountAcid = ScrapContainerREF.GetComponentCount(c_Acid as Form)
		ScrapContainerREF.RemoveComponents(c_Acid, CountAcid, False)
		PlayerREF.AddItem(c_Acid_scrap as Form, CountAcid, False)
		CountAdhesive = ScrapContainerREF.GetComponentCount(c_Adhesive as Form)
		ScrapContainerREF.RemoveComponents(c_Adhesive, CountAdhesive, False)
		PlayerREF.AddItem(c_Adhesive_scrap as Form, CountAdhesive, False)
		CountAluminum = ScrapContainerREF.GetComponentCount(c_Aluminum as Form)
		ScrapContainerREF.RemoveComponents(c_Aluminum, CountAluminum, False)
		PlayerREF.AddItem(c_Aluminum_scrap as Form, CountAluminum, False)
		CountAntiBallisticFiber = ScrapContainerREF.GetComponentCount(c_AntiBallisticFiber as Form)
		ScrapContainerREF.RemoveComponents(c_AntiBallisticFiber, CountAntiBallisticFiber, False)
		PlayerREF.AddItem(c_AntiBallisticFiber_scrap as Form, CountAntiBallisticFiber, False)
		CountAntiseptic = ScrapContainerREF.GetComponentCount(c_Antiseptic as Form)
		ScrapContainerREF.RemoveComponents(c_Antiseptic, CountAntiseptic, False)
		PlayerREF.AddItem(c_Antiseptic_scrap as Form, CountAntiseptic, False)
		CountAsbestos = ScrapContainerREF.GetComponentCount(c_Asbestos as Form)
		ScrapContainerREF.RemoveComponents(c_Asbestos, CountAsbestos, False)
		PlayerREF.AddItem(c_Asbestos_scrap as Form, CountAsbestos, False)
		CountBone = ScrapContainerREF.GetComponentCount(c_Bone as Form)
		
	UIModsComponentsAsbestos.Play(ScrapContainerREF)
		
		ScrapContainerREF.RemoveComponents(c_Bone, CountBone, False)
		PlayerREF.AddItem(c_Bone_scrap as Form, CountBone, False)
		CountCeramic = ScrapContainerREF.GetComponentCount(c_Ceramic as Form)
		ScrapContainerREF.RemoveComponents(c_Ceramic, CountCeramic, False)
		PlayerREF.AddItem(c_Ceramic_scrap as Form, CountCeramic, False)
		CountCircuitry = ScrapContainerREF.GetComponentCount(c_Circuitry as Form)
		ScrapContainerREF.RemoveComponents(c_Circuitry, CountCircuitry, False)
		PlayerREF.AddItem(c_Circuitry_scrap as Form, CountCircuitry, False)
		CountCloth = ScrapContainerREF.GetComponentCount(c_Cloth as Form)
		ScrapContainerREF.RemoveComponents(c_Cloth, CountCloth, False)
		PlayerREF.AddItem(c_Cloth_scrap as Form, CountCloth, False)
		CountConcrete = ScrapContainerREF.GetComponentCount(c_Concrete as Form)
		ScrapContainerREF.RemoveComponents(c_Concrete, CountConcrete, False)
		PlayerREF.AddItem(c_Concrete_scrap as Form, CountConcrete, False)
		CountCopper = ScrapContainerREF.GetComponentCount(c_Copper as Form)
		ScrapContainerREF.RemoveComponents(c_Copper, CountCopper, False)
		PlayerREF.AddItem(c_Copper_scrap as Form, CountCopper, False)
		CountCork = ScrapContainerREF.GetComponentCount(c_Cork as Form)
		ScrapContainerREF.RemoveComponents(c_Cork, CountCork, False)
		PlayerREF.AddItem(c_Cork_scrap as Form, CountCork, False)
		CountCrystal = ScrapContainerREF.GetComponentCount(c_Crystal as Form)
		
	UIModsComponentsCeramic.Play(ScrapContainerREF)
		
		ScrapContainerREF.RemoveComponents(c_Crystal, CountCrystal, False)
		PlayerREF.AddItem(c_Crystal_scrap as Form, CountCrystal, False)
		CountFertilizer = ScrapContainerREF.GetComponentCount(c_Fertilizer as Form)
		ScrapContainerREF.RemoveComponents(c_Fertilizer, CountFertilizer, False)
		PlayerREF.AddItem(c_Fertilizer_scrap as Form, CountFertilizer, False)
		CountFiberglass = ScrapContainerREF.GetComponentCount(c_Fiberglass as Form)
		ScrapContainerREF.RemoveComponents(c_Fiberglass, CountFiberglass, False)
		PlayerREF.AddItem(c_Fiberglass_scrap as Form, CountFiberglass, False)
		CountFiberOptics = ScrapContainerREF.GetComponentCount(c_FiberOptics as Form)
		ScrapContainerREF.RemoveComponents(c_FiberOptics, CountFiberOptics, False)
		PlayerREF.AddItem(c_FiberOptics_scrap as Form, CountFiberOptics, False)
		CountGears = ScrapContainerREF.GetComponentCount(c_Gears as Form)
		ScrapContainerREF.RemoveComponents(c_Gears, CountGears, False)
		PlayerREF.AddItem(c_Gears_scrap as Form, CountGears, False)
		CountGlass = ScrapContainerREF.GetComponentCount(c_Glass as Form)
		ScrapContainerREF.RemoveComponents(c_Glass, CountGlass, False)
		PlayerREF.AddItem(c_Glass_scrap as Form, CountGlass, False)
		CountGold = ScrapContainerREF.GetComponentCount(c_Gold as Form)
		ScrapContainerREF.RemoveComponents(c_Gold, CountGold, False)
		PlayerREF.AddItem(c_Gold_scrap as Form, CountGold, False)
		CountLead = ScrapContainerREF.GetComponentCount(c_Lead as Form)
		
	UIModsComponentsCircuitry.Play(ScrapContainerREF)
		
		ScrapContainerREF.RemoveComponents(c_Lead, CountLead, False)
		PlayerREF.AddItem(c_Lead_scrap as Form, CountLead, False)
		CountLeather = ScrapContainerREF.GetComponentCount(c_Leather as Form)
		ScrapContainerREF.RemoveComponents(c_Leather, CountLeather, False)
		PlayerREF.AddItem(c_Leather_scrap as Form, CountLeather, False)
		CountNuclearMaterial = ScrapContainerREF.GetComponentCount(c_NuclearMaterial as Form)
		ScrapContainerREF.RemoveComponents(c_NuclearMaterial, CountNuclearMaterial, False)
		PlayerREF.AddItem(c_NuclearMaterial_scrap as Form, CountNuclearMaterial, False)
		CountOil = ScrapContainerREF.GetComponentCount(c_Oil as Form)
		ScrapContainerREF.RemoveComponents(c_Oil, CountOil, False)
		PlayerREF.AddItem(c_Oil_scrap as Form, CountOil, False)
		CountPlastic = ScrapContainerREF.GetComponentCount(c_Plastic as Form)
		ScrapContainerREF.RemoveComponents(c_Plastic, CountPlastic, False)
		PlayerREF.AddItem(c_Plastic_scrap as Form, CountPlastic, False)
		CountRubber = ScrapContainerREF.GetComponentCount(c_Rubber as Form)

	UIModsComponentsScrews.Play(ScrapContainerREF)
		
		ScrapContainerREF.RemoveComponents(c_Rubber, CountRubber, False)
		PlayerREF.AddItem(c_Rubber_scrap as Form, CountRubber, False)
		CountScrews = ScrapContainerREF.GetComponentCount(c_Screws as Form)
		ScrapContainerREF.RemoveComponents(c_Screws, CountScrews, False)
		PlayerREF.AddItem(c_Screws_scrap as Form, CountScrews, False)
		CountSilver = ScrapContainerREF.GetComponentCount(c_Silver as Form)
		ScrapContainerREF.RemoveComponents(c_Silver, CountSilver, False)
		PlayerREF.AddItem(c_Silver_scrap as Form, CountSilver, False)
		CountSprings = ScrapContainerREF.GetComponentCount(c_Springs as Form)
		ScrapContainerREF.RemoveComponents(c_Springs, CountSprings, False)
		PlayerREF.AddItem(c_Springs_scrap as Form, CountSprings, False)
		CountSteel = ScrapContainerREF.GetComponentCount(c_Steel as Form)
		ScrapContainerREF.RemoveComponents(c_Steel, CountSteel, False)
		PlayerREF.AddItem(c_Steel_scrap as Form, CountSteel, False)
		CountWood = ScrapContainerREF.GetComponentCount(c_Wood as Form)
		ScrapContainerREF.RemoveComponents(c_Wood, CountWood, False)
		PlayerREF.AddItem(c_Wood_scrap as Form, CountWood, False)

		UIModsComponentsTeflon.Play(ScrapContainerREF)		
		UIModsComponentsMetalLight.Play(ScrapContainerREF)
		
		
		int waitcounter = 0
		
		While(ScrapContainerREF.GetComponentCount() > 0 && waitcounter < 100)
			Utility.Wait(0.1)
			waitcounter += 1
		EndWhile 
		
		;Check the timeout, something went wrong, abort!  And return control to user.
		If(waitcounter >= 100)
			debug.messagebox("something went wrong")
		EndIf
		
		;Utility.Wait(2.0) ;give it some time to digest
		
		;Return stuff that can't be scrapped back into player inventory
		;ScrapContainerREF.RemoveAllItems(PlayerRef as ObjectReference, True)

		;Utility.Wait(1.0) ;too short of delays can make the game freeze, how can I lock threads to stop threaded processing?
		
		;Move all of the scrapped components from the temp box into the player inventory (NO LONGER NEEDED we dump straight into player now)
		;PlayerREF.RemoveAllItems(PlayerRef as ObjectReference, True)

		;In theory there is no need for the temp box, we can just to player.additem instead of PlayerREF

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