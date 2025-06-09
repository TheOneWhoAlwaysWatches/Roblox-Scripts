-- Permadeath God Mode Script (Requires replicatesignal support)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Safety check
if not replicatesignal then
    warn("Your executor must support 'replicatesignal' to use this script.")
    return
end

-- Core permadeath logic
local function permadeath(player)
    replicatesignal(player.ConnectDiedSignalBackend) -- Hook death signal to block respawn
    task.wait(Players.RespawnTime - 0.165)           -- Wait just before the server auto-respawns
end
-- Run the permadeath function on the local player
permadeath(LocalPlayer)

-- Optional: Notify the user
print("✅ Permadeath mode activated. You will remain dead after dying.")