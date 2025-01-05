local player = game.Players.LocalPlayer -- Local player
local camera = game.Workspace.CurrentCamera -- Camera
local mouse = player:GetMouse() -- Mouse object
local UIS = game:GetService("UserInputService") -- To detect mouse button presses
local humanoid = player.Character and player.Character:WaitForChild("Humanoid") -- Local player's humanoid
local targetHead = nil -- Stores the player's head that the camera is locked onto
local isDead = false -- To track if the player is dead

-- Function to detect if the camera is pointing directly at a player's head
local function getPlayerHeadInSight()
    local rayOrigin = camera.CFrame.Position -- Camera position
    local rayDirection = camera.CFrame.LookVector * 1000 -- Ray direction towards where the camera is looking (forward direction)
    local ray = Ray.new(rayOrigin, rayDirection) -- Create the ray

    local hitPart, hitPosition = workspace:FindPartOnRay(ray, player.Character, false, true) -- Raycast to detect any hit

    -- Check if the hit part belongs to a player's head
    if hitPart and hitPart.Parent and hitPart.Parent:FindFirstChild("Humanoid") then
        local humanoid = hitPart.Parent.Humanoid
        local targetPlayer = game.Players:GetPlayerFromCharacter(hitPart.Parent)
        if targetPlayer and (targetPlayer.Team.Name == "Class-D" or targetPlayer.Team.Name == "Chaos Insurgency") then
            return hitPart.Parent.Head -- Return the player's head
        end
    end
    return nil -- No valid target found
end

-- Function to lock the camera to the target head
local function lockCameraToHead(head)
    if head then
        -- Set the camera to focus on the target's head position
        camera.CameraSubject = head
        camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position) -- Look at the target's head
    else
        -- Reset to normal camera behavior when no head is targeted
        camera.CameraSubject = player.Character.Humanoid
    end
end

-- Function to handle right mouse button hold and release
local function onMouseInput(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if input.UserInputState == Enum.UserInputState.Begin then
            -- Mouse button pressed, lock onto the head of the player in sight
            targetHead = getPlayerHeadInSight()
            lockCameraToHead(targetHead)
        elseif input.UserInputState == Enum.UserInputState.End then
            -- Mouse button released, reset camera to the default
            targetHead = nil
            camera.CameraSubject = player.Character.Humanoid
        end
    end
end

-- Function to handle "X" key press and reset camera if no one in FOV
local function onKeyPress(input, gameProcessed)
    if gameProcessed then return end

    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.X then
        -- If no player head is in sight, reset camera
        if not getPlayerHeadInSight() then
            targetHead = nil
            camera.CameraSubject = player.Character.Humanoid
        end
    end
end

-- Function to stop locking when the local player dies
local function onPlayerDeath()
    isDead = true
    targetHead = nil
    camera.CameraSubject = player.Character.Humanoid -- Reset camera to the local player's humanoid
end

-- Connect the mouse input to the function
UIS.InputChanged:Connect(onMouseInput)

-- Connect the keyboard input for "X" key press
UIS.InputBegan:Connect(onKeyPress)

-- Listen for local player death
if humanoid then
    humanoid.Died:Connect(onPlayerDeath)
end

-- Reset the death state if the player respawns
player.CharacterAdded:Connect(function(newCharacter)
    humanoid = newCharacter:WaitForChild("Humanoid")
    isDead = false
end)
