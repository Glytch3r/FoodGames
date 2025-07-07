FoodGames = FoodGames or {}
FoodGames = FoodGames or {}
FoodGames.Actions = FoodGames.Actions or {}

require "TimedActions/ISBaseTimedAction"

FoodGames.Actions.ConsumeMetalAction = ISBaseTimedAction:derive("ConsumeMetalAction")

function FoodGames.Actions.ConsumeMetalAction:isValid()
    return self.container ~= nil and self.player ~= nil
end

function FoodGames.Actions.ConsumeMetalAction:update()
end

function FoodGames.Actions.ConsumeMetalAction:start()
    self:setActionAnim("Loot")
    self:setOverrideHandModels(nil, nil)
end

function FoodGames.Actions.ConsumeMetalAction:perform()
    local items = self.container:getItems()
    local count = items:size()
    local removals = {}
    local total = 0

    for i = 0, count - 1 do
        local item = items:get(i)
        if item and FoodGames.isMetalConsumable(item) then
            table.insert(removals, item)
            total = total + FoodGames.getMetalValue(item)
        end
    end

    if total > 0 then
        local data = self.player:getModData()['FoodGames']
        data['StoredMetal'] = (data['StoredMetal'] or 0) + total

        for _, item in ipairs(removals) do
            self.container:Remove(item)
        end

        self.player:getInventory():setDrawDirty(true)
    end

    ISBaseTimedAction.perform(self)
end

function FoodGames.startConsumeMetalAction(player, container)
    if not container or not instanceof(container, "ItemContainer") then return end
    if not player or not instanceof(player, "IsoPlayer") then return end

    local action = FoodGames.Actions.ConsumeMetalAction:new(player, container, 100)
    ISTimedActionQueue.add(action)
end

function FoodGames.Actions.ConsumeMetalAction:new(player, container, time)
    local o = ISBaseTimedAction.new(self, player, time or 60)
    o.container = container
    return o
end
