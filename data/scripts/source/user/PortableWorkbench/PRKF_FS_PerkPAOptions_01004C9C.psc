;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname PortableWorkbench:PRKF_FS_PerkPAOptions_01004C9C Extends Perk Hidden Const

;BEGIN FRAGMENT Fragment_Entry_00
Function Fragment_Entry_00(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
PortableWorkbench_PowerArmor thisPABench = akTargetRef as PortableWorkbench_PowerArmor
thisPABench.PickUpEverything()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
