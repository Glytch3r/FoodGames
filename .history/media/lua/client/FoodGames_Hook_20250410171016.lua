FoodGames = FoodGames or {}

local hook = ISEatFoodAction.start
function ISEatFoodAction:start()
    hook(self)
    self:handleFoodGamesCaloriesOnStart()
	self.character:reportEvent("EventEating")
end

