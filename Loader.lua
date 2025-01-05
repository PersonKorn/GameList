-- Services
local HttpService = game:GetService("HttpService") -- For making HTTP requests
local Players = game:GetService("Players") -- Player service for UI placement

-- Variables
local player = Players.LocalPlayer -- Reference to the local player
local playerGui = player:WaitForChild("PlayerGui") -- Access player's GUI
local gameId = game.PlaceId -- Get the game's PlaceId
local urls = {
    [3226555017] = "https://raw.githubusercontent.com/PersonKorn/GameList/refs/heads/main/GameOne", -- Site Roleplay
    [13772394625] = "https://raw.githubusercontent.com/PersonKorn/GameList/refs/heads/main/GameTwo" -- URL for GameTwo
}

-- UI Creation
local screenGui = Instance.new("ScreenGui") -- Create a ScreenGui
screenGui.Name = "PersonKornUI"
screenGui.Parent = playerGui -- Parent it to PlayerGui

local frame = Instance.new("Frame") -- Create a Frame
frame.AnchorPoint = Vector2.new(0.5, 0.5) -- Center the frame
frame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Center of the screen
frame.Size = UDim2.new(0.3, 0, 0.2, 0) -- Size of the frame
frame.BackgroundColor3 = Color3.new(0, 0, 0) -- Black background
frame.BackgroundTransparency = 0.5 -- Semi-transparent
frame.BorderSizePixel = 0 -- No border
frame.Parent = screenGui -- Parent the frame to the ScreenGui

local textLabel = Instance.new("TextLabel") -- Create a TextLabel
textLabel.Size = UDim2.new(1, 0, 1, 0) -- Same size as the frame
textLabel.BackgroundTransparency = 1 -- Fully transparent background
textLabel.Text = "PersonKorn Scripts" -- Set the text
textLabel.TextColor3 = Color3.new(1, 1, 1) -- White text
textLabel.TextScaled = true -- Scale the text to fit
textLabel.Font = Enum.Font.SourceSans -- Set the font
textLabel.Parent = frame -- Parent the text label to the frame

-- Function to load external script based on GameID
local function loadGameScript(gameId)
    local url = urls[gameId] -- Check if the GameID exists in the URLs table
    if url then
        print("Loading script from:", url) -- Debug message
        local success, response = pcall(function()
            return HttpService:GetAsync(url) -- Fetch the script from the URL
        end)

        if success then
            print("Script loaded successfully.")
            local loadedScript = loadstring(response) -- Load the script
            if loadedScript then
                loadedScript() -- Execute the loaded script
            end
        else
            warn("Failed to load script from URL:", response) -- Log error
        end
    else
        warn("GameID not recognized. No script to load.") -- Log if GameID doesn't match
    end
end

-- Load the script for the current GameID
loadGameScript(gameId)
