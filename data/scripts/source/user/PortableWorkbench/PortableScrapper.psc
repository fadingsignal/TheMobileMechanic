Scriptname PortableWorkbench:PortableScrapper extends ObjectReference

Group Basic_Properties
	MiscObject Property PortableScrapperInventoryItem Auto
	Sound Property SoundPlace Auto
	Sound Property SoundPickup Auto
	Container Property ScrapContainer Auto ;temp container to add scrap and remove from 
	Message Property ScrapperMenu Auto
EndGroup

Group ScrapExtra_Properties
	Form Property WorkshopConsumeScavenge Auto Const
	Form Property ShipmentItemList Auto Const
	MiscObject Property CementBag Auto Const
EndGroup

Group SoundEffects_Properties
	Sound Property UIModsComponentAdhesive Auto
	Sound Property UIModsComponentsAsbestos Auto
	Sound Property UIModsComponentsCeramic Auto
	Sound Property UIModsComponentsCircuitry Auto
	Sound Property UIModsComponentsScrews Auto
	Sound Property UIModsComponentsTeflon Auto
	Sound Property UIModsComponentsMetalLight Auto
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

Int SoundPlaceREF
Int SoundPickupREF
Actor playerREF
ObjectReference TempBox

;-- Variables ---------------------------------------
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

	Self.BlockActivation(True, False)

	playerREF = Game.GetPlayer()

	Self.SetPosition(playerREF.X, playerREF.Y, playerREF.Z)
	MoveRelative(Self as ObjectReference, playerRef, 0, 50)
	Self.SetAngle(0, 0, (playerREF.GetAngleZ()))

	SoundPlaceREF = SoundPlace.Play(Self)
	
	;Place temporary container with a crazy z-index under the ground
	TempBox = PlaceAtMe(ScrapContainer)
	TempBox.SetPosition(playerREF.X, playerREF.Y, playerREF.Z)
	MoveRelative(TempBox as ObjectReference, playerRef, 0, 50)
	TempBox.SetPosition(TempBox.X, TempBox.Y, -5000) ;this was being stubborn so I'm doing it again here on its own GO AWAY
	Self.SetAngle(0, 0, (playerREF.GetAngleZ()))

EndEvent

Event OnActivate(ObjectReference AkActionRef)
	ShowMainMenu()
EndEvent

Function ShowMainMenu(Int iButton = 0)

	iButton = ScrapperMenu.Show(0, 0, 0, 0, 0, 0, 0, 0, 0)

	If iButton == 0 ;Store All Junk
		RemoveJunkFromPlayerInventory()
	ElseIf iButton == 1 ;Scrap Stored Junk
		ScrapAllJunkInContainer()
	ElseIf iButton == 2 ;Open Container
		Self.Activate(playerREF, True)
	ElseIf iButton == 3 ;Pick Up
		PickUpEverything()
	ElseIf iButton == 4 ;Do Nothing
		;empty
	EndIf

EndFunction

Function RemoveJunkFromPlayerInventory()
	PlayerRef.RemoveItem(WorkshopConsumeScavenge, -1, True, Self as ObjectReference) ;move player junk to container (self)
	Utility.Wait(0.2)
	Self.RemoveItem(CementBag as Form, -1, True, PlayerREF as ObjectReference) ;return cement bags ...?
	Self.RemoveItem(ShipmentItemList, -1, True, PlayerREF as ObjectReference) ;return shipments to player, don't scrap those
	
	;Activate ourself to Open the container so we can make sure to grab what we don't want to scrap
	Self.Activate(PlayerRef as ObjectReference, True)
EndFunction

