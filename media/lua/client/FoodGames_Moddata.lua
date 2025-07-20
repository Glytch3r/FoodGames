
FoodGames = FoodGames or {}
FoodGames.modeList = {
    ["HomeLender"] = true,
    ["Wolferine"] = true,
    ["MagKneeToe"] = true,
}
FoodGames.modesStr = {
    "HomeLender",
    "Wolferine",
    "MagKneeToe",
}
FoodGames.isOneShot = false
function FoodGames.getModeNum(mode)
    mode = mode or FoodGames.getMode()
    local modeNum = {
        ["HomeLender"] = 1,
        ["Wolferine"] = 2,
        ["MagKneeToe"] = 3,
    }
    return modeNum[tostring(mode)]
end
function FoodGames.getPreviousMode(mode)
    mode = mode or FoodGames.getMode()
    local idx = FoodGames.getModeNum(mode) - 1
    if idx < 1 then idx = #FoodGames.modesStr end
    return FoodGames.modesStr[idx]
end


function FoodGames.getNextMode(mode)
    mode = mode or FoodGames.getMode()
    local idx = FoodGames.getModeNum(mode) + 1
    if idx > #FoodGames.modesStr then idx = 1 end
    return FoodGames.modesStr[idx]
end

function FoodGames.dataInit()
    local pl = getPlayer()
    if pl then
        local modData = pl:getModData()
        modData["FoodGames"] =    modData["FoodGames"]  or {}
        local fg = modData["FoodGames"] or {}
        fg["StoredCalories"] = fg["StoredCalories"] or 0
        fg["StoredMetal"] = fg["StoredMetal"] or 0
        fg["Mode"] = fg["Mode"] or "HomeLender"
        
        --fg["Cataapult"] = fg["Cataapult"] or false
        fg["HomeLender"] = fg["HomeLender"] or { [1] = false, [2] = false }
        fg["Wolferine"]  = fg["Wolferine"]  or { [1] = false, [2] = false }
        fg["MagKneeToe"] = fg["MagKneeToe"] or { [1] = false, [2] = false }
        
        
        return fg
    end
end

Events.OnCreatePlayer.Add(FoodGames.dataInit)

--if FoodGames.isHasEnergy(pl, skillNum) then 

function FoodGames.checkEnergyAndDisable(pl, skillNum)
    pl = pl or getPlayer()
    if not pl then return end



    skillNum = skillNum or 1
    
    local data = FoodGames.getData(pl)
    local mode = FoodGames.getMode(pl)
    local skillNum = FoodGames.getActiveSkill(pl)
    --FoodGames.consumeEnergy(pl, skillNum)
    if not FoodGames.isHasEnergy(pl, skillNum) then
        --FoodGames.setActiveSkill(mode, skillNum, false)
        --FoodGames.disableAllSkills()
    end
--[[     local cal = data and data.StoredCalories or 0
    local threshold = SandboxVars.FoodGames.CalConsume or 500
    local cost = threshold
    if data and mode ~= "Wolferine" then
        if cal - cost < threshold then
            mode = 'Wolferine'
        end
    end ]]
end






--[[ 
if FoodGames.isHasEnergy(pl, skillNum) then
    FoodGames.consumeEnergy(pl, skillNum)
end
 ]]
