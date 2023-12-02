local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local character = localPlayer.Character

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Sigma4.0", "LightTheme")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Keybind")
Section:NewKeybind("ToggleKeybind", "KeybindInfo", Enum.KeyCode.V, function()
	Library:ToggleUI()
end)

local Section = Tab:NewSection("KillAura")
local Radius = 20
local Delay = 0.03
local remoteEvent = game:GetService("ReplicatedStorage"):FindFirstChild("events-ZLx"):FindFirstChild("4353f763-a392-484a-9430-e57e96530e32")

local function FindNearestPlayer()
    local localPlayer = game.Players.LocalPlayer
    local nearestPlayer = nil
    local nearestDistance = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= Radius and distance < nearestDistance then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
    end

    return nearestPlayer
end

local function FireRemoteEventWithNearestPlayer()
    local nearestPlayer = FindNearestPlayer()
    if nearestPlayer then
        local args = {
            [1] = nearestPlayer
        }
        remoteEvent:FireServer(unpack(args))
    end
end

local autoAttackEnabled = false

Section:NewToggle("KillAura", "Automatically Attack Nearest Player", function(state)
    autoAttackEnabled = state
    if autoAttackEnabled then
        while wait(Delay) do
            FireRemoteEventWithNearestPlayer()
        end
    end
end)
