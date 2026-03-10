--// Initialization & Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

--// Cleanup
local existing = game:GetService("CoreGui"):FindFirstChild("Slate_Master") or LP.PlayerGui:FindFirstChild("Slate_Master")
if existing then existing:Destroy() end

local gui = Instance.new("ScreenGui", (game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")))
gui.Name = "Slate_Master"
gui.ResetOnSpawn = false 

--// Main UI Frame
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 620, 0, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
Main.BorderSizePixel = 0
Main.Active = true

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 12)

-- Rainbow Border Glow
local Glow = Instance.new("UIStroke", Main)
Glow.Thickness = 2.5
Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
task.spawn(function()
    while task.wait() do Glow.Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end
end)

--// Smooth Dragging Logic
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

--// Tab Navigation Logic
local Sections = {
    Scripts = Instance.new("ScrollingFrame", Main),
    Player = Instance.new("ScrollingFrame", Main),
    World = Instance.new("ScrollingFrame", Main),
    Games = Instance.new("ScrollingFrame", Main)
}

local function SetupSection(frame)
    frame.Size = UDim2.new(1, -180, 1, -100)
    frame.Position = UDim2.new(0, 170, 0, 60)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.ScrollBarThickness = 0
    local l = Instance.new("UIGridLayout", frame)
    l.CellSize = UDim2.new(0, 140, 0, 45)
    l.CellPadding = UDim2.new(0, 10, 0, 10)
end

for _, v in pairs(Sections) do SetupSection(v) end
Sections.Scripts.Visible = true

local function ShowSection(name)
    for k, v in pairs(Sections) do v.Visible = (k == name) end
end

--// Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -100)
Sidebar.Position = UDim2.new(0, 10, 0, 60)
Sidebar.BackgroundTransparency = 1

local function Tab(name, pos)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Position = UDim2.new(0, 0, 0, pos)
    b.Text = name:upper()
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() ShowSection(name) end)
end

Tab("Scripts", 0)
Tab("Player", 50)
Tab("World", 100)
Tab("Games", 150)

--// Script Loader
local function AddMod(section, name, url)
    local b = Instance.new("TextButton", Sections[section])
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 11
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet(url))() end) end)
end

--// Scripts Section
AddMod("Scripts", "Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
AddMod("Scripts", "Dex Explorer", "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
AddMod("Scripts", "V.G Hub", "https://raw.githubusercontent.com/1201n/V.G-Hub/main/V.G%20Hub")
AddMod("Scripts", "SimpleSpy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua")

--// Player Section
AddMod("Player", "Unnamed ESP", "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua")
AddMod("Player", "Fly GUI V3", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
AddMod("Player", "Auto Clicker", "https://pastebin.com/raw/V6P9T6sR")

--// World Section
AddMod("World", "Fullbright", "https://pastebin.com/raw/06mZ609Z")
AddMod("World", "Server Hopper", "https://raw.githubusercontent.com/L9szvE3M/ServerHop/main/Script.lua")
AddMod("World", "Anti-AFK", "https://raw.githubusercontent.com/Knoot04/Roblox-Anti-AFK/main/Script.lua")

--// Games Section (New!)
AddMod("Games", "Blox Fruits", "https://raw.githubusercontent.com/RealZis/Zis_Hub/main/Main.lua")
AddMod("Games", "Brookhaven", "https://raw.githubusercontent.com/IceBear-Hub/IceBear-Hub/main/IceBear-Hub.lua")
AddMod("Games", "Pet Sim 99", "https://raw.githubusercontent.com/si1nnx/PetSim99/main/Gui.lua")
AddMod("Games", "Arsenal", "https://raw.githubusercontent.com/PlusGiant5/Arsenal/main/Script.lua")
AddMod("Games", "Doors Hub", "https://raw.githubusercontent.com/shlexware/Rayfield/main/source")

--// Status Bar
local StatusBar = Instance.new("Frame", Main)
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 1, -40)
StatusBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Instance.new("UICorner", StatusBar)

local StatText = Instance.new("TextLabel", StatusBar)
StatText.Size = UDim2.new(1, -20, 1, 0)
StatText.Position = UDim2.new(0, 10, 0, 0)
StatText.BackgroundTransparency = 1
StatText.TextColor3 = Color3.fromRGB(180, 180, 180)
StatText.Font = Enum.Font.Code
StatText.TextSize = 11
StatText.TextXAlignment = Enum.TextXAlignment.Left

RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1/dt)
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    StatText.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms | MRD MASTER ACTIVE"
end)

--// Minimize & Close
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -45, 0, 10)
Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(180, 40, 40); Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
Close.MouseButton1Click:Connect(function() gui:Destroy() end)

local Mini = Instance.new("TextButton", Main)
Mini.Size = UDim2.new(0, 35, 0, 35)
Mini.Position = UDim2.new(1, -90, 0, 10)
Mini.Text = "-"; Mini.BackgroundColor3 = Color3.fromRGB(50, 50, 60); Mini.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Mini).CornerRadius = UDim.new(1, 0)

local Restore = Instance.new("TextButton", gui)
Restore.Size = UDim2.new(0, 55, 0, 55)
Restore.Position = UDim2.new(0, 20, 1, -85)
Restore.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
Restore.Text = "MRD"; Restore.TextColor3 = Color3.new(1, 1, 1); Restore.Visible = false
Restore.Font = Enum.Font.GothamBold; Restore.TextSize = 13
Instance.new("UICorner", Restore).CornerRadius = UDim.new(1, 0)
local ResStroke = Instance.new("UIStroke", Restore); ResStroke.Color = Color3.fromRGB(68, 136, 255); ResStroke.Thickness = 3

Mini.MouseButton1Click:Connect(function() Main.Visible = false; Restore.Visible = true end)
Restore.MouseButton1Click:Connect(function() Main.Visible = true; Restore.Visible = false end)

print("Master Edition Loaded. Enjoy.")
