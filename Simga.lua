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
local attacking = false
local targetPlayer = nil
local Distance = 20
local TicksPerSecond = 0.03

local function AttackPlayer(target)
    local args = {
        [1] = target.Character
    }

    game:GetService("ReplicatedStorage"):FindFirstChild("events-ZLx"):FindFirstChild("4353f763-a392-484a-9430-e57e96530e32"):FireServer(unpack(args))
end

local function FindNearestPlayer()
    local nearestPlayer = nil
    local nearestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= Distance and distance < nearestDistance then
                nearestPlayer = player
                nearestDistance = distance
            end
        end
    end

    return nearestPlayer
end

local function UpdateTarget()
    local nearestPlayer = FindNearestPlayer()
    if nearestPlayer and nearestPlayer ~= targetPlayer then
        targetPlayer = nearestPlayer
    end
end

Section:NewToggle("Killaura", "Attack Nearest Player", function(state)
    attacking = state

    if attacking then
        while attacking do
            UpdateTarget()

            if targetPlayer and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
                AttackPlayer(targetPlayer)
            end

            wait(TicksPerSecond)
        end
    else
        targetPlayer = nil
    end
end)

Section:NewSlider("TicksPerSecond", "Attack Speed Per Sec", 0.03, -5, function(val)
    TicksPerSecond = val
end)
