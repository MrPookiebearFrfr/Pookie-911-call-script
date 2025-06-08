RegisterCommand("911", function(source, args, rawCommand)
    local message = table.concat(args, " ")
    if message == "" then
        TriggerEvent('chat:addMessage', { args = { "^1Error", "You must provide a message for the 911 call." } })
        return
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    TriggerServerEvent("blsrp_911:send911", message, coords)
    TriggerEvent('chat:addMessage', { args = { "^2Success", "Your 911 call has been sent." } })
end, false)

RegisterNetEvent('blsrp_911:createBlip')
AddEventHandler('blsrp_911:createBlip', function(coords, streetName, postal)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161) -- Set blip icon (e.g., 161 for a warning icon)
    SetBlipScale(blip, 1.2) -- Set blip size
    SetBlipColour(blip, 1) -- Set blip color (e.g., 1 for red)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(("911 Call: %s (Postal: %s)"):format(streetName, postal))
    EndTextCommandSetBlipName(blip)

    -- Flash the blip for attention
    SetBlipFlashes(blip, true)

    -- Remove the blip after 5 minutes
    Citizen.CreateThread(function()
        Citizen.Wait(300000) -- 5 minutes in milliseconds
        RemoveBlip(blip)
    end)
end)
