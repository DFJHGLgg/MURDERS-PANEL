--// Initialization & Services
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")

--// CONFIGURATION
local DECAL_ID = "80954728278584" 
local LOGO_IMAGE = "rbxthumb://type=Asset&id=" .. DECAL_ID .. "&w=420&h=420"
--// CONFIGURATION
local DECAL_ID = "80954728278584" 
local LOGO_IMAGE = "rbxthumb://type=Asset&id=" .. DECAL_ID .. "&w=420&h=420"

-- You can add as many keys as you want to this list!
local KEYS = {
    ["SLATE-13222"] = true,
    ["SLATE-PAID-4343"] = true,
}

--// Cleanup
local existing = game:GetService("CoreGui"):FindFirstChild("Slate_Neural_Final") or LP.PlayerGui:FindFirstChild("Slate_Neural_Final")
if existing then existing:Destroy() end

local gui = Instance.new("ScreenGui", (game:GetService("CoreGui") or LP:WaitForChild("PlayerGui")))
gui.Name = "Slate_Neural_Final"
gui.ResetOnSpawn = false 

--// [1] LOADING SCREEN & KEY UI
local Loader = Instance.new("Frame", gui)
Loader.Size = UDim2.new(0, 320, 0, 380)
Loader.Position = UDim2.new(0.5, -160, 0.5, -190)
Loader.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
Loader.BorderSizePixel = 0
Instance.new("UICorner", Loader).CornerRadius = UDim.new(0, 15)

local LoadLogo = Instance.new("ImageLabel", Loader)
LoadLogo.Size = UDim2.new(0, 100, 0, 100)
LoadLogo.Position = UDim2.new(0.5, -50, 0, 40)
LoadLogo.BackgroundTransparency = 1
LoadLogo.Image = LOGO_IMAGE

local LoadTitle = Instance.new("TextLabel", Loader)
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.Position = UDim2.new(0, 0, 0, 150)
LoadTitle.Text = "NEURAL SYSTEMS"
LoadTitle.TextColor3 = Color3.new(1, 1, 1)
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextSize = 18
LoadTitle.BackgroundTransparency = 1

local BarBack = Instance.new("Frame", Loader)
BarBack.Size = UDim2.new(0, 220, 0, 4)
BarBack.Position = UDim2.new(0.5, -110, 0, 200)
BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Instance.new("UICorner", BarBack)

local BarFill = Instance.new("Frame", BarBack)
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", BarFill)

local KeyFrame = Instance.new("Frame", Loader)
KeyFrame.Size = UDim2.new(1, 0, 0, 120)
KeyFrame.Position = UDim2.new(0, 0, 0, 220)
KeyFrame.BackgroundTransparency = 1
KeyFrame.Visible = false

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 220, 0, 40)
KeyInput.Position = UDim2.new(0.5, -110, 0, 10)
KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyInput.PlaceholderText = "Enter Access Key..."
KeyInput.TextColor3 = Color3.new(1, 1, 1); KeyInput.Text = ""
KeyInput.Font = Enum.Font.Gotham; KeyInput.TextSize = 12
Instance.new("UICorner", KeyInput)

local Submit = Instance.new("TextButton", KeyFrame)
Submit.Size = UDim2.new(0, 220, 0, 40)
Submit.Position = UDim2.new(0.5, -110, 0, 60)
Submit.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Submit.Text = "AUTHENTICATE"
Submit.TextColor3 = Color3.new(1, 1, 1)
Submit.Font = Enum.Font.GothamBold; Submit.TextSize = 12
Instance.new("UICorner", Submit)

--// [2] MAIN PANEL
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 620, 0, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
Main.Visible = false
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Glow = Instance.new("UIStroke", Main)
Glow.Thickness = 2.5
Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
task.spawn(function()
    while task.wait() do Glow.Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1) end
end)

local Nav = Instance.new("Frame", Main)
Nav.Size = UDim2.new(1, 0, 0, 80)
Nav.BackgroundTransparency = 1

local Logo = Instance.new("ImageLabel", Nav)
Logo.Size = UDim2.new(0, 65, 0, 65)
Logo.Position = UDim2.new(0, 15, 0.5, -32)
Logo.BackgroundTransparency = 1
Logo.Image = LOGO_IMAGE

local Title = Instance.new("TextLabel", Nav)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 95, 0, 0)
Title.Text = "SLATE <font color='#ffffff'>NEURAL</font>"
Title.RichText = true; Title.TextColor3 = Color3.fromRGB(180, 190, 210)
Title.Font = Enum.Font.GothamBold; Title.TextSize = 20; Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

--// [3] TAB SYSTEM & SIDEBAR
local Sections = {
    Scripts = Instance.new("ScrollingFrame", Main),
    Player = Instance.new("ScrollingFrame", Main),
    World = Instance.new("ScrollingFrame", Main),
    Games = Instance.new("ScrollingFrame", Main)
}

local function SetupSection(frame)
    frame.Size = UDim2.new(1, -180, 1, -140)
    frame.Position = UDim2.new(0, 170, 0, 90)
    frame.BackgroundTransparency = 1; frame.Visible = false; frame.ScrollBarThickness = 0
    local l = Instance.new("UIGridLayout", frame)
    l.CellSize = UDim2.new(0, 140, 0, 45); l.CellPadding = UDim2.new(0, 10, 0, 10)
