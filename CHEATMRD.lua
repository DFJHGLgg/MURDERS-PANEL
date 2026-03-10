local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local PREF_FILE = "CHEAT MRD_Preference.txt"
local MAIN_URL = "https://raw.githubusercontent.com/perfectusmim1/spiemhub/refs/heads/main/loadermain"
local PERF_URL = "https://raw.githubusercontent.com/perfectusmim1/spiemhub/refs/heads/main/loaderperformane"

-- Safe GUI Parent Getter
local function GetGuiParent()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then 
        -- syn.protect_gui requires an already created gui, but we want a parent.
        -- We will return CoreGui here and protect later if using syn
        return CoreGui
    end
    return CoreGui
end

local function LoadScript(url)
    task.spawn(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            warn("CHEAT MRD Error:", err)
        end
    end)
end

local function SavePreference(mode)
    writefile(PREF_FILE, mode)
end

local function GetPreference()
    if isfile(PREF_FILE) then
        return readfile(PREF_FILE)
    end
    return nil
end

local function SimpleNotify(title, text)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Notify"
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = GetGuiParent()
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 250, 0, 60)
    Frame.Position = UDim2.new(1, -270, 1, -80)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(60, 60, 70)
    Stroke.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.Size = UDim2.new(1, -30, 0, 20)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame
    
    local Desc = Instance.new("TextLabel")
    Desc.Text = text
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 12
    Desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 15, 0, 30)
    Desc.Size = UDim2.new(1, -30, 0, 20)
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Frame
    
    -- Animation
    Frame.Position = UDim2.new(1, 20, 1, -80)
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -270, 1, -80)
    }):Play()
    
    task.delay(3, function()
        TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 1, -80)
        }):Play()
        task.wait(0.5)
        ScreenGui:Destroy()
    end)
end