Function ScrapAllJunkInContainer()

	UIModsComponentAdhesive.Play(Self)

		CountAcid = Self.GetComponentCount(c_Acid as Form)
		Self.RemoveComponents(c_Acid, CountAcid, False)
		TempBox.AddItem(c_Acid_scrap as Form, CountAcid, False)
		CountAdhesive = Self.GetComponentCount(c_Adhesive as Form)
		Self.RemoveComponents(c_Adhesive, CountAdhesive, False)
		TempBox.AddItem(c_Adhesive_scrap as Form, CountAdhesive, False)
		CountAluminum = Self.GetComponentCount(c_Aluminum as Form)
		Self.RemoveComponents(c_Aluminum, CountAluminum, False)
		TempBox.AddItem(c_Aluminum_scrap as Form, CountAluminum, False)
		CountAntiBallisticFiber = Self.GetComponentCount(c_AntiBallisticFiber as Form)
		Self.RemoveComponents(c_AntiBallisticFiber, CountAntiBallisticFiber, False)
		TempBox.AddItem(c_AntiBallisticFiber_scrap as Form, CountAntiBallisticFiber, False)
		CountAntiseptic = Self.GetComponentCount(c_Antiseptic as Form)
		Self.RemoveComponents(c_Antiseptic, CountAntiseptic, False)
		TempBox.AddItem(c_Antiseptic_scrap as Form, CountAntiseptic, False)
		CountAsbestos = Self.GetComponentCount(c_Asbestos as Form)
		Self.RemoveComponents(c_Asbestos, CountAsbestos, False)
		TempBox.AddItem(c_Asbestos_scrap as Form, CountAsbestos, False)
		CountBone = Self.GetComponentCount(c_Bone as Form)
		
	UIModsComponentsAsbestos.Play(Self)
		
		Self.RemoveComponents(c_Bone, CountBone, False)
		TempBox.AddItem(c_Bone_scrap as Form, CountBone, False)
		CountCeramic = Self.GetComponentCount(c_Ceramic as Form)
		Self.RemoveComponents(c_Ceramic, CountCeramic, False)
		TempBox.AddItem(c_Ceramic_scrap as Form, CountCeramic, False)
		CountCircuitry = Self.GetComponentCount(c_Circuitry as Form)
		Self.RemoveComponents(c_Circuitry, CountCircuitry, False)
		TempBox.AddItem(c_Circuitry_scrap as Form, CountCircuitry, False)
		CountCloth = Self.GetComponentCount(c_Cloth as Form)
		Self.RemoveComponents(c_Cloth, CountCloth, False)
		TempBox.AddItem(c_Cloth_scrap as Form, CountCloth, False)
		CountConcrete = Self.GetComponentCount(c_Concrete as Form)
		Self.RemoveComponents(c_Concrete, CountConcrete, False)
		TempBox.AddItem(c_Concrete_scrap as Form, CountConcrete, False)
		CountCopper = Self.GetComponentCount(c_Copper as Form)
		Self.RemoveComponents(c_Copper, CountCopper, False)
		TempBox.AddItem(c_Copper_scrap as Form, CountCopper, False)
		CountCork = Self.GetComponentCount(c_Cork as Form)
		Self.RemoveComponents(c_Cork, CountCork, False)
		TempBox.AddItem(c_Cork_scrap as Form, CountCork, False)
		CountCrystal = Self.GetComponentCount(c_Crystal as Form)
		
	UIModsComponentsCeramic.Play(Self)
		
		Self.RemoveComponents(c_Crystal, CountCrystal, False)
		TempBox.AddItem(c_Crystal_scrap as Form, CountCrystal, False)
		CountFertilizer = Self.GetComponentCount(c_Fertilizer as Form)
		Self.RemoveComponents(c_Fertilizer, CountFertilizer, False)
		TempBox.AddItem(c_Fertilizer_scrap as Form, CountFertilizer, False)
		CountFiberglass = Self.GetComponentCount(c_Fiberglass as Form)
		Self.RemoveComponents(c_Fiberglass, CountFiberglass, False)
		TempBox.AddItem(c_Fiberglass_scrap as Form, CountFiberglass, False)
		CountFiberOptics = Self.GetComponentCount(c_FiberOptics as Form)
		Self.RemoveComponents(c_FiberOptics, CountFiberOptics, False)
		TempBox.AddItem(c_FiberOptics_scrap as Form, CountFiberOptics, False)
		CountGears = Self.GetComponentCount(c_Gears as Form)
		Self.RemoveComponents(c_Gears, CountGears, False)
		TempBox.AddItem(c_Gears_scrap as Form, CountGears, False)
		CountGlass = Self.GetComponentCount(c_Glass as Form)
		Self.RemoveComponents(c_Glass, CountGlass, False)
		TempBox.AddItem(c_Glass_scrap as Form, CountGlass, False)
		CountGold = Self.GetComponentCount(c_Gold as Form)
		Self.RemoveComponents(c_Gold, CountGold, False)
		TempBox.AddItem(c_Gold_scrap as Form, CountGold, False)
		CountLead = Self.GetComponentCount(c_Lead as Form)
		
	UIModsComponentsCircuitry.Play(Self)
		
		Self.RemoveComponents(c_Lead, CountLead, False)
		TempBox.AddItem(c_Lead_scrap as Form, CountLead, False)
		CountLeather = Self.GetComponentCount(c_Leather as Form)
		Self.RemoveComponents(c_Leather, CountLeather, False)
		TempBox.AddItem(c_Leather_scrap as Form, CountLeather, False)
		CountNuclearMaterial = Self.GetComponentCount(c_NuclearMaterial as Form)
		Self.RemoveComponents(c_NuclearMaterial, CountNuclearMaterial, False)
		TempBox.AddItem(c_NuclearMaterial_scrap as Form, CountNuclearMaterial, False)
		CountOil = Self.GetComponentCount(c_Oil as Form)
		Self.RemoveComponents(c_Oil, CountOil, False)
		TempBox.AddItem(c_Oil_scrap as Form, CountOil, False)
		CountPlastic = Self.GetComponentCount(c_Plastic as Form)
		Self.RemoveComponents(c_Plastic, CountPlastic, False)
		TempBox.AddItem(c_Plastic_scrap as Form, CountPlastic, False)
		CountRubber = Self.GetComponentCount(c_Rubber as Form)

	UIModsComponentsScrews.Play(Self)
		
		Self.RemoveComponents(c_Rubber, CountRubber, False)
		TempBox.AddItem(c_Rubber_scrap as Form, CountRubber, False)
		CountScrews = Self.GetComponentCount(c_Screws as Form)
		Self.RemoveComponents(c_Screws, CountScrews, False)
		TempBox.AddItem(c_Screws_scrap as Form, CountScrews, False)
		CountSilver = Self.GetComponentCount(c_Silver as Form)
		Self.RemoveComponents(c_Silver, CountSilver, False)
		TempBox.AddItem(c_Silver_scrap as Form, CountSilver, False)
		CountSprings = Self.GetComponentCount(c_Springs as Form)
		Self.RemoveComponents(c_Springs, CountSprings, False)
		TempBox.AddItem(c_Springs_scrap as Form, CountSprings, False)
		CountSteel = Self.GetComponentCount(c_Steel as Form)
		Self.RemoveComponents(c_Steel, CountSteel, False)
		TempBox.AddItem(c_Steel_scrap as Form, CountSteel, False)
		CountWood = Self.GetComponentCount(c_Wood as Form)
		Self.RemoveComponents(c_Wood, CountWood, False)
		TempBox.AddItem(c_Wood_scrap as Form, CountWood, False)

		UIModsComponentsTeflon.Play(Self)		
		UIModsComponentsMetalLight.Play(Self)
		
		Utility.Wait(1.0)
		
		;Return stuff that can't be scrapped back into player inventory
		Self.RemoveAllItems(PlayerRef as ObjectReference, True)

		Utility.Wait(1.0)
		
		;Move all of the scrapped components from the temp box into the player inventory
		TempBox.RemoveAllItems(PlayerRef as ObjectReference, True)

		;In theory there is no need for the temp box, we can just to player.additem instead of TempBox

