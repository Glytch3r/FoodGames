FoodGames = FoodGames or {}
--[[ 
function FoodGames.getCardValue(item)
    if not item then return end
    local list = SandboxVars.FoodGames.CardValues or ""
    local itemType = item:getFullType() 

    if not FoodGames._cardOverrides then
        FoodGames._cardOverrides = {}
        for entry in string.gmatch(list, "[^;]+") do
            local name, val = entry:match("([^:]+):?(%d*)")
            if name then
                FoodGames._cardOverrides[name] = tonumber(val) or 1
            end
        end
    end

    local override = FoodGames._cardOverrides[itemType]
    if override then
        return override
    end

    return 0
end

function FoodGames.isCardConsumable(item)
    return FoodGames.getCardValue(item) > 0
end

function FoodGames.consumeCard(item)
    local pl = getPlayer()
    if not item or not pl then return end

    local val = FoodGames.getCardValue(item)
    if val <= 0 then return end

    local cap = SandboxVars.FoodGames.MaxCardsQty or 46080
    local data = pl:getModData()
    data['FoodGames'] = data['FoodGames'] or {}
    data['FoodGames']['StoredCards'] = math.max(0, math.min(cap, val + (data['FoodGames']['StoredCards'] or 0)))

    ISRemoveItemTool.removeItem(item, pl)
    pl:playSound("GameBet_Store")
    pl:getInventory():setDrawDirty(true)
end

function FoodGames.consumeAllCardsFromContainer(container, pl)
    if not container or not instanceof(container, "ItemContainer") then return end
    if not pl or not instanceof(pl, "IsoPlayer") then return end
    if not pl:HasTrait("GameBet") then return end

    local items = container:getItems()
    if items:size() == 0 then return end

    local total = 0
    local removals = {}

    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item and FoodGames.getCardValue(item) > 0 then
            table.insert(removals, item)
            total = total + FoodGames.getCardValue(item)
        end
    end

    if #removals == 0 then return end

    local modData = pl:getModData()
    modData['FoodGames'] = modData['FoodGames'] or {}
    modData['FoodGames']['StoredCards'] = math.min(
        SandboxVars.FoodGames.MaxCardsQty or 46080,
        (modData['FoodGames']['StoredCards'] or 0) + total
    )

    for _, item in ipairs(removals) do
        container:Remove(item)
    end
    pl:getInventory():setDrawDirty(true)
    pl:playSound("GameBet_Store")
end

function FoodGames.getContainerCardSummary(container)
    if not container or not instanceof(container, "ItemContainer") then return 0, 0 end

    local total = 0
    local count = 0
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        local val = FoodGames.getCardValue(item)
        if val > 0 then
            total = total + val
            count = count + 1
        end
    end
    return count, total
end

function FoodGames.getCardItemCount(container)
    if not container or not instanceof(container, "ItemContainer") then return 0 end

    local count = 0
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        if FoodGames.getCardValue(items:get(i)) > 0 then
            count = count + 1
        end
    end
    return count
end

function FoodGames.getContainerCardTotal(container)
    if not container or not instanceof(container, "ItemContainer") then return 0 end

    local total = 0
    local items = container:getItems()
    for i = 0, items:size() - 1 do
        local val = FoodGames.getCardValue(items:get(i))
        if val > 0 then
            total = total + val
        end
    end
    return total
end
 ]]