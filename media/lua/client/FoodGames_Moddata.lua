
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


-----------------------            ---------------------------
function FoodGames.getMode(pl)
    pl = pl or getPlayer()
    if not pl then return "HomeLender" end
    local md = pl:getModData()
    local mode = md and md.FoodGames and md.FoodGames.Mode
    return tostring( FoodGames.modeList[tostring(mode)] ) and tostring(mode) or "HomeLender"
end

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
-----------------------            ---------------------------
function FoodGames.resetData()
    local pl = getPlayer()
    if pl then
        local modData = pl:getModData()
        modData["FoodGames"] = {}
        local fg = modData["FoodGames"]
        fg["StoredCalories"] =  0
        fg["StoredMetal"] = 0
        fg["Mode"] = FoodGames.getDefaultMode(pl) or "HomeLender"
        
        fg["HomeLender"] = { [1] = false, [2] = false }
        fg["Wolferine"]  = { [1] = false, [2] = false }
        fg["MagKneeToe"] = { [1] = false, [2] = false }

        return fg
    end
end

function FoodGames.dataInit()
    local pl = getPlayer()
    if pl then
        local modData = pl:getModData()
        modData["FoodGames"] =    modData["FoodGames"]  or {}
        local fg = modData["FoodGames"] or {}
        fg["StoredCalories"] = fg["StoredCalories"] or 0
        fg["StoredMetal"] = fg["StoredMetal"] or 0
        fg["Mode"] = fg["Mode"] or FoodGames.getDefaultMode(pl) or "HomeLender"
        
        fg["HomeLender"] = fg["HomeLender"] or { [1] = false, [2] = false }
        fg["Wolferine"]  = fg["Wolferine"]  or { [1] = false, [2] = false }
        fg["MagKneeToe"] = fg["MagKneeToe"] or { [1] = false, [2] = false }
        return fg
    end
end

Events.OnCreatePlayer.Add(FoodGames.dataInit)

-----------------------            ---------------------------
function FoodGames.isAnySkillActive(mode)
    local pl = getPlayer()
    if not pl then return false end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    mode = tostring(mode)

    local fg = pl:getModData()["FoodGames"]
    if not fg or not fg[mode] then return false end

    return fg[mode][1] or fg[mode][2] or false
end

function FoodGames.isActiveSkill(mode, skillNum)
    skillNum = skillNum or 1
    local pl = getPlayer()
    if not pl then return false end
    mode = tostring(mode) or tostring(FoodGames.getMode(pl)) or "HomeLender"
    local data = FoodGames.getData(pl)
    return data[mode][skillNum]
end

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

function FoodGames.getActiveSkillStr(mode, skillNum)
    skillNum = skillNum or 1
    local pl = getPlayer()
    if not pl then return  end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    mode = tostring(mode)

    local fg = pl:getModData()["FoodGames"]
    local check = fg and fg[mode] and fg[mode][skillNum]
    return check and "On" or "Off"
end

function FoodGames.getAnySkillActiveStr(mode)
    local pl = getPlayer()
    if not pl then return "Off" end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    mode = tostring(mode)

    local fg = pl:getModData()["FoodGames"]
    if not fg or not fg[mode] then return "Off" end

    if fg[mode][1] or fg[mode][2] then
        return "On"
    end

    return "Off"
end

-----------------------            ---------------------------

function FoodGames.getEnergy(pl, mode)
    local data = FoodGames.getData(pl)
    mode = mode or FoodGames.getMode(pl)
    if (pl:HasTrait("MagKneeToe") and mode == "MagKneeToe") then
        return data["StoredMetal"]
    elseif (pl:HasTrait("HomeLender") and mode == "HomeLender") or (pl:HasTrait("Wolferine") and mode == "Wolferine") then
        return data["StoredCalories"]
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

