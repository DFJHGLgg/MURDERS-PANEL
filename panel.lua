-- [[ ❗MURDERS Panel V1.Ghost PRO❗ ]] --
-- FIXED LOAD | WASD FLY | DUAL SPAWN | SPACE BLUE & RED

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Global Persistence
_G.TargetSpeed = _G.TargetSpeed or 16
_G.FlySpeed = _G.FlySpeed or 100
_G.SavedPos1 = _G.SavedPos1 or nil
_G.SavedPos2 = _G.SavedPos2 or nil
_G.GhostStates = _G.GhostStates or {Invis = false, Noclip = false, Fly = false, Spaming = false}

local function createGhostPanel()
    -- Immediate UI Creation (No waiting for character)
    local old = player.PlayerGui:FindFirstChild("MurdersGhostV7")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "MurdersGhostV7"; gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 300, 0, 440) 
    main.Position = UDim2.new(0.5, -150, 0.5, -220)
    main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    main.Draggable = true; main.Active = true; main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke", main)
    stroke.Thickness = 3; stroke.Color = Color3.fromRGB(255, 0, 0)

    -- HEADER
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, -70, 0, 40); title.Position = UDim2.new(0, 10, 0, 0)
    title.Text = "❗ MURDERS V1.GHOST"; title.TextColor3 = Color3.fromRGB(255, 0, 0)
    title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.BackgroundTransparency = 1; title.TextXAlignment = Enum.TextXAlignment.Left

    local function createTopBtn(txt, pos, color, cb)
        local b = Instance.new("TextButton", main); b.Size = UDim2.new(0, 25, 0, 25); b.Position = pos
        b.BackgroundColor3 = color; b.Text = txt; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(cb)
    end
    createTopBtn("X", UDim2.new(1, -32, 0, 7), Color3.fromRGB(180, 0, 0), function() gui:Destroy() end)
    
    local isMinimized = false
    local minBtn = Instance.new("TextButton", main); minBtn.Size = UDim2.new(0, 25, 0, 25); minBtn.Position = UDim2.new(1, -62, 0, 7)
    minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); minBtn.Text = "-"; minBtn.TextColor3 = Color3.new(1,1,1); minBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", minBtn)

    -- STATUS BOX
    local sBox = Instance.new("Frame", main); sBox.Size = UDim2.new(1, -20, 0, 80); sBox.Position = UDim2.new(0, 10, 0, 40)
    sBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25); Instance.new("UICorner", sBox)
    local rText = Instance.new("TextLabel", sBox); rText.Size = UDim2.new(1,0,0,25); rText.Text = "RANK: OWNER [GHOST]"; rText.TextColor3 = Color3.fromRGB(255, 215, 0); rText.BackgroundTransparency = 1; rText.Font = Enum.Font.GothamBold; rText.TextSize = 11
    local s1 = Instance.new("TextLabel", sBox); s1.Size = UDim2.new(1,0,0,20); s1.Position = UDim2.new(0,0,0,25); s1.BackgroundTransparency = 1; s1.TextColor3 = Color3.new(1,1,1); s1.Font = Enum.Font.Code; s1.TextSize = 10
    local s2 = Instance.new("TextLabel", sBox); s2.Size = UDim2.new(1,0,0,20); s2.Position = UDim2.new(0,0,0,45); s2.BackgroundTransparency = 1; s2.TextColor3 = Color3.fromRGB(0, 255, 255); s2.Font = Enum.Font.Code; s2.TextSize = 10

    local function refresh()
        s1.Text = "GHOST: "..(_G.GhostStates.Invis and "ON" or "OFF").." | SPD: ".._G.TargetSpeed
        s2.Text = "FLY: "..(_G.GhostStates.Fly and "ON" or "OFF").." | FLYSPD: ".._G.FlySpeed
    end

    -- SCROLL
    local scroll = Instance.new("ScrollingFrame", main); scroll.Size = UDim2.new(1, -10, 0, 300); scroll.Position = UDim2.new(0, 5, 0, 130)
    scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 4; scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

    local function btn(name, cb)
        local b = Instance.new("TextButton", scroll); b.Size = UDim2.new(0.9, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(20, 45, 90); b.Text = name; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 11; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function() cb(); refresh() end)
    end

    -- [[ BUTTONS ]] --
    btn("👻 GHOST MODE", function()
        _G.GhostStates.Invis = not _G.GhostStates.Invis
        local char = player.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then v.Transparency = _G.GhostStates.Invis and 1 or 0 end
            end
        end
    end)

    btn("🚀 INF WALK SPEED (x2)", function() _G.TargetSpeed *= 2 end)
    btn("🐢 RESET WALK SPEED", function() _G.TargetSpeed = 16 end)
    btn("⚡ INF FLY SPEED (x2)", function() _G.FlySpeed *= 2 end)
    btn("📉 DECREASE FLY SPEED (/2)", function() _G.FlySpeed = math.floor(_G.FlySpeed / 2) end)
    btn("🕊️ FLY (WASD)", function() _G.GhostStates.Fly = not _G.GhostStates.Fly end)
    btn("🚪 NOCLIP (N)", function() _G.GhostStates.Noclip = not _G.GhostStates.Noclip end)

    -- Spawn System 1
    btn("📍 SET SPAWN 1", function() 
        local char = player.Character 
        if char and char:FindFirstChild("HumanoidRootPart") then 
            _G.SavedPos1 = char.HumanoidRootPart.Position 
        end 
    end)
    btn("🌀 TP SPAWN 1", function() 
        local char = player.Character 
        if char and char:FindFirstChild("HumanoidRootPart") and _G.SavedPos1 then 
            char.HumanoidRootPart.CFrame = CFrame.new(_G.SavedPos1) 
        end 
    end)

    -- Spawn System 2
    btn("📍 SET SPAWN 2", function() 
        local char = player.Character 
        if char and char:FindFirstChild("HumanoidRootPart") then 
            _G.SavedPos2 = char.HumanoidRootPart.Position 
        end 
    end)
    btn("🌀 TP SPAWN 2", function() 
        local char = player.Character 
        if char and char:FindFirstChild("HumanoidRootPart") and _G.SavedPos2 then 
            char.HumanoidRootPart.CFrame = CFrame.new(_G.SavedPos2) 
        end 
    end)
    
    btn("鼠标🖱️ GET CLICK-TP TOOL", function()
        local t = Instance.new("Tool", player.Backpack); t.Name = "Ghost TP"; t.RequiresHandle = false
        t.Activated:Connect(function() 
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(player:GetMouse().Hit.Position + Vector3.new(0,3,0)) 
            end
        end)
    end)

    btn("💬 CHAT SPAMMER", function()
        _G.GhostStates.Spaming = not _G.GhostStates.Spaming
        task.spawn(function()
            while _G.GhostStates.Spaming do
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("❗ MURDERS PANEL V1.GHOST ON TOP ❗", "All")
                task.wait(2.5)
            end
        end)
    end)

    -- MINIMIZE LOGIC
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        main:TweenSize(isMinimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 440), "Out", "Quad", 0.3, true)
        scroll.Visible = not isMinimized; sBox.Visible = not isMinimized; minBtn.Text = isMinimized and "+" or "-"
    end)

    -- ENGINE
    RunService.Heartbeat:Connect(function()
        local char = player.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if humanoid then humanoid.WalkSpeed = _G.TargetSpeed end
        if _G.GhostStates.Noclip and char then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
        if _G.GhostStates.Fly and root then
            local bv = root:FindFirstChild("GhostV") or Instance.new("BodyVelocity", root)
            bv.Name = "GhostV"; bv.MaxForce = Vector3.new(9e9,9e9,9e9)
            local cam = workspace.CurrentCamera
            local dir = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            bv.Velocity = dir * _G.FlySpeed
            if humanoid then humanoid.PlatformStand = true end
        elseif root and root:FindFirstChild("GhostV") then
            root.GhostV:Destroy()
            if humanoid then humanoid.PlatformStand = false end
        end
        refresh()
    end)
end

-- Launch
createGhostPanel()