function FoodGames.getActiveSkill(pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    local mode = FoodGames.getMode(pl)
    for mode, _ in pairs(FoodGames.modeList) do
        if data[mode] then
            if data[mode][1] ~= nil then 
                if data[mode][1] == true then
                    return 1
                end
            end
            if data[mode][2] ~= nil then 
                if data[mode][2] == true then
                    return 2
                end
            end
        end
    end
end


function FoodGames.getMaxEnergy(mode)
    mode = mode or FoodGames.getMode()
    if mode == "MagKneeToe" then
        return SandboxVars.FoodGames.MaxMetalCapacity or 0
    else
        return SandboxVars.FoodGames.DailyCalories or 0
    end
end

function FoodGames.isHasEnergy(pl, skillNum)
    pl = pl or getPlayer()
    if not pl then return false end
    skillNum = skillNum or 1
    local charge = 0
    local cost = 0
    local data = FoodGames.getData(pl)
    local mode = FoodGames.getMode(pl)
    data['StoredMetal'] = data['StoredMetal'] or 0
    data['StoredCalories'] = data['StoredCalories'] or 0
    
    if mode == "MagKneeToe" then 
        if skillNum == 2 then
            cost = SandboxVars.FoodGames.MetalSkillCost2 or 64
        else 
            cost = SandboxVars.FoodGames.MetalSkillCost1 or 24
        end
        charge =  data['StoredMetal'] or  0

    else
        cost = SandboxVars.FoodGames.CalConsume  or 500
        charge = data['StoredCalories'] or 0
        
    end
    

    return cost <= charge
end
function FoodGames.consumeEnergy(pl, skillNum)
    pl = pl or getPlayer()
    if not pl then return end
    skillNum = skillNum or 1

    local data = FoodGames.getData(pl)
    local mode = FoodGames.getMode(pl)
    local cost = 0
    
    data['StoredMetal'] = pl:getModData()['FoodGames']['StoredMetal'] or 0
    data['StoredCalories'] = pl:getModData()['FoodGames']['StoredCalories'] or 0

    if mode == "MagKneeToe" then
        if skillNum == 2 then
            cost = SandboxVars.FoodGames.MetalSkillCost2 or 64
        else
            cost = SandboxVars.FoodGames.MetalSkillCost1 or 24
        end
        data['StoredMetal'] = math.max(0,  data['StoredMetal'] - cost)
    else
        cost = SandboxVars.FoodGames.CalConsume or 500
        data['StoredCalories'] = math.max(0,  data['StoredCalories'] - cost)
    end
 
end


function FoodGames.getData(pl)
    pl = pl or getPlayer()
    if not pl then return {} end
    local data = {}
    local md = pl:getModData()
    if md then
        data = md.FoodGames
    end
    return data or {}
end

function FoodGames.getMode(pl)
    pl = pl or getPlayer()
    if not pl then return "HomeLender" end
    local md = pl:getModData()
    local mode = md and md.FoodGames and md.FoodGames.Mode
    mode = tostring(mode)

    return FoodGames.modeList[mode] and mode or "HomeLender"
end

function FoodGames.isActiveSkill(mode, int)
    int = int or 1
    local pl = getPlayer()
    if not pl then return  end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    mode = tostring(mode)
    local fg = pl:getModData()["FoodGames"]

    return fg and fg[mode] and fg[mode][int]
end

function FoodGames.getActiveSkillStr(mode, int)
    int = int or 1
    local pl = getPlayer()
    if not pl then return  end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    mode = tostring(mode)

    local fg = pl:getModData()["FoodGames"]
    local check = fg and fg[mode] and fg[mode][int]
    return check and "On" or "Off"
end

function FoodGames.disableAllSkills()
    local pl = getPlayer()
    if not pl then return end
    local fg = pl:getModData()["FoodGames"]
    if not fg then return FoodGames.dataInit() end
    
    for mode, _ in pairs(FoodGames.modeList) do
        mode = tostring(mode)
        if fg[mode]  then
            fg[mode][1] = false
            if fg[mode][2] ~= nil then 
                fg[mode][2] = false
            end
        end
    end
end

function FoodGames.setActiveSkill(mode, int, val)
    int = int or 1
    local pl = getPlayer()
    if not pl then return end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    local fg = pl:getModData()["FoodGames"]
    fg[tostring(mode)][int] = val
    FoodGames.checkEnergyAndDisable(pl, int) 
end



--[[ 
function FoodGames.setActiveSkill(mode, int, val)
    int = int or 1
    local pl = getPlayer()
    if not pl then return end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    local fg = pl:getModData()["FoodGames"]
    fg[tostring(mode)][int] = val
    FoodGames.checkEnergyAndDisable(pl, skillNum)
end
 ]]
function FoodGames.isHero(pl)
    pl = pl or getPlayer()
    for mode in pairs(FoodGames.modeList) do
        if pl:HasTrait(mode) then
            return true
        end
    end
    return false
end
--[[ "Icon_Off_"..tostring(self.mode)..".png"
"Icon_On_"..tostring(self.mode)..".png" ]]

-----------------------            ---------------------------
--monkey's code i only placed it on a table

function FoodGames.convertDaysToYMD(days)
    
    if not days then return "" end

    if days == 0 then return ""   end

    local years = math.floor(days / 365)
    days = days % 365
    local months = math.floor(days / 30)
    days = days % 30

    return string.format("Y%d M%d D%d", years, months, days)
end

function FoodGames.clearCaloriesData()
    local pl = getPlayer()
    local md = pl:getModData()

    md['FoodGames'] = md['FoodGames'] or {}
    md['FoodGames']['StoredCalories'] = md['FoodGames']['StoredCalories'] or 0
    md['FoodGames']['StoredCalories'] = 0
    md['FoodGames']['Mode'] = 'HomeLender'
   
end

function FoodGames.clearMetalData()
    local pl = getPlayer()
    local md = pl:getModData()

    md['FoodGames'] = md['FoodGames'] or {}
    md['FoodGames']['StoredMetal'] = md['FoodGames']['StoredMetal'] or 0
    md['FoodGames']['StoredMetal'] = 0
    md['FoodGames']['Mode'] = 'MagKneeToe'


end
-----------------------            ---------------------------
function FoodGames.printFoodGames()
    local pl = getPlayer()
    local md = pl:getModData()

    md['FoodGames'] = md['FoodGames'] or {}
    
    print("Consumed Calories: "..md['FoodGames']['StoredCalories'])
    print("Stored Metal: "..md['FoodGames']['StoredMetal'])

end
