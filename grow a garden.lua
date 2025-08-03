-- Ultimate Grow a Garden Pet Dupe Script v3.0
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Ultimate Pet Dupe - Grow a Garden"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local PetList = Instance.new("ScrollingFrame")
PetList.Size = UDim2.new(0.9, 0, 0.5, 0)
PetList.Position = UDim2.new(0.05, 0, 0.2, 0)
PetList.BackgroundTransparency = 0.4
PetList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PetList.CanvasSize = UDim2.new(0, 0, 0, 0)
PetList.ScrollBarThickness = 8
PetList.Parent = Frame

local DupeButton = Instance.new("TextButton")
DupeButton.Size = UDim2.new(0.35, 0, 0.1, 0)
DupeButton.Position = UDim2.new(0.1, 0, 0.75, 0)
DupeButton.Text = "Dupe Selected Pet"
DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
DupeButton.TextScaled = true
DupeButton.Parent = Frame

local MultiDupeButton = Instance.new("TextButton")
MultiDupeButton.Size = UDim2.new(0.35, 0, 0.1, 0)
MultiDupeButton.Position = UDim2.new(0.55, 0, 0.75, 0)
MultiDupeButton.Text = "Multi-Dupe (x5)"
MultiDupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiDupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
MultiDupeButton.TextScaled = true
MultiDupeButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0.88, 0)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextScaled = true
StatusLabel.Parent = Frame

-- Draggable Frame
local dragging, dragInput, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Variables
local selectedPet = nil
local dupeAttempts = 0
local maxAttempts = 5

-- Anti-Detection (Basic Obfuscation)
local function obfuscateArgs(args)
    local newArgs = {}
    for i, v in pairs(args) do
        newArgs[i] = tostring(v) .. "_" .. HttpService:GenerateGUID(false):sub(1, 4)
    end
    return newArgs
end

-- Update Pet List
local function updatePetList()
    PetList.CanvasSize = UDim2.new(0, 0, 0, 0)
    for _, v in pairs(PetList:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
    
    local petInventory = LocalPlayer:FindFirstChild("PetInventory")
    if petInventory then
        local yOffset = 0
        for _, pet in pairs(petInventory:GetChildren()) do
            local PetButton = Instance.new("TextButton")
            PetButton.Size = UDim2.new(1, -10, 0, 40)
            PetButton.Position = UDim2.new(0, 5, 0, yOffset)
            PetButton.Text = pet.Name .. " (ID: " .. (pet.Value or "N/A") .. ")"
            PetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PetButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            PetButton.TextScaled = true
            PetButton.Parent = PetList
            PetButton.MouseButton1Click:Connect(function()
                selectedPet = pet
                StatusLabel.Text = "Status: Selected " .. pet.Name
            end)
            yOffset = yOffset + 45
        end
        PetList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    else
        StatusLabel.Text = "Status: PetInventory not found"
    end
end

-- Single Dupe Function
local function dupePet()
    if not selectedPet then
        StatusLabel.Text = "Status: No pet selected!"
        return
    end
    
    local success, err = pcall(function()
        local args = {
            [1] = selectedPet.Name,
            [2] = HttpService:GenerateGUID(false),
            [3] = selectedPet.Value or "Unknown"
        }
        args = obfuscateArgs(args)
        ReplicatedStorage:WaitForChild("Events"):WaitForChild("DupePet"):FireServer(unpack(args))
    end)
    
    dupeAttempts = dupeAttempts + 1
    if success then
        StatusLabel.Text = "Status: Dupe attempt " .. dupeAttempts .. " for " .. selectedPet.Name
    else
        StatusLabel.Text = "Status: Dupe failed - " .. tostring(err)
    end
end

-- Multi-Dupe Function
local function multiDupe()
    if not selectedPet then
        StatusLabel.Text = "Status: No pet selected!"
        return
    end
    
    for i = 1, maxAttempts do
        local success, err = pcall(function()
            local args = {
                [1] = selectedPet.Name,
                [2] = HttpService:GenerateGUID(false),
                [3] = selectedPet.Value or "Unknown"
            }
            args = obfuscateArgs(args)
            ReplicatedStorage:WaitForChild("Events"):WaitForChild("DupePet"):FireServer(unpack(args))
        end)
        
        dupeAttempts = dupeAttempts + 1
        if success then
            StatusLabel.Text = "Status: Multi-Dupe " .. i .. "/" .. maxAttempts .. " for " .. selectedPet.Name
        else
            StatusLabel.Text = "Status: Multi-Dupe failed - " .. tostring(err)
            break
        end
        wait(0.5) -- Delay to avoid server overload
    end
end

-- Button Connections
DupeButton.MouseButton1Click:Connect(dupePet)
MultiDupeButton.MouseButton1Click:Connect(multiDupe)

-- Auto-Update Pet List
spawn(function()
    while wait(3) do
        updatePetList()
    end
end)

-- Hotkey for Toggling GUI (Ctrl + G)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        ScreenGui.Enabled = not ScreenGui.Enabled
        StatusLabel.Text = ScreenGui.Enabled and "Status: GUI Enabled" or "Status: GUI Hidden"
    end
end)

-- Anti-AFK
spawn(function()
    while wait(60) do
        game:GetService("VirtualUser"):CaptureController()
    end
end)

-- Initial Setup
updatePetList()
print("Ultimate Grow a Garden Pet Dupe Script v3.0 Loaded")
