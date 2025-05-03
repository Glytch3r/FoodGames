
require "NPCs/MainCreationMethods"

Events.OnGameBoot.Add(function()
	local traitStr = "HomeLender"
	TraitFactory.addTrait(traitStr, getText("UI_trait_"..traitStr), 2, getText("UI_trait_"..traitStr.."_desc"), false)
	local traitStr = "Wolferine"
	TraitFactory.addTrait(traitStr, getText("UI_trait_"..traitStr), 2, getText("UI_trait_"..traitStr.."_desc"), false)


	TraitFactory.sortList()
	local traits = TraitFactory.getTraits()
	for i=0, traits:size()-1 do
		local trait = traits:get(i)
		BaseGameCharacterDetails.SetTraitDescription(trait)
	end
end)