function FoodGames.isHasEnergy(pl, skillNum, mode)
    pl = pl or getPlayer()
    if not pl then return false end
    skillNum = skillNum or 1
    mode = mode or FoodGames.getMode(pl)
    local charge = FoodGames.getEnergy(pl, mode)
    local cost = 0
    if mode == "MagKneeToe" then 
        if skillNum == 2 then
            cost = SandboxVars.FoodGames.MetalSkillCost2 or 64
        else 
            cost = SandboxVars.FoodGames.MetalSkillCost1 or 24
        end
    else
        cost = SandboxVars.FoodGames.CalConsume  or 500
    end
    return cost <= charge
end

function FoodGames.consumeEnergy(pl, skillNum, mode)
    pl = pl or getPlayer()
    if not pl then return end
    skillNum = skillNum or 1

    local data = FoodGames.getData(pl)
    mode = mode or FoodGames.getMode(pl)
    local cost = 0
    if not FoodGames.isHasEnergy(pl, skillNum, mode) then return false end
    if mode == "MagKneeToe" then
        if skillNum == 2 then
            cost = SandboxVars.FoodGames.MetalSkillCost2 or 64
        else
            cost = SandboxVars.FoodGames.MetalSkillCost1 or 24
        end
    else
        cost = SandboxVars.FoodGames.CalConsume or 500
    end
    local energy = FoodGames.getEnergy(pl, mode)
    energy = math.max(0,  energy - cost)
    FoodGames.checkEnergyAndDisable(pl, 1, mode)
    return true
end

-----------------------            ---------------------------
function FoodGames.checkEnergyAndDisable(pl, skillNum, mode)
    pl = pl or getPlayer()
    if not pl then return end
    skillNum = skillNum or 1
    mode = mode or FoodGames.getMode(pl) 
    local data = FoodGames.getData(pl)
    if not FoodGames.isHasEnergy(pl, skillNum, mode) then
        FoodGames.disableSkill(pl, skillNum, mode)
    end
end
function FoodGames.disableSkill(pl, skillNum, mode)
    pl = pl or getPlayer()
    if not pl then return end
    mode = mode or FoodGames.getMode(pl) 
    skillNum = skillNum or 1
    local data = FoodGames.getData(pl)   
    data[mode][skillNum] = false
end

function FoodGames.disableAllSkills()
    local pl = getPlayer()
    if not pl then return end
    for _, mode in pairs(FoodGames.modesStr) do
        if FoodGames.isActiveSkill(tostring(mode), 1) then
            FoodGames.disableSkill(pl, 1, tostring(mode))
           	if getCore():getDebug() then print("disabled: "..tostring(mode).." skill: 1") end
        end
        if FoodGames.isActiveSkill(tostring(mode), 2) then
            FoodGames.disableSkill(pl, 2, tostring(mode))
            if getCore():getDebug() then print("disabled: "..tostring(mode).." skill: 2") end
            
        end
    end
end


function FoodGames.setActiveSkill(mode, skillNum, val)
    skillNum = skillNum or 1
    local pl = getPlayer()
    if not pl then return end
    val = val or true
    mode = mode or FoodGames.getMode(pl) or FoodGames.getDefaultMode(pl) or nil
    FoodGames.disableAllSkills()
    local fg = FoodGames.getData()
    fg[tostring(mode)][skillNum] = val
    FoodGames.checkEnergyAndDisable(pl, skillNum) 
end
-----------------------            ---------------------------
function FoodGames.getDefaultMode(pl)
    pl = pl or getPlayer()
    for _, mode in pairs(FoodGames.modesStr) do
        if pl:HasTrait(mode) then
            return mode
           -- print(mode)
        end
    end
    return false
end


function FoodGames.isHero(pl)
    pl = pl or getPlayer()
    for mode in pairs(FoodGames.modeList) do
        if pl:HasTrait(mode) then
            return true
        end
    end
    return false
end

-----------------------            ---------------------------

function FoodGames.convertDaysToYMD(days)
    
    if not days then return "" end

    if days == 0 then return ""   end

    local years = math.floor(days / 365)
    days = days % 365
    local months = math.floor(days / 30)
    days = days % 30

    return string.format("Y%d M%d D%d", years, months, days)
end
-----------------------            ---------------------------
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
