-- Ultimate Grow a Garden Pet Dupe Script v6.0
-- Raw URL (hypothetical): https://raw.githubusercontent.com/AnonUser123/GrowAGardenDupeScript/main/pet-dupe-v6.lua
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 550, 0, 450)
Frame.Position = UDim2.new(0.5, -275, 0.5, -225)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 4
Frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "Ultimate Pet Dupe - Grow a Garden v6.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local PetList = Instance.new("ScrollingFrame")
PetList.Size = UDim2.new(0.9, 0, 0.35, 0)
PetList.Position = UDim2.new(0.05, 0, 0.15, 0)
PetList.BackgroundTransparency = 0.2
PetList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PetList.CanvasSize = UDim2.new(0, 0, 0, 0)
PetList.ScrollBarThickness = 12
PetList.Parent = Frame

local PetInfo = Instance.new("TextLabel")
PetInfo.Size = UDim2.new(0.9, 0, 0.2, 0)
PetInfo.Position = UDim2.new(0.05, 0, 0.52, 0)
PetInfo.Text = "Selected Pet: None\nWeight: N/A\nAge: N/A\nID: N/A"
PetInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
PetInfo.BackgroundTransparency = 0.3
PetInfo.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PetInfo.TextScaled = true
PetInfo.TextWrap = true
PetInfo.Font = Enum.Font.SourceSans
PetInfo.Parent = Frame

local DupeButton = Instance.new("TextButton")
DupeButton.Size = UDim2.new(0.28, 0, 0.1, 0)
DupeButton.Position = UDim2.new(0.05, 0, 0.75, 0)
DupeButton.Text = "Dupe Selected Pet"
DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
DupeButton.TextScaled = true
DupeButton.Parent = Frame

local MultiDupeButton = Instance.new("TextButton")
MultiDupeButton.Size = UDim2.new(0.28, 0, 0.1, 0)
MultiDupeButton.Position = UDim2.new(0.36, 0, 0.75, 0)
MultiDupeButton.Text = "Multi-Dupe (x5)"
MultiDupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiDupeButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
MultiDupeButton.TextScaled = true
MultiDupeButton.Parent = Frame

local DebugButton = Instance.new("TextButton")
DebugButton.Size = UDim2.new(0.28, 0, 0.1, 0)
DebugButton.Position = UDim2.new(0.67, 0, 0.75, 0)
DebugButton.Text = "Debug Pet Data"
DebugButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DebugButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
DebugButton.TextScaled = true
DebugButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
StatusLabel.Position = UDim2.new(0.05, 0, 0.87, 0)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.SourceSans
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
local possibleEvents = {"DupePet", "PetDupe", "ClonePet", "ReplicatePet"} -- Fallback event names

-- Anti-Detection (Dynamic Obfuscation)
local function obfuscateArgs(args)
    local newArgs = {}
    for i, v in pairs(args) do
        newArgs[i] = tostring(v) .. "_" .. HttpService:GenerateGUID(false):sub(1, 10)
    end
    return newArgs
end

-- Find Valid Dupe Event
local function findDupeEvent()
    local events = ReplicatedStorage:WaitForChild("Events", 5)
    if not events then return nil end
    for _, eventName in pairs(possibleEvents) do
        local event = events:FindFirstChild(eventName)
        if event then
            StatusLabel.Text = "Status: Found event " .. eventName
            return event
        end
    end
    return nil
end

-- Update Pet List with Name, Weight, Age, and ID
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
            -- Attempt to retrieve pet attributes (flexible property names)
            local weight = pet:FindFirstChild("Weight") and pet.Weight.Value or
                           pet:FindFirstChild("PetWeight") and pet.PetWeight.Value or "Unknown"
            local age = pet:FindFirstChild("Age") and pet.Age.Value or
                        pet:FindFirstChild("PetAge") and pet.PetAge.Value or "Unknown"
            local petId = pet:FindFirstChild("Value") and pet.Value or pet.Name
            local petButton = Instance.new("TextButton")
            petButton.Size = UDim2.new(1, -10, 0, 70)
            petButton.Position = UDim2.new(0, 5, 0, yOffset)
            petButton.Text = pet.Name .. "\nWeight: " .. tostring(weight) .. " | Age: " .. tostring(age) .. " | ID: " .. tostring(petId)
            petButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            petButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            petButton.TextScaled = true
            petButton.TextWrap = true
            petButton.Font = Enum.Font.SourceSans
            petButton.Parent = PetList
            petButton.MouseButton1Click:Connect(function()
                selectedPet = pet
                PetInfo.Text = "Selected Pet: " .. pet.Name .. "\nWeight: " .. tostring(weight) .. "\nAge: " .. tostring(age) .. "\nID: " .. tostring(petId)
                StatusLabel.Text = "Status: Selected " .. pet.Name
            end)
            yOffset = yOffset + 75
        end
        PetList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    else
        StatusLabel.Text = "Status: PetInventory not found"
        PetInfo.Text = "Selected Pet: None\nWeight: N/A\nAge: N/A\nID: N/A"
    end
end

-- Debug Pet Data
local function debugPetData()
    if not selectedPet then
        StatusLabel.Text = "Status: No pet selected for debugging!"
        return
    end
    local debugInfo = "Debug Info for " .. selectedPet.Name .. ":\n"
    for _, child in pairs(selectedPet:GetChildren()) do
        debugInfo = debugInfo .. child.Name .. ": " .. tostring(child.Value or "N/A") .. "\n"
    end
    StatusLabel.Text = "Status: Debug info printed to console"
    print(debugInfo)
end

-- Single Dupe Function
local function dupePet()
    if not selectedPet then
        StatusLabel.Text = "Status: No pet selected!"
        return
    end
    
    local dupeEvent = findDupeEvent()
    if not dupeEvent then
        StatusLabel.Text = "Status: No valid dupe event found!"
        return
    end
    
    local success, err = pcall(function()
        local args = {
            [1] = selectedPet.Name,
            [2] = HttpService:GenerateGUID(false),
            [3] = selectedPet.Value or selectedPet.Name
        }
        args = obfuscateArgs(args)
        dupeEvent:FireServer(unpack(args))
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
    
    local dupeEvent = findDupeEvent()
    if not dupeEvent then
        StatusLabel.Text = "Status: No valid dupe event found!"
        return
    end
    
    for i = 1, maxAttempts do
        local success, err = pcall(function()
            local args = {
                [1] = selectedPet.Name,
                [2] = HttpService:GenerateGUID(false),
                [3] = selectedPet.Value or selectedPet.Name
            }
            args = obfuscateArgs(args)
            dupeEvent:FireServer(unpack(args))
        end)
        
        dupeAttempts = dupeAttempts + 1
        if success then
            StatusLabel.Text = "Status: Multi-Dupe " .. i .. "/" .. maxAttempts .. " for " .. selectedPet.Name
        else
            StatusLabel.Text = "Status: Multi-Dupe failed - " .. tostring(err)
            break
        end
        wait(math.random(0.15, 0.25)) -- Randomized delay
    end
end

-- Button Connections
DupeButton.MouseButton1Click:Connect(dupePet)
MultiDupeButton.MouseButton1Click:Connect(multiDupe)
DebugButton.MouseButton1Click:Connect(debugPetData)

-- Auto-Update Pet List
spawn(function()
    while wait(1) do
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
    while wait(15) do
        VirtualUser:CaptureController()
    end
end)

-- Initial Setup
updatePetList()
print("Ultimate Grow a Garden Pet Dupe Script v6.0 Loaded")
