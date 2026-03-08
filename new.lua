local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "UltraGodHub"

--====================--
-- SETTINGS
--====================--
local LOGO = "rbxassetid://YOUR_LOGO_ID" -- replace with your logo
local VALID_KEYS = {
    ["MEGA123"] = nil,
    ["PREMIUM777"] = nil,
    ["OWNER999"] = nil,
	["PREDI133"] = nil,
	["GRABER51633"] =nil
}
local unlocked = false

--====================--
-- LOADING SCREEN
--====================--
local loading = Instance.new("Frame", gui)
loading.Size = UDim2.new(1,0,1,0)
loading.BackgroundColor3 = Color3.fromRGB(10,10,30)

local logo = Instance.new("ImageLabel", loading)
logo.Size = UDim2.new(0,200,0,200)
logo.Position = UDim2.new(.5,-100,.35,-100)
logo.BackgroundTransparency = 1
logo.Image = LOGO

local loadingText = Instance.new("TextLabel", loading)
loadingText.Size = UDim2.new(1,0,0,50)
loadingText.Position = UDim2.new(0,0,.65,0)
loadingText.Text = "🌟 Loading ULTRA GOD HUB..."
loadingText.TextScaled = true
loadingText.TextColor3 = Color3.fromRGB(0,255,255)
loadingText.BackgroundTransparency = 1

task.wait(2)
loading:Destroy()

--====================--
-- KEY SYSTEM
--====================--
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0,320,0,180)
keyFrame.Position = UDim2.new(.5,-160,.5,-90)
keyFrame.BackgroundColor3 = Color3.fromRGB(35,0,80)

local title = Instance.new("TextLabel", keyFrame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "🔑 Enter Premium Key"
title.TextScaled = true
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0,255,255)

local box = Instance.new("TextBox", keyFrame)
box.Size = UDim2.new(.8,0,0,40)
box.Position = UDim2.new(.1,0,.4,0)
box.PlaceholderText = "Type Key Here"
box.BackgroundColor3 = Color3.fromRGB(50,0,120)
box.TextColor3 = Color3.new(1,1,1)

local submit = Instance.new("TextButton", keyFrame)
submit.Size = UDim2.new(.6,0,0,40)
submit.Position = UDim2.new(.2,0,.7,0)
submit.Text = "Unlock"
submit.BackgroundColor3 = Color3.fromRGB(0,200,255)

--====================--
-- HUB PANEL
--====================--
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0,460,0,320)
hub.Position = UDim2.new(.5,-230,.5,-160)
hub.BackgroundColor3 = Color3.fromRGB(20,20,70)
hub.Visible = false

local hubTitle = Instance.new("TextLabel", hub)
hubTitle.Size = UDim2.new(1,0,0,40)
hubTitle.Text = "🌌 ULTRA GOD HUB"
hubTitle.TextScaled = true
hubTitle.BackgroundColor3 = Color3.fromRGB(0,150,255)
hubTitle.TextColor3 = Color3.fromRGB(255,255,255)

local closeBtn = Instance.new("TextButton", hub)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-30,0,0)
closeBtn.Text = "❌"
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local minBtn = Instance.new("TextButton", hub)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-60,0,0)
minBtn.Text = "➖"
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	hub.Size = UDim2.new(0,460,0, minimized and 40 or 320)
end)

--====================--
-- FIXED DRAG SYSTEM
--====================--
local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	hub.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

hub.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = hub.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

hub.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

--====================--
-- TABS
--====================--
local tabs = {}
local tabNames = {"⚡Movement","🛸Teleport","🕹Fun","🤣Troll","👑Owner"}
local tabButtons = {}

for i,name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", hub)
	btn.Size = UDim2.new(0,80,0,30)
	btn.Position = UDim2.new(0,20 + (i-1)*90,0,50)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
	table.insert(tabButtons,btn)
	
	local tabFrame = Instance.new("Frame", hub)
	tabFrame.Size = UDim2.new(1,-20,1,-90)
	tabFrame.Position = UDim2.new(0,10,0,90)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = false
	tabs[name] = tabFrame
	
	btn.MouseButton1Click:Connect(function()
		for _,v in pairs(tabs) do v.Visible=false end
		tabFrame.Visible=true
	end)
end

--====================--
-- COMMAND CREATOR
--====================--
local function createCmd(frame,text,emoji,x,y,func)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0,160,0,35)
	btn.Position = UDim2.new(0,x,0,y)
	btn.Text = emoji.." "..text
	btn.BackgroundColor3 = Color3.fromRGB(0,255,200)
	btn.MouseButton1Click:Connect(func)
end

-- Movement
createCmd(tabs["⚡Movement"],"Super Speed","⚡",10,10,function()
	player.Character.Humanoid.WalkSpeed=60
end)
createCmd(tabs["⚡Movement"],"Mega Jump","🦘",10,55,function()
	player.Character.Humanoid.JumpPower=120
end)

-- Fun
createCmd(tabs["🕹Fun"],"Spin","🌀",10,10,function()
	local hrp=player.Character.HumanoidRootPart
	for i=1,100 do
		hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(10),0)
		task.wait(0.01)
	end
end)
createCmd(tabs["🕹Fun"],"Dance","💃",10,55,function()
	local hrp=player.Character.HumanoidRootPart
	for i=1,60 do
		hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(20),0)
		task.wait(0.05)
	end
end)

-- Teleport
local teleportTab = tabs["🛸Teleport"]
local spawn1, spawn2 = nil, nil

createCmd(teleportTab,"Set Spawn 1","📌",10,10,function()
    spawn1 = player.Character.HumanoidRootPart.Position
end)
createCmd(teleportTab,"Set Spawn 2","📌",10,55,function()
    spawn2 = player.Character.HumanoidRootPart.Position
end)
createCmd(teleportTab,"TP To Spawn 1","🛸",200,10,function()
    if spawn1 then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(spawn1 + Vector3.new(0,3,0))
    end
end)
createCmd(teleportTab,"TP To Spawn 2","🛸",200,55,function()
    if spawn2 then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(spawn2 + Vector3.new(0,3,0))
    end
end)
createCmd(teleportTab,"TP To Player","👤",10,100,function()
    local players = {}
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(players,p)
        end
    end
    if #players>0 then
        player.Character.HumanoidRootPart.CFrame = players[1].Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
    end
end)

-- Troll and Owner tabs placeholders
createCmd(tabs["🤣Troll"],"Troll Cmd 1","🤣",10,10,function() print("Troll!") end)
createCmd(tabs["👑Owner"],"Owner Cmd 1","👑",10,10,function() print("Owner!") end)

--====================--
-- KEY CHECK
--====================--
submit.MouseButton1Click:Connect(function()
	local entered = box.Text
	if VALID_KEYS[entered]==nil then
		VALID_KEYS[entered]=player.UserId
	end
	if VALID_KEYS[entered]==player.UserId then
		unlocked=true
		keyFrame:Destroy()
		hub.Visible=true
	else
		box.Text="❌ Used / Wrong Key!"
	end
end)

--====================--
-- RESPAWN SAFE
--====================--
player.CharacterAdded:Connect(function()
	task.wait(1)
	if unlocked then hub.Visible=true end
end)