EndFunction

Function PickUpEverything()

	
	;Move stuff from the main container into the player inventory just in case there's anything left over
	Self.RemoveAllItems(PlayerREF as ObjectReference, True)
	TempBox.RemoveAllItems(PlayerREF as ObjectReference, True)
	
	Utility.Wait(0.15)
	
	;If there are still items in the box, wait, or we'll freeze the game while xferring items!
	If(Self.GetItemCount() || TempBox.GetItemCount())
		Utility.Wait(0.5)
	EndIf
	
	SoundPickupREF = SoundPickup.Play(Self)

	;clean up containers here (temp box)
	TempBox.Disable()
	TempBox.Delete()
	
	Self.Disable()
	Self.Delete()
		
	PlayerREF.AddItem(PortableScrapperInventoryItem, 1, false)
	
EndFunction

;=== Utility Methods ===

Function MoveRelative(ObjectReference objectToMove, ObjectReference targetObject, Float angleToMove, Float distanceToMove)
	;Angles are from the perspective of the object, not the player: 0 forward, 180 back, 90 left, 270 right (can't use negative numbers)

	Float offsetX = distanceToMove * Math.Sin(targetObject.GetAngleZ()+angleToMove)
	Float offsetY = distanceToMove * Math.Cos(targetObject.GetAngleZ()+angleToMove)
	
	objectToMove.MoveTo(targetObject, offsetX, offsetY, 0, True)

EndFunction
