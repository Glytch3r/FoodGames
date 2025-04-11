function Cruellinnet.AimsBlessing(zed)
	local pl = getPlayer()
	local targ =  zed:getTarget()
	local bool = false
	if targ then
		bool = targ:HasTrait("AimsBlessing")
	end
	zed:setVariable("AimsBlessing", bool)
	if bool == false then
		zed:clearVariable("AimsBlessing")
	end
end
Events.OnZombieUpdate.Add(Cruellinnet.AimsBlessing)



--shared\NPCs\myModule_Trait.lua

require "NPCs/MainCreationMethods"

Events.OnGameBoot.Add(function()
	local traitStr = "myModule"
	TraitFactory.addTrait(traitStr, getText("UI_trait_"..traitStr), 5, getText("UI_trait_"..traitStr.."_desc"), true)
	TraitFactory.sortList()
	local traits = TraitFactory.getTraits()
	for i=0, traits:size()-1 do
		local trait = traits:get(i)
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end
end)
-----------------------            ---------------------------
--media\ui\Traits\trait_myTrait.png
--media\lua\shared\Translate\EN\UI_EN.txt
UI_EN = {
	UI_trait_myModule = "myModule",
	UI_trait_myModule_desc = "myModule",
}
-----------------------            ---------------------------
local myModule.trait = ""
pl:HasTrait(myModule.trait)
pl:getTraits():add(myModule.trait)
pl:getTraits():remove(myModule.trait)
sendPlayerStatsChange(pl)
SyncXp(pl)

for i=0,TraitFactory.getTraits():size()-1 do
local trait = TraitFactory.getTraits():get(i);
	if trait:getCost() > 0 then
		if not getPlayer():HasTrait(trait:getType()) then getPlayer():getTraits():add(trait:getType()) end
	else
		if getPlayer():HasTrait(trait:getType()) then  getPlayer():getTraits():remove(trait:getType()) end
	end
end
