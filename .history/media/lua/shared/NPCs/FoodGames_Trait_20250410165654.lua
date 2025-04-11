
require "NPCs/MainCreationMethods"

Events.OnGameBoot.Add(function()
	local traitStr = "HomeLender"
	TraitFactory.addTrait(traitStr, getText("UI_trait_"..traitStr), 10, getText("UI_trait_"..traitStr.."_desc"), true)
	TraitFactory.sortList()
	local traits = TraitFactory.getTraits()
	for i=0, traits:size()-1 do
		local trait = traits:get(i)
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end
end)


--[[
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
 ]]