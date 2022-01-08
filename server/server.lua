ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Doors = {
    ["F1"] = {{loc = vector3(312.93, -284.45, 54.16), h = 160.91, txtloc = vector3(312.93, -284.45, 54.16), obj = nil, locked = false}, {loc = vector3(310.93, -284.44, 54.16), txtloc = vector3(310.93, -284.44, 54.16), state = nil, locked = true}},
    ["F2"] = {{loc = vector3(148.76, -1045.89, 29.37), h = 158.54, txtloc = vector3(148.76, -1045.89, 29.37), obj = nil, locked = false}, {loc = vector3(146.61, -1046.02, 29.37), txtloc = vector3(146.61, -1046.02, 29.37), state = nil, locked = true}},
    ["F3"] = {{loc = vector3(-1209.66, -335.15, 37.78), h = 213.67, txtloc = vector3(-1209.66, -335.15, 37.78), obj = nil, locked = false}, {loc = vector3(-1211.07, -336.68, 37.78), txtloc = vector3(-1211.07, -336.68, 37.78), state = nil, locked = true}},
    ["F4"] = {{loc = vector3(-2957.26, 483.53, 15.70), h = 267.73, txtloc = vector3(-2957.26, 483.53, 15.70), obj = nil, locked = false}, {loc = vector3(-2956.68, 481.34, 15.70), txtloc = vector3(-2956.68, 481.34, 15.7), state = nil, locked = true}},
    ["F5"] = {{loc = vector3(-351.97, -55.18, 49.04), h = 159.79, txtloc = vector3(-351.97, -55.18, 49.04), obj = nil, locked = false}, {loc = vector3(-354.15, -55.11, 49.04), txtloc = vector3(-354.15, -55.11, 49.04), state = nil, locked = true}},
    ["F6"] = {{loc = vector3(1174.24, 2712.47, 38.09), h = 160.91, txtloc = vector3(1174.24, 2712.47, 38.09), obj = nil, locked = false}, {loc = vector3(1176.40, 2712.75, 38.09), txtloc = vector3(1176.40, 2712.75, 38.09), state = nil, locked = true}},
}

RegisterServerEvent("norp-fleeca:startcheck")
AddEventHandler("norp-fleeca:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = ESX.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 1
        end
    end
    local xPlayer = ESX.GetPlayerFromId(_source)
    local item = xPlayer.getInventoryItem("cardA")["count"]

    if copcount >= Config.mincops then
        if not Config.Banks[bank].onaction == true then
            if (os.time() - Config.cooldown) > Config.Banks[bank].lastrobbed then
                Config.Banks[bank].onaction = true
                xPlayer.removeInventoryItem("cardA", 1)
                TriggerClientEvent("norp-fleeca:outcome", _source, true, bank)
                TriggerClientEvent("norp-fleeca:policenotify", -1, bank)
            else
                TriggerClientEvent("norp-fleeca:outcome", _source, false, "This bank recently robbed. You need to wait "..math.floor((Config.cooldown - (os.time() - Config.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((Config.cooldown - (os.time() - Config.Banks[bank].lastrobbed)), 60))
            end
        else
            TriggerClientEvent("norp-fleeca:outcome", _source, false, "This bank is currently being robbed.")
        end
    else
        TriggerClientEvent("norp-fleeca:outcome", _source, false, "There is not enough police in the city.")
    end
end)


RegisterServerEvent("norp-fleeca:lootup")
AddEventHandler("norp-fleeca:lootup", function(var, var2)
    TriggerClientEvent("norp-fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("norp-fleeca:openDoor")
AddEventHandler("norp-fleeca:openDoor", function(coords, method)
    TriggerClientEvent("norp-fleeca:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("norp-fleeca:toggleVault")
AddEventHandler("norp-fleeca:toggleVault", function(key, state)
    Doors[key][2].locked = state
    TriggerClientEvent("norp-fleeca:toggleVault", -1, key, state)
end)

RegisterServerEvent("norp-fleeca:updateVaultState")
AddEventHandler("norp-fleeca:updateVaultState", function(key, state)
    Doors[key][2].state = state
end)

RegisterServerEvent("norp-fleeca:startLoot")
AddEventHandler("norp-fleeca:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("norp-fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("norp-fleeca:startLoot_c", _source, data, name)
end)

RegisterServerEvent("norp-fleeca:stopHeist")
AddEventHandler("norp-fleeca:stopHeist", function(name)
    TriggerClientEvent("norp-fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent("norp-fleeca:rewardCash")
AddEventHandler("norp-fleeca:rewardCash", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local reward = math.random(Config.mincash, Config.maxcash)

    if Config.black then
        xPlayer.addAccountMoney("black_money", reward)
    else
        xPlayer.addMoney(reward)
    end
end)

RegisterServerEvent("norp-fleeca:setCooldown")
AddEventHandler("norp-fleeca:setCooldown", function(name)
    Config.Banks[name].lastrobbed = os.time()
    Config.Banks[name].onaction = false
    TriggerClientEvent("norp-fleeca:resetDoorState", -1, name)
end)

ESX.RegisterServerCallback("norp-fleeca:getBanks", function(source, cb)
    cb(Config.Banks, Doors)
end)