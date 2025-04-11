FoodGames = FoodGames or {}

local hook_start = ISEatFoodAction.start
function ISEatFoodAction:start()
    hook_start(self)
    self:handleFoodGamesCaloriesOnStart()
	self.character:reportEvent("EventEating")
end

local hook_stop = ISEatFoodAction.stop
function ISEatFoodAction:stop()
    hook_stop(self)
    if (self.item and not self.item:getFullType()=="Base.Cigarettes") and self.character:getInventory():contains(self.item) then
		self:handleFoodGamesCaloriesAfterEat()
    end

end

function ISEatFoodAction:convertDaysToYMD(days)
    local years = math.floor(days / 365)
    days = days % 365
    local months = math.floor(days / 30)
    days = days % 30

    return string.format("Y%d M%d D%d", years, months, days)
end


local hook_perform = ISEatFoodAction.perform

function ISEatFoodAction:perform()
    return hook_perform(self)
    self:handleFoodGamesCaloriesAfterEat(true)
end


function ISEatFoodAction:handleFoodGamesCaloriesAfterEat(isPerform)
    self.remainingCalories = self.item:getCalories()
    local dbg = getCore():getDebug()
	if dbg then
        print('----------[FoodGames]----------')
        print('[FoodGames] Percentage: ' .. self.percentage)
        print('[FoodGames] Initial Calories: ' .. self.originalCalories)
        print('[FoodGames] Remaining Calories: ' .. self.remainingCalories)
	end
    local consumedCalories = self.originalCalories - self.remainingCalories
	if isPerform then
		consumedCalories = self.originalCalories
	end

    local playerMd = self.character:getModData()
    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] or 0
    local consumedCaloriesSnapshot = playerMd['FoodGames']['consumedCalories']
    local daysOfCaloriesSnapshot = math.floor(consumedCaloriesSnapshot / SandboxVars.FoodGames.DailyCalories)
    playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] + consumedCalories
    local newDaysOfCalories = math.floor(playerMd['FoodGames']['consumedCalories'] / SandboxVars.FoodGames.DailyCalories)
    local daysChange = newDaysOfCalories - daysOfCaloriesSnapshot
    if dbg then
        print('----------[FoodGames]----------')
        print('Cosumed Calories: ' .. consumedCalories)
        print('daysOfCaloriesSnapshot: ' .. daysOfCaloriesSnapshot)
        print('newDaysOfCalories: ' .. newDaysOfCalories)
        print('Player Consumed Calories: ' .. playerMd['FoodGames']['consumedCalories'])
        print("Days Change: " .. daysChange)
    end

    if daysChange <= 0 then
		self.character:setHaloNote('Calories Stored: ' .. ISEatFoodAction:convertDaysToYMD(newDaysOfCalories))
		return
	end

    local item = InventoryItemFactory.CreateItem("Base.ChessWhite")
    local inventory = self.character:getInventory()
    if inventory then
        inventory:DoAddItem(item)
        inventory:setDrawDirty(true)
    end

    self.character:getInventory():setDrawDirty(true)
    ISInventoryPage.dirtyUI();

	self.character:setHaloNote(getText("You have gained another day's food token! Calories Stored: ") .. ISEatFoodAction:convertDaysToYMD(newDaysOfCalories))
end




function ISEatFoodAction:handleFoodGamesCaloriesOnStart()

    self.originalCalories = self.item:getCalories()

end