end

for _, v in pairs(Sections) do SetupSection(v) end
Sections.Scripts.Visible = true

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -130); Sidebar.Position = UDim2.new(0, 10, 0, 90); Sidebar.BackgroundTransparency = 1

local function Tab(name, pos)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 40); b.Position = UDim2.new(0, 0, 0, pos)
    b.Text = name:upper(); b.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 11
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for k,v in pairs(Sections) do v.Visible = (k == name) end end)
end

Tab("Scripts", 0); Tab("Player", 50); Tab("World", 100); Tab("Games", 150)

--// [4] SCRIPT LOADER & CONTENT (RESTORED ALL SCRIPTS)
local function AddMod(section, name, url)
    local b = Instance.new("TextButton", Sections[section])
    b.Text = name; b.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
    b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamMedium; b.TextSize = 11
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet(url))() end) end)
end

AddMod("Scripts", "Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
AddMod("Scripts", "Dex Explorer", "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
AddMod("Scripts", "V.G Hub", "https://raw.githubusercontent.com/1201n/V.G-Hub/main/V.G%20Hub")
AddMod("Scripts", "SimpleSpy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua")
AddMod("Player", "Unnamed ESP", "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua")
AddMod("Player", "Fly GUI V3", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
AddMod("World", "Fullbright", "https://pastebin.com/raw/06mZ609Z")
AddMod("World", "Server Hopper", "https://raw.githubusercontent.com/L9szvE3M/ServerHop/main/Script.lua")
AddMod("Games", "Blox Fruits", "https://raw.githubusercontent.com/RealZis/Zis_Hub/main/Main.lua")
AddMod("Games", "Pet Sim 99", "https://raw.githubusercontent.com/si1nnx/PetSim99/main/Gui.lua")

--// [5] STATUS BAR (RESTORED)
local StatusBar = Instance.new("Frame", Main)
StatusBar.Size = UDim2.new(1, -20, 0, 30); StatusBar.Position = UDim2.new(0, 10, 1, -40)
StatusBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24); Instance.new("UICorner", StatusBar)

local StatText = Instance.new("TextLabel", StatusBar)
StatText.Size = UDim2.new(1, -20, 1, 0); StatText.Position = UDim2.new(0, 10, 0, 0)
StatText.BackgroundTransparency = 1; StatText.TextColor3 = Color3.fromRGB(150, 160, 180)
StatText.Font = Enum.Font.Code; StatText.TextSize = 10; StatText.TextXAlignment = Enum.TextXAlignment.Left

RunService.RenderStepped:Connect(function(dt)
    StatText.Text = "SYSTEM: NEURAL ACTIVE | FPS: " .. math.floor(1/dt) .. " | PING: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms"
end)

--// [6] WINDOW CONTROLS (RESTORED MINI/RESTORE)
local Close = Instance.new("TextButton", Nav)
Close.Size = UDim2.new(0, 35, 0, 35); Close.Position = UDim2.new(1, -45, 0.5, -17)
Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(180, 40, 40); Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)
Close.MouseButton1Click:Connect(function() gui:Destroy() end)

local Mini = Instance.new("TextButton", Nav)
Mini.Size = UDim2.new(0, 35, 0, 35); Mini.Position = UDim2.new(1, -90, 0.5, -17)
Mini.Text = "-"; Mini.BackgroundColor3 = Color3.fromRGB(50, 50, 60); Mini.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Mini).CornerRadius = UDim.new(1, 0)

local Restore = Instance.new("TextButton", gui)
Restore.Size = UDim2.new(0, 60, 0, 60); Restore.Position = UDim2.new(0, 20, 1, -85)
Restore.BackgroundColor3 = Color3.fromRGB(10, 10, 13); Restore.Text = "NEURAL"; Restore.TextColor3 = Color3.new(1, 1, 1); Restore.Visible = false
Restore.Font = Enum.Font.GothamBold; Restore.TextSize = 10
Instance.new("UICorner", Restore).CornerRadius = UDim.new(1, 0)
local ResStroke = Instance.new("UIStroke", Restore); ResStroke.Color = Color3.fromRGB(255, 255, 255); ResStroke.Thickness = 2

Mini.MouseButton1Click:Connect(function() Main.Visible = false; Restore.Visible = true end)
Restore.MouseButton1Click:Connect(function() Main.Visible = true; Restore.Visible = false end)

--// AUTHENTICATION LOGIC
task.spawn(function()
    local Tween = TweenService:Create(BarFill, TweenInfo.new(3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 1, 0)})
    Tween:Play(); Tween.Completed:Wait()
    BarBack.Visible = false; KeyFrame.Visible = true
end)

Submit.MouseButton1Click:Connect(function()
    -- This checks if the text entered exists in our KEYS table
    if KEYS[KeyInput.Text] then
        Submit.Text = "SUCCESS"
        Submit.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
        task.wait(1)
        Loader:Destroy()
        Main.Visible = true
    else
        Submit.Text = "INVALID KEY"
        Submit.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
        task.wait(1)
        Submit.Text = "AUTHENTICATE"
        Submit.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    end
end)

--// DRAGGING
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end
end)
UIS.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
