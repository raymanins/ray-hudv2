local QBCore = exports['qb-core']:GetCoreObject()

local HUD = {
    enabled = false,
    health = 100,
    armor = 100,
    food = 100,
    water = 100,
    speed = 0,
    fuel = 100,
    seatbelt = false,
    talking = false,
    proximity = 0
}

local function sendHUDUpdates()
    SendNUIMessage({
        action = "update_hud",
        health = HUD.health,
        armor = HUD.armor,
        food = HUD.food,
        water = HUD.water,
        speed = HUD.speed,
        fuel = HUD.fuel,
        seatbelt = HUD.seatbelt,
        talking = HUD.talking,
        proximity = HUD.proximity
    })
end

local function updateHUD()
    local ped = cache.ped
    local vehicle = cache.vehicle

    if vehicle then
        -- Show HUD and minimap when player is in a vehicle
        HUD.enabled = true
        DisplayRadar(true)
        HUD.speed = math.floor(GetEntitySpeed(vehicle) * 3.6) -- Speed in km/h
        HUD.fuel = math.floor(GetVehicleFuelLevel(vehicle))
        HUD.seatbelt = LocalPlayer.state.seatbelt
    else
        -- Hide HUD and minimap when player is not in a vehicle
        HUD.enabled = false
        DisplayRadar(false)
        HUD.speed = 0
        HUD.fuel = 0
        HUD.seatbelt = false
    end

    -- Update other HUD values
    HUD.health = math.floor((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100)
    HUD.armor = math.floor(GetPedArmour(ped))
    HUD.food = math.floor(QBCore.Functions.GetPlayerData().metadata["hunger"])
    HUD.water = math.floor(QBCore.Functions.GetPlayerData().metadata["thirst"])
    HUD.talking = NetworkIsPlayerTalking(PlayerId())
    if LocalPlayer.state.proximity then
        HUD.proximity = LocalPlayer.state.proximity.distance
    end

    -- Send HUD updates
    sendHUDUpdates()
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    HUD.enabled = true
    SendNUIMessage({
        action = "toggle_hud",
        enabled = HUD.enabled
    })

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            updateHUD()
        end
    end)
end)

RegisterCommand('togglehud', function()
    HUD.enabled = not HUD.enabled
    SendNUIMessage({
        action = "toggle_hud",
        enabled = HUD.enabled
    })
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        HUD.enabled = false
        SendNUIMessage({
            action = "show_hud",
            enabled = HUD.enabled
        })
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Update HUD every 33 milliseconds (30 times per second)
        updateHUD()
    end
end)
