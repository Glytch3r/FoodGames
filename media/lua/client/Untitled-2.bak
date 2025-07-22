
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


-----------------------            ---------------------------
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
    local mode = md and md.FoodGames and md['FoodGames']['Mode']
    mode = tostring(mode)

    return FoodGames.modeList[mode] and mode or "HomeLender"
end



-----------------------            ---------------------------
function FoodGames.getPage(pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    for mode, _ in pairs(FoodGames.modeList) do
        if data[mode] and data[mode].page == true then
            return mode
        end
    end
end

function FoodGames.setPage(mode, pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    for key, _ in pairs(FoodGames.modeList) do
        if data[key] then
            data[key].page = (key == mode)
        end
    end
end

function FoodGames.getIndex(mode, pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    return data[mode] and data[mode].index
end

function FoodGames.getSkillData(mode, skillNum, pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    return data[mode] and data[mode]["skill_"..tostring(skillNum)]
end

function FoodGames.getCost(mode, skillNum, pl)
    local skill = FoodGames.getSkillData(mode, skillNum, pl)
    return skill and skill.cost or 0
end
-----------------------            ---------------------------
function FoodGames.isActive(mode, skillNum, pl)
    local skill = FoodGames.getSkillData(mode, skillNum, pl)
    return skill and skill.active or false
end

function FoodGames.setActive(mode, skillNum, pl)
    pl = pl or getPlayer()
    if not pl:HasTrait(mode) then return end
    local data = FoodGames.getData(pl)
    for i = 1, 2 do
        local skill = FoodGames.getSkillData(mode, i, pl)
        if skill then
            skill.active = (i == skillNum)
        end
    end
end
-----------------------            ---------------------------

function FoodGames.getName(mode, pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    return data[mode] and data[mode].name or mode
end

function FoodGames.getPreviousMode(pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    local current = FoodGames.getPage(pl)
    if not current then return end

    local ordered = {}
    for mode, _ in pairs(FoodGames.modeList) do
        table.insert(ordered, mode)
    end
    table.sort(ordered, function(a, b) return FoodGames.getIndex(a, pl) < FoodGames.getIndex(b, pl) end)

    local found = false
    for i = #ordered, 1, -1 do
        if ordered[i] == current then
            found = true
        elseif found and pl:HasTrait(ordered[i]) then
            return ordered[i]
        end
    end

    for i = #ordered, 1, -1 do
        if pl:HasTrait(ordered[i]) then
            return ordered[i]
        end
    end

    return FoodGames.getName(current, pl)
end

function FoodGames.isHasEnergy(pl, skillNum)
    pl = pl or getPlayer()
    if not pl then return false end
    skillNum = skillNum or 1
    local charge = 0
    local cost = 0
    local data = FoodGames.getData(pl)
    local mode = FoodGames.getMode(pl)
    if mode == "MagKneeToe" then 
        if skillNum == 2 then
            cost = SandboxVars.FoodGames.MetalSkillCost2 or 64
        else 
            cost = SandboxVars.FoodGames.MetalSkillCost1 or 24
        end
        charge = data.StoredMetal  or 0
    else
        cost = SandboxVars.FoodGames.CalConsume  or 500
        charge = data.StoredCalories or 0
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

    if mode == "MagKneeToe" then
        if skillNum == 2 then
            cost = SandboxVars.FoodGames.MetalSkillCost2 or 64
        else
            cost = SandboxVars.FoodGames.MetalSkillCost1 or 24
        end
        data.StoredMetal = math.max(0, (data.StoredMetal or 0) - cost)
    else
        cost = SandboxVars.FoodGames.CalConsume or 500
        data.StoredCalories = math.max(0, (data.StoredCalories or 0) - cost)
    end
    
end


function FoodGames.getNextMode(pl)
    pl = pl or getPlayer()
    local data = FoodGames.getData(pl)
    local current = FoodGames.getPage(pl)
    if not current then return end

    local ordered = {}
    for mode, _ in pairs(FoodGames.modeList) do
        table.insert(ordered, mode)
    end
    table.sort(ordered, function(a, b) return FoodGames.getIndex(a, pl) < FoodGames.getIndex(b, pl) end)

    local found = false
    for i = 1, #ordered do
        if ordered[i] == current then
            found = true
        elseif found and pl:HasTrait(ordered[i]) then
            return ordered[i]
        end
    end

    for i = 1, #ordered do
        if pl:HasTrait(ordered[i]) then
            return ordered[i]
        end
    end

    return FoodGames.getName(current, pl)
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
function FoodGames.dataInit(isForce)
    local pl = getPlayer()
    if pl then
        if isForce then
            pl:getModData()["FoodGames"] = {}
        end
        pl:getModData()["FoodGames"]  = pl:getModData()["FoodGames"] or {}
        data = pl:getModData()["FoodGames"]

        if not data then return false end 

        if isForce then
            data["StoredCalories"] = 0
            data["StoredMetal"] =  0
        else
            data["StoredCalories"] = data["StoredCalories"] or 0
            data["StoredMetal"] = data["StoredMetal"] or 0            
        end
        --data["Cataapult"] = data["Cataapult"] or false
        if data["HomeLender"] == nil or isForce then
            data["HomeLender"] = {
                ['page']=false, 
                ['skill_1']={["available"]=true, ['active']=false, ['isOneShot']=false, ['cost']= SandboxVars.FoodGames.CalConsume or 500},
                ['skill_2']={['available']=false},
                ['index']=1,
                ['name']="HomeLender",
            }
        end    
    
        if data["Wolferine"] == nil then
            data["Wolferine"] = {
                ['page']=false, 
                ['skill_1']={["available"]=true, ['active']=false, ['isOneShot']=true, ['cost']= SandboxVars.FoodGames.CalConsume or 500},
                ['skill_2']={['available']=false},
                ['index']=2,
                ['name']="Wolferine",
            }
        end

       if data["MagKneeToe"] == nil then
            data["MagKneeToe"] = {
                ['page']=false, 
                ['skill_1']={["available"]=true, ['active']=false, ['isOneShot']=false, ['cost']= SandboxVars.FoodGames.MetalSkillCost1 or 24},
                ['skill_2']={["available"]=true, ['active']=false, ['isOneShot']=true, ['cost']= SandboxVars.FoodGames.MetalSkillCost2 or 64},
                ['index']=3,
                ['name']="MagKneeToe",
            }
        end
   
        local mode = nil
        if pl:HasTrait("HomeLender") then
            mode = "HomeLender"
        elseif pl:HasTrait("Wolferine") then
            mode = "Wolferine"
        elseif pl:HasTrait("MagKneeToe") then
            mode = "MagKneeToe"
        else
            return
        end
        if isForce then
            data[tostring(mode)] = {}
        else
            data[tostring(mode)] =  data[tostring(mode)] or {}        
        end

        data[tostring(mode)]['page'] = true
        
        
        return data
    end
end
Events.OnCreatePlayer.Add(function() FoodGames.dataInit(false) end)





-----------------------   change codes below         ---------------------------

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
function FoodGames.isActiveSkill(mode, int)
    int = int or 1
    local pl = getPlayer()
    if not pl then return  end
    mode = mode or FoodGames.getMode(pl)
    if not mode then return end
    mode = tostring(mode)
    return mode[int]
end


function FoodGames.disableAllSkills()
    local pl = getPlayer()
    if not pl then return end
    local fg = pl:getModData()["FoodGames"]
    if not fg then return FoodGames.dataInit() end
    
    for mode, _ in pairs(FoodGames.modeList) do
        mode = tostring(mode)
        if fg[mode] then
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




function FoodGames.getActiveSkillStr(mode, int)
--old structure but thats the thing i want returned
--on and off string based on the active skill
    int = int or 1
    local pl = getPlayer()
    if not pl then return  end
    mode = mode or FoodGames.getMode(pl) or "HomeLender"
    mode = tostring(mode)

    local fg = pl:getModData()["FoodGames"]
    local check = fg and fg[mode] and fg[mode][int]
    return check and "On" or "Off"
end







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

--[[ 


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
function FoodGames.isActiveSkill(mode, int)
    int = int or 1
    local pl = getPlayer()
    if not pl then return  end
    mode = mode or FoodGames.getMode(pl)
    if not mode then return end
    mode = tostring(mode)
    return mode[int]
end


function FoodGames.disableAllSkills()
    local pl = getPlayer()
    if not pl then return end
    local fg = pl:getModData()["FoodGames"]
    if not fg then return FoodGames.dataInit() end
    
    for mode, _ in pairs(FoodGames.modeList) do
        mode = tostring(mode)
        if fg[mode] then
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


function FoodGames.isHero(pl)
    pl = pl or getPlayer()
    for mode in pairs(FoodGames.modeList) do
        if pl:HasTrait(mode) then
            return true
        end
    end
    return false
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

--[[ "Icon_Off_"..tostring(self.mode)..".png"
"Icon_On_"..tostring(self.mode)..".png" ]]

-----------------------            ---------------------------
--monkey's code i only placed it on a table

function FoodGames.convertDaysToYMD(days)
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
