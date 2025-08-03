-- Grow a Garden Pet Dupe Script by Bern0va
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.5
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 50)
Title.Text = "Grow a Garden Pet Dupe"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Parent = Frame

local DupeButton = Instance.new("TextButton")
DupeButton.Size = UDim2.new(0, 100, 0, 50)
DupeButton.Position = UDim2.new(0.5, -50, 0.5, 0)
DupeButton.Text = "Dupe Pet"
DupeButton.Parent = Frame

-- Dupe Function
local function dupePet()
    local petInventory = LocalPlayer:FindFirstChild("PetInventory")
    if petInventory then
        local petData = petInventory:GetChildren()[1]
        if petData then
            local args = {
                [1] = petData.Name,
                [2] = HttpService:GenerateGUID(false)
            }
            game:GetService("ReplicatedStorage").Events.DupePet:FireServer(unpack(args))
        end
    end
end

-- Button Connection
DupeButton.MouseButton1Click:Connect(dupePet)

print("Grow a Garden Dupe Script Loaded")
