-- Services
local Players = game:GetService("Players")

-- Variables
local player = Players.LocalPlayer -- Reference to the local player
local playerGui = player:WaitForChild("PlayerGui") -- Access player's GUI

-- UI Creation
local screenGui = Instance.new("ScreenGui") -- Create a ScreenGui
screenGui.Name = "GameOneUI"
screenGui.Parent = playerGui -- Parent it to PlayerGui

-- Create Button
local button = Instance.new("TextButton") -- Create a button
button.Size = UDim2.new(0.1, 0, 0.05, 0) -- Size of the button
button.Position = UDim2.new(0.9, -10, 0.95, -10) -- Bottom-right corner with padding
button.AnchorPoint = Vector2.new(1, 1) -- Adjust anchor point for positioning
button.Text = "Open Frame" -- Text on the button
button.BackgroundColor3 = Color3.new(0, 0, 1) -- Blue background
button.TextColor3 = Color3.new(1, 1, 1) -- White text
button.TextScaled = true -- Scale text to fit
button.Font = Enum.Font.SourceSans -- Font
button.Parent = screenGui -- Parent button to the ScreenGui

-- Create Frame (Initially Hidden)
local frame = Instance.new("Frame") -- Create a frame
frame.Size = UDim2.new(0.3, 0, 0.3, 0) -- Frame size
frame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center of the screen
frame.AnchorPoint = Vector2.new(0.5, 0.5) -- Anchor point to center
frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
frame.BackgroundTransparency = 0.5 -- Semi-transparent
frame.Visible = false -- Initially hidden
frame.Parent = screenGui -- Parent frame to the ScreenGui

-- Button Click Event
button.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible -- Toggle frame visibility
end)
