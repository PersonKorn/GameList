local Players = game:GetService("Players") -- Get the Players service
local RunService = game:GetService("RunService") -- For frame updates
local UserInputService = game:GetService("UserInputService") -- For input detection
local LocalPlayer = Players.LocalPlayer -- Reference to the local player
local camera = workspace.CurrentCamera -- Reference to the camera

local lockKey = Enum.KeyCode.X -- The key to lock onto a target
local resetKey = Enum.KeyCode.N -- The key to reset the UI manually
local lockDistance = 200  -- Maximum distance for locking on
local lockOnTarget = nil -- Current target being locked on
local label = nil -- Reference to the label

-- Function to create the label UI
local function createLabel()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LockOnUI"
    screenGui.Parent = playerGui

    label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 300, 0, 50) -- Width: 300px, Height: 50px
    label.Position = UDim2.new(0.5, -150, 0.1, 0) -- Centered horizontally at the top
    label.BackgroundTransparency = 1 -- Transparent background
    label.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 24
    label.Text = "No one in sight"
    label.Parent = screenGui
end

-- Function to check if a player is in the camera's view
local function getPlayerInView()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team then
            if player.Team.Name == "Class-D" or player.Team.Name == "Chaos Insurgency" then
                local character = player.Character
                if character then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local screenPosition, onScreen = camera:WorldToViewportPoint(head.Position) -- Get screen position
                        local distance = (head.Position - camera.CFrame.Position).Magnitude

                        if onScreen and distance <= lockDistance then
                            -- Check if the head is close to the center of the screen
                            local viewportCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                            local headScreenPosition = Vector2.new(screenPosition.X, screenPosition.Y)
                            local distanceFromCenter = (headScreenPosition - viewportCenter).Magnitude

                            if distanceFromCenter <= 100 then -- Adjust the tolerance here
                                return player
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- Function to lock onto a target
local function lockOntoTarget(target)
    if not target then return end
    lockOnTarget = target

    local character = target.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            -- Smoothly transition the camera to focus on the target's head
            RunService:BindToRenderStep("LockOnCamera", Enum.RenderPriority.Camera.Value, function()
                local cameraCFrame = CFrame.new(camera.CFrame.Position, head.Position)
                camera.CFrame = cameraCFrame
            end)
        end
    end
end

-- Function to stop locking onto a target
local function stopLockOn()
    lockOnTarget = nil
    RunService:UnbindFromRenderStep("LockOnCamera") -- Stop adjusting the camera
end

-- Handle key press to lock onto a target
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == lockKey then
        if lockOnTarget then
            stopLockOn() -- Stop locking if already locked
            label.Text = "No one in sight"
        else
            local target = getPlayerInView() -- Get the target in view
            if target then
                lockOntoTarget(target) -- Lock onto the target
                label.Text = "Locked on to: " .. target.Name .. " (" .. target.Team.Name .. ")"
            else
                label.Text = "No one in sight"
            end
        end
    elseif input.KeyCode == resetKey then
        -- Reset the UI when "N" is pressed
        if not label then
            createLabel() -- Create label if it doesn't exist
        end
        label.Text = "No one in sight"
    end
end)

-- Clean up if the target dies or leaves
Players.PlayerRemoving:Connect(function(player)
    if player == lockOnTarget then
        stopLockOn()
        label.Text = "No one in sight"
    end
end)

-- Reset lock and recreate the label on respawn
LocalPlayer.CharacterAdded:Connect(function()
    stopLockOn() -- Reset lock if the local player's character respawns
    if not label then
        createLabel() -- Recreate label if it doesn't exist
    end
    label.Text = "No one in sight"
end)

-- Ensure label is created on first start
if not label then
    createLabel()
end
