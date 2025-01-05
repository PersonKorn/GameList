local player = game.Players.LocalPlayer -- Local player
local highlightRadius = 200 -- Radius of highlighting
local classDColor = Color3.fromRGB(255, 165, 0) -- Class-D color (orange)
local chaosInsurgencyColor = Color3.fromRGB(255, 255, 255) -- Chaos Insurgency color (white)
local redColor = Color3.fromRGB(255, 0, 0) -- Red color for dangerous Class-D or Chaos with weapons
local blackColor = Color3.fromRGB(0, 0, 0) -- Color for dead players
local inventoryCheckInterval = 5 -- Interval to check inventory and hotbar

-- Tools that should trigger red highlighting
local dangerousWeapons = {"M4", "M249", "UMP_45", "Crowbar"}

-- Function to check if a player is in the radius
local function isInRadius(player1, player2)
    return (player1.HumanoidRootPart.Position - player2.HumanoidRootPart.Position).Magnitude <= highlightRadius
end

-- Function to check for dangerous weapons in the inventory or hotbar
local function hasDangerousWeapons(player)
    local dangerous = false
    local character = player.Character
    if character then
        local backpack = player.Backpack
        local hotbar = player.PlayerGui:FindFirstChild("Hotbar") -- Assume there’s a hotbar GUI

        -- Check backpack and hotbar for dangerous weapons
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and table.find(dangerousWeapons, item.Name) then
                dangerous = true
                break
            end
        end

        if hotbar then
            for _, item in ipairs(hotbar:GetChildren()) do
                if item:IsA("Tool") and table.find(dangerousWeapons, item.Name) then
                    dangerous = true
                    break
                end
            end
        end
    end
    return dangerous
end

-- Function to update the highlight color for players based on team and inventory
local function updatePlayerHighlights()
    local playerList = {} -- To store names for the right-side list
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Team then
            -- Check if within radius
            if isInRadius(player, p) then
                local highlightColor = nil
                local isDangerous = false
                -- Check team and dangerous weapons
                if p.Team.Name == "Class-D" then
                    highlightColor = classDColor
                    isDangerous = hasDangerousWeapons(p)
                elseif p.Team.Name == "Chaos Insurgency" then
                    highlightColor = chaosInsurgencyColor
                    isDangerous = false -- Chaos Insurgency isn't flagged for weapons scanning
                end

                -- Override with red color if dangerous
                if isDangerous then
                    highlightColor = redColor
                end

                -- Highlight the player (assumes you have some way to highlight players)
                -- Example: p.Character.HumanoidRootPart.BillboardGui.Color = highlightColor

                -- Add to player list on the right side
                local skullSymbol = (p.Team.Name == "Chaos Insurgency" or isDangerous) and "💀" or ""
                table.insert(playerList, string.format("%s (%s) - %s#", p.Name, p.Team.Name, skullSymbol))
            end

            -- If the player dies, change their color to black
            p.CharacterAdded:Connect(function(character)
                local humanoid = character:WaitForChild("Humanoid")
                humanoid.Died:Connect(function()
                    -- Change character color to black on death
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("MeshPart") or part:IsA("Part") then
                            part.Color = blackColor
                        end
                    end
                end)
            end)
        end
    end

    -- Update the display list with player names (Right-side list)
    -- Placeholder for list UI update (this can vary based on your GUI system)
    -- Example: someLabel.Text = table.concat(playerList, "\n")
end

-- Scan Class-D's inventory and hotbar every 5 seconds
while true do
    updatePlayerHighlights() -- Check and update highlights
    wait(inventoryCheckInterval) -- Wait before scanning again
end