local function CreateModernUI()
    -- Clean up old UI if it exists
    for _, child in pairs(CoreGui:GetChildren()) do
        if child.Name == "MRDLoaderModern" then child:Destroy() end
    end
    if GetGuiParent():FindFirstChild("MRDLoaderModern") then
        GetGuiParent().SpiemLoaderModern:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MRDLoaderModern"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    ScreenGui.Parent = GetGuiParent()

    -- Colors & Styling
    local Colors = {
        Bg = Color3.fromRGB(18, 18, 24),
        Card = Color3.fromRGB(28, 28, 36),
        Stroke = Color3.fromRGB(50, 50, 60),
        Text = Color3.fromRGB(245, 245, 245),
        SubText = Color3.fromRGB(160, 160, 170),
        AccentBlue = Color3.fromRGB(59, 130, 246), -- Modern blue
        AccentOrange = Color3.fromRGB(249, 115, 22), -- Vivid orange
        HoverOverlay = Color3.fromRGB(255, 255, 255)
    }

    -- Background Blur/Dim (Optional)
    local Backdrop = Instance.new("Frame")
    Backdrop.Size = UDim2.new(1, 0, 1, 0)
    Backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Backdrop.BackgroundTransparency = 1 -- Start transparent
    Backdrop.Parent = ScreenGui
    TweenService:Create(Backdrop, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 440, 0, 340)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Colors.Bg
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false -- Allow shadows/glows if we added them
    MainFrame.Parent = ScreenGui

    -- Make Draggable
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Hidden initially for animation
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.BackgroundTransparency = 1

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Colors.Stroke
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame

    -- Inner Shadow/Depth effect (Subtle)
    local InnerGlow = Instance.new("ImageLabel")
    InnerGlow.Size = UDim2.new(1, 30, 1, 30)
    InnerGlow.Position = UDim2.new(0, -15, 0, -15)
    InnerGlow.BackgroundTransparency = 1
    InnerGlow.Image = "rbxassetid://5028857472" -- Soft glow
    InnerGlow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    InnerGlow.ImageTransparency = 0.6
    InnerGlow.ScaleType = Enum.ScaleType.Slice
    InnerGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    InnerGlow.ZIndex = 0
    InnerGlow.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 30, 0, 30)
    TitleIcon.Position = UDim2.new(0, 20, 0.5, -15)
    TitleIcon.Image = "rbxassetid://111799365323503" -- Previous icon
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Parent = Header

    local TitleText = Instance.new("TextLabel")
    TitleText.Text = "CHEAT MRD"
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 20
    TitleText.TextColor3 = Colors.Text
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(0, 200, 1, 0)
    TitleText.Position = UDim2.new(0, 60, 0, 0)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = Header

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 0, 60)
    Divider.BackgroundColor3 = Colors.Stroke
    Divider.BorderSizePixel = 0
    Divider.Parent = MainFrame

    -- Content
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 1, -60)
    Content.Position = UDim2.new(0, 0, 0, 60)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    local InfoText = Instance.new("TextLabel")
    InfoText.Text = "Welcome back! Please select a version to load.\nIf you experience crashes, try Performance Mode."
    InfoText.Font = Enum.Font.Gotham
    InfoText.TextSize = 14
    InfoText.TextColor3 = Colors.SubText
    InfoText.BackgroundTransparency = 1
    InfoText.Size = UDim2.new(1, -40, 0, 40)
    InfoText.Position = UDim2.new(0, 20, 0, 15)
    InfoText.TextXAlignment = Enum.TextXAlignment.Left
    InfoText.TextYAlignment = Enum.TextYAlignment.Top
    InfoText.TextWrapped = true
    InfoText.Parent = Content

    local ButtonList = Instance.new("Frame")
    ButtonList.Size = UDim2.new(1, -40, 0, 160)
    ButtonList.Position = UDim2.new(0, 20, 0, 65)
    ButtonList.BackgroundTransparency = 1
    ButtonList.Parent = Content
    
    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 12)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Parent = ButtonList

    local rememberChoice = false

    local function CreateOptionButton(order, name, desc, color, callback)
        local btn = Instance.new("TextButton")
        btn.LayoutOrder = order
        btn.Size = UDim2.new(1, 0, 0, 60)
        btn.BackgroundColor3 = Colors.Card
        btn.AutoButtonColor = false
        btn.Text = ""
        btn.Parent = ButtonList
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn
        
        local btnStroke = Instance.new("UIStroke")
        btnStroke.Color = Colors.Stroke
        btnStroke.Thickness = 1
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btnStroke.Parent = btn
        
        -- Accent Line
        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0, 4, 0, 30)
        accent.Position = UDim2.new(0, 0, 0.5, -15)
        accent.BackgroundColor3 = color
        accent.BorderSizePixel = 0
        accent.Parent = btn
        local acCorner = Instance.new("UICorner")
        acCorner.CornerRadius = UDim.new(0, 2)
        acCorner.Parent = accent
        
        local btnTitle = Instance.new("TextLabel")
        btnTitle.Text = name
        btnTitle.Font = Enum.Font.GothamBold
        btnTitle.TextSize = 16
        btnTitle.TextColor3 = Colors.Text
        btnTitle.BackgroundTransparency = 1
        btnTitle.Position = UDim2.new(0, 20, 0, 10)
        btnTitle.Size = UDim2.new(1, -20, 0, 20)
        btnTitle.TextXAlignment = Enum.TextXAlignment.Left
        btnTitle.Parent = btn
        
        local btnDesc = Instance.new("TextLabel")
        btnDesc.Text = desc
        btnDesc.Font = Enum.Font.Gotham
        btnDesc.TextSize = 12
        btnDesc.TextColor3 = Colors.SubText
        btnDesc.BackgroundTransparency = 1
        btnDesc.Position = UDim2.new(0, 20, 0, 32)
        btnDesc.Size = UDim2.new(1, -20, 0, 15)
        btnDesc.TextXAlignment = Enum.TextXAlignment.Left
        btnDesc.Parent = btn
        
        -- Animation Events
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = color}):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Card}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
        end)
        
        btn.MouseButton1Click:Connect(function()
            -- Click feedback
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0.98, 0, 0, 58)}):Play()
            task.delay(0.1, function()
                TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 60)}):Play()
            end)
            callback()
        end)
    end
    
    CreateOptionButton(1, "Main Version", "Fully featured. Recommended for good PCs.", Colors.AccentBlue, function()
        if rememberChoice then SavePreference("Main") end
        -- Close animation
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 420, 0, 320), BackgroundTransparency = 1}):Play()
        TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
        LoadScript(MAIN_URL)
    end)
    
    CreateOptionButton(2, "Performance Version", "Optimized to prevent kicks/crashes.", Colors.AccentOrange, function()
        if rememberChoice then SavePreference("Performance") end
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 420, 0, 320), BackgroundTransparency = 1}):Play()
        TweenService:Create(Backdrop, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
        LoadScript(PERF_URL)
    end)
    
    -- Checkbox
    local CheckContainer = Instance.new("TextButton")
    CheckContainer.LayoutOrder = 3
    CheckContainer.Size = UDim2.new(1, 0, 0, 30)
    CheckContainer.BackgroundTransparency = 1
    CheckContainer.Text = ""
    CheckContainer.Parent = ButtonList
    
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(0, 2, 0.5, -9)
    Box.BackgroundColor3 = Colors.Card
    Box.BorderSizePixel = 0
    Box.Parent = CheckContainer
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box
    
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Colors.Stroke
    BoxStroke.Thickness = 1.5
    BoxStroke.Parent = Box
    
    local CheckMark = Instance.new("ImageLabel")
    CheckMark.Image = "rbxassetid://6031094667"
    CheckMark.Size = UDim2.new(0, 14, 0, 14)
    CheckMark.Position = UDim2.new(0.5, -7, 0.5, -7)
    CheckMark.BackgroundTransparency = 1
    CheckMark.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CheckMark.ImageTransparency = 1
    CheckMark.Parent = Box
    
    local CheckText = Instance.new("TextLabel")
    CheckText.Text = "Don't ask again (Auto-load)"
    CheckText.Font = Enum.Font.Gotham
    CheckText.TextSize = 13
    CheckText.TextColor3 = Colors.SubText
    CheckText.BackgroundTransparency = 1
    CheckText.Size = UDim2.new(1, -30, 1, 0)
    CheckText.Position = UDim2.new(0, 30, 0, 0)
    CheckText.TextXAlignment = Enum.TextXAlignment.Left
    CheckText.Parent = CheckContainer
    
    CheckContainer.MouseButton1Click:Connect(function()
        rememberChoice = not rememberChoice
        if rememberChoice then
            TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Colors.AccentBlue}):Play()
            TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.AccentBlue}):Play()
            TweenService:Create(CheckMark, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
            TweenService:Create(CheckText, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
        else
            TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Card}):Play()
            TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Colors.Stroke}):Play()
            TweenService:Create(CheckMark, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            TweenService:Create(CheckText, TweenInfo.new(0.2), {TextColor3 = Colors.SubText}):Play()
        end
    end)
    
    -- Final Reveal Animation
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 440, 0, 340),
        BackgroundTransparency = 0
    }):Play()
    for _, v in pairs(MainFrame:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("ImageLabel") then
            local t = v:IsA("TextLabel") and v.TextTransparency or v.ImageTransparency
            -- v.TextTransparency = 1
            -- Tween back
        end
    end
end

-- Execution Logic
local savedMode = GetPreference()
if savedMode == "Main" then
    SimpleNotify("CHEAT MRD", "Auto-loading Main Version...")
    LoadScript(MAIN_URL)
elseif savedMode == "Performance" then
    SimpleNotify("Spiem Hub", "Auto-loading Performance Version...")
    LoadScript(PERF_URL)
else
    if not game:IsLoaded() then game.Loaded:Wait() end
    CreateModernUI()
end
