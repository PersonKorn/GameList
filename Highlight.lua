local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")

local SCAN_RADIUS = 200 -- Radius for scanning
local CLASS_D_NAME = "Class-D"
local CHAOS_INSURGENCY_NAME = "Chaos Insurgency"

local HIGHLIGHT_SETTINGS = {
    ClassD = {HighlightColor = Color3.new(1, 0.5, 0), FillColor = Color3.new(1, 0.5, 0)}, -- Orange
    Chaos = {HighlightColor = Color3.new(1, 1, 1), FillColor = Color3.new(1, 1, 1)}, -- White
    DangerousClassD = {HighlightColor = Color3.new(1, 0, 0), FillColor = Color3.new(1, 0, 0)}, -- Red
    Dead = {HighlightColor = Color3.new(0, 0, 0), FillColor = Color3.new(0, 0, 0)}, -- Black
}

local function isDangerous(item) -- Check if the item is dangerous
    return item:IsA("Tool") and (item.Name == "M4" or item.Name == "M249" or item.Name == "UMP_45" or item.Name == "Crowbar")
end

local function scanPlayer(player)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end -- Skip if character is invalid

    local isDead = character:FindFirstChild("Humanoid") and character.Humanoid.Health <= 0 -- Check if the player is dead
    if isDead then
        return "Dead"
    end

    local inventory = player:FindFirstChildOfClass("Backpack") or character -- Search in both backpack and character
    for _, item in ipairs(inventory:GetChildren()) do
        if isDangerous(item) then
            return "DangerousClassD"
        end
    end

    return "ClassD"
end

local function highlightPlayer(player, highlightType)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end -- Skip invalid characters

    local highlight = character:FindFirstChildOfClass("Highlight") or Instance.new("Highlight")
    highlight.Parent = character
    highlight.Adornee = character

    local settings = HIGHLIGHT_SETTINGS[highlightType] or {}
    highlight.FillColor = settings.FillColor or Color3.new(1, 1, 1) -- Default to white if not set
    highlight.FillTransparency = 0.95 -- Set to a high value for barely visible fill
    highlight.OutlineColor = settings.HighlightColor or Color3.new(1, 1, 1) -- Default to white if not set
    highlight.OutlineTransparency = 0.95 -- Set to a high value for barely visible outline
end

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if player ~= otherPlayer then
                    local otherCharacter = otherPlayer.Character
                    if otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart") then
                        local distance = (character.HumanoidRootPart.Position - otherCharacter.HumanoidRootPart.Position).Magnitude

                        if distance <= SCAN_RADIUS then
                            local team = otherPlayer.Team
                            if team and (team.Name == CLASS_D_NAME or team.Name == CHAOS_INSURGENCY_NAME) then
                                local highlightType = scanPlayer(otherPlayer)
                                highlightPlayer(otherPlayer, highlightType)
                            end
                        end
                    end
                end
            end
        end
    end
end)
