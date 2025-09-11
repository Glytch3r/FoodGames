FoodGames = FoodGames or {}


function FoodGames.getMetalValue(item)
    if not item then return end
    
    local vMult = SandboxVars.FoodGames.MetalMultiplier or 0.5
    local wMult = SandboxVars.FoodGames.MetalWeightMultiplier or 3.5
    local list = SandboxVars.FoodGames.MetalValues or ""
    local itemType = item:getFullType()

    if not FoodGames._metalOverrides then
        FoodGames._metalOverrides = {}
        for entry in string.gmatch(list, "[^;]+") do
            local name, val = entry:match("([^:]+):?(%d*)")
            if name then
                FoodGames._metalOverrides[name] = tonumber(val) or 1
            end
        end
    end

    local override = FoodGames._metalOverrides[itemType]
    if override then
        return override * vMult
    end

    if item.getMetalValue then
        local val = item:getMetalValue()
        if type(val) == "number" then
            return val * vMult
        end
    end

    if item:hasTag("HasMetal") then
        return item:getWeight() * wMult
    end

    return 0
end

function FoodGames.isMetalConsumable(item)
    return FoodGames.getMetalValue(item) > 0
end

function FoodGames.consumeMetal(item)
    local pl = getPlayer()
    if not item or not pl then return end

    local val = FoodGames.getMetalValue(item)
    if val <= 0 then return end

    local cap = SandboxVars.FoodGames.MetalCapacity or 46080
    local data = pl:getModData()['FoodGames']
    data['StoredMetal'] = math.max(0, math.min(cap, val + (data['StoredMetal'] or 0)))

    ISRemoveItemTool.removeItem(item, pl)
    pl:playSound("MagKneeToe_Store")
    pl:getInventory():setDrawDirty(true)
end

function FoodGames.getContainerMetalSummary(container)
    if not container or not instanceof(container, "ItemContainer") then return 0, 0 end

    local total = 0
    local count = 0
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local val = FoodGames.getMetalValue(item)
        if val > 0 then
            total = total + val
            count = count + 1
        end
    end
    return count, total
end

function FoodGames.getMetalItemCount(container)
    if not container or not instanceof(container, "ItemContainer") then return 0, 0 end

    local total = 0
    local count = 0
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local val = FoodGames.getMetalValue(item)
        if val > 0 then
            total = total + val
            count = count + 1
        end
    end
    return count
end

function FoodGames.getContainerMetalTotal(container)
    if not container or not instanceof(container, "ItemContainer") then return 0 end

    local total = 0
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local val = FoodGames.getMetalValue(item)
        if val > 0 then
            total = total + val
        end
    end
    return total
end
-----------------------            ---------------------------

function FoodGames.consumeAllMetalFromContainer(container, pl)


	if not container or not instanceof(container, "ItemContainer") then return end
	if not pl or not instanceof(pl, "IsoPlayer") then return end
    if not pl:HasTrait("MagKneeToe") then return end

	local items = container:getItems()
	local count = items:size()
	if count == 0 then return end

	local total = 0
	local removals = {}

	for i = 0, count - 1 do
		local item = items:get(i)
		if item and FoodGames.getMetalValue(item) > 0 then
			table.insert(removals, item)
			total = total + FoodGames.getMetalValue(item)
		end
	end

	if #removals == 0 then return end

	local modData = pl:getModData()['FoodGames']
	modData['StoredMetal'] = (modData['StoredMetal'] or 0) + total
    
	for _, item in ipairs(removals) do
		container:Remove(item)
	end
    pl:getInventory():setDrawDirty(true)
    pl:playSound("MagKneeToe_Store")

end
-----------------------            ---------------------------
--[[

function FoodGames.unequipItemIfEquipped(player, item)
    if not pl or not item then return end
    local inv = pl:getInventory()
    local pm = pl:getPrimaryHandItem()
    local sm = pl:getSecondaryHandItem()

    if pm == item then pl:setPrimaryHandItem(nil) end
    if sm == item then pl:setSecondaryHandItem(nil) end

    if inv:contains(item) and item:isEquipped() then
        item:setEquipParent(nil)
        item:setAttachedSlot(-1)
        item:setAttachedSlotType(nil)
        item:setAttachedToModel(nil)
    end
    pl:getInventory():setDrawDirty(true)
end
 ]]