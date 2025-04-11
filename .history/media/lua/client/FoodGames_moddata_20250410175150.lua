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

function FoodGames.initModData()
    local player = getPlayer()
    local playerMd = player:getModData()
    if not  playerMd['FoodGames'] then
        playerMd['FoodGames'] = playerMd['FoodGames'] or {}
        playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] or 0
        playerMd['FoodGames']['consumedCalories'] = 0
    end
end

Events.OnCreatePlayer.Add(FoodGames.initModData)