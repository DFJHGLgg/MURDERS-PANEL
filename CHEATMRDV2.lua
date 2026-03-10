local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- Prevent duplicate GUIs
local existing = game.CoreGui:FindFirstChild("MRD_Final") or LP.PlayerGui:FindFirstChild("MRD_Final")
if existing then existing:Destroy() end

-- Use CoreGui if possible (better for exploits), otherwise PlayerGui
local Parent = game:GetService("RunService"):IsStudio() and LP.PlayerGui or (game:GetService("CoreGui") or LP.PlayerGui)

local gui = Instance.new("ScreenGui")
gui.Name = "MRD_Final"
gui.Parent = Parent
gui.ResetOnSpawn = false

--// Main Window
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 500, 0, 300)
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Standard drag logic

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 8)

--// Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "CHEAT MRD V2"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", Header)
Close.Size = UDim2.new(0, 35, 1, 0)
Close.Position = UDim2.new(1, -35, 0, 0)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.BorderSizePixel = 0
Close.Font = Enum.Font.GothamBold

Close.MouseButton1Click:Connect(function() gui:Destroy() end)

--// Scrolling Container
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 2, 0) -- Allow scrolling
Scroll.ScrollBarThickness = 4

local Layout = Instance.new("UIGridLayout", Scroll)
Layout.CellSize = UDim2.new(0, 150, 0, 40)
Layout.CellPadding = UDim2.new(0, 10, 0, 10)

--// Simple Add Function
local function Add(name, url)
    local b = Instance.new("TextButton", Scroll)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    Instance.new("UICorner", b)

    b.MouseButton1Click:Connect(function()
        print("Loading: " .. name)
        local s, e = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not s then warn("Load error: " .. e) end
    end)
end

--// Verified Script List (Stable URLs)
Add("Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
Add("Dex Explorer", "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
Add("V.G Hub", "https://raw.githubusercontent.com/1201n/V.G-Hub/main/V.G%20Hub")
Add("SimpleSpy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua")
Add("Fly GUI", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
Add("Ghost Hub", "https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub")
Add("Nameless Admin", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source")
Add("Dark Dex", "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/DarkDexV3.lua")
Add("Remote Spy", "https://raw.githubusercontent.com/78n/78n/main/RemoteSpy.lua")
Add("Speed Hub", "https://raw.githubusercontent.com/GwnJohn/John-Hub/main/John-Hub")

print("MRD LOADED SUCCESSFULLY")
