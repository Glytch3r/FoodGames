function clearFoodGamesModData()
    local player = getPlayer()
    local playerMd = player:getModData()
    
    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] or 0
    playerMd['FoodGames']['consumedCalories'] = 0
end

function printFoodGames()
    local player = getPlayer()
    local playerMd = player:getModData()
    
    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    print(playerMd['FoodGames']['consumedCalories'])
end