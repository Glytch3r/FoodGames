
FoodGames = FoodGames or {}

function FoodGames.initModData()
    local player = getPlayer()
    local playerMd = player:getModData()
    if not playerMd['FoodGames'] then
        playerMd['FoodGames'] = playerMd['FoodGames'] or {}
        playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] or 0
        playerMd['FoodGames']['consumedCalories'] = 0
    end
    playerMd['FoodGames']['Catapult'] = false
end
Events.OnCreatePlayer.Add(FoodGames.initModData)

-----------------------            ---------------------------
--monkey's code i only placed it on a table

function FoodGames.convertDaysToYMD(days)
    local years = math.floor(days / 365)
    days = days % 365
    local months = math.floor(days / 30)
    days = days % 30

    return string.format("Y%d M%d D%d", years, months, days)
end

function FoodGames.clearFoodGamesModData()
    local player = getPlayer()
    local playerMd = player:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    playerMd['FoodGames']['consumedCalories'] = playerMd['FoodGames']['consumedCalories'] or 0
    playerMd['FoodGames']['consumedCalories'] = 0
    playerMd['FoodGames']['Catapult'] = false
end

function FoodGames.printFoodGames()
    local player = getPlayer()
    local playerMd = player:getModData()

    playerMd['FoodGames'] = playerMd['FoodGames'] or {}
    print(playerMd['FoodGames']['consumedCalories'])
end



