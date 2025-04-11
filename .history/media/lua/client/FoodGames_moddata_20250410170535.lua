FoodGames = FoodGames or {}
--monkey's code i only placed it on a table
function FoodGames.clearFoodGamesModData()
    local player = getPlayer()
    local playerMd = player:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] or 0
    playerMd['FoodGames']['consumedCalories'] = 0
end

function FoodGames.printFoodGames()
    local player = getPlayer()
    local playerMd = player:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    print(playerMd['FoodGames']['consumedCalories'])
end