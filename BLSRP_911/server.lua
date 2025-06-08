local allowedJobs = { "police", "ems" }
local onDutyPlayers = {} -- Table to track players who are on duty

-- Load postal data from the 911postals.lua file
local postalData = assert(load(LoadResourceFile(GetCurrentResourceName(), '911postals.lua')))() -- Use LoadResourceFile for FiveM

if not postalData then
    print("[Error] Failed to load postal data from 911postals.lua")
    return
end

-- Function to calculate the nearest postal code
function GetPostalCode(coords)
    local nearestPostal = "Unknown Postal"
    local shortestDistance = math.huge

    for _, postal in ipairs(postalData) do
        local distance = math.sqrt((coords.x - postal.x)^2 + (coords.y - postal.y)^2)
        if distance < shortestDistance then
            shortestDistance = distance
            nearestPostal = postal.code
        end
    end

    return nearestPostal
end

RegisterCommand("lawduty", function(source, args, rawCommand) -- Renamed back from duty to lawduty
    local src = source
    local playerName = GetPlayerName(src)

    if onDutyPlayers[src] then
        onDutyPlayers[src] = nil
        TriggerClientEvent('okokNotify:Alert', src, "Duty", "You are now off duty.", 5000, 'error')
    else
        onDutyPlayers[src] = "police" -- Automatically assign the "police" job when going on duty
        TriggerClientEvent('okokNotify:Alert', src, "Duty", "You are now on duty as police.", 5000, 'success')
    end
end, false)

RegisterCommand("call911", function(source, args, rawCommand)
    local src = source
    local playerName = GetPlayerName(src)
    local message = table.concat(args, " ")

    if message == "" then
        TriggerClientEvent('okokNotify:Alert', src, "911 Error", "You must provide a message for the 911 call.", 5000, 'error')
        return
    end

    -- Notify the player with a message from the 911 operator
    TriggerClientEvent('okokNotify:Alert', src, "911 Operator", "We've got your location. Help is on the way. Try to stay safe.", 5000, 'info')

    -- Get player coordinates
    local coords = GetEntityCoords(GetPlayerPed(src))

    -- Get postal code
    local postal = GetPostalCode(coords) or "Unknown Postal"

    local locationInfo = ("Postal: %s"):format(postal)

    for playerId, job in pairs(onDutyPlayers) do
        if job and isAllowedJob(job) then
            -- Notify with okokNotify
            TriggerClientEvent('okokNotify:Alert', playerId, "911 Call", ("%s: %s (Location: %s)"):format(playerName, message, locationInfo), 10000, 'info')

            -- Add a blip on the map for the 911 call location
            TriggerClientEvent('blsrp_911:createBlip', playerId, coords, postal)
        end
    end
end, false)

RegisterCommand("911", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('okokNotify:Alert', src, "911 Info", "Please use /call911 to contact the police.", 5000, 'info')
end, false)

RegisterCommand("test911", function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('okokNotify:Alert', src, "Test", "This is a test notification.", 5000, 'info')
end, false)

-- Helper function to check if a job is allowed
function isAllowedJob(job)
    for _, allowedJob in ipairs(allowedJobs) do
        if job == allowedJob then
            return true
        end
    end
    return false
end
