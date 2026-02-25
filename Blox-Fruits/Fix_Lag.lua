--[[
    TVH Hub - Optimized UI Version
    Fix: Separator width, Tab dividers, and Icon clipping.
]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Khởi tạo Config nếu chưa có
_G.Configs = _G.Configs or {
    SelectedWeapon = "None",
    WhiteScreen = false,
    FPSBooster = false,
    HideFarObjects = false,
    AutoFPSBoost = false,
    MobileMode = false
}

local function ExecuteLogic(key, state)
    if key == "FPSBooster" and state then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        Lighting.Technology = Enum.Technology.Compatibility
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
        end
    elseif key == "MobileMode" and state then
        Lighting.GlobalShadows = false
        Lighting.Brightness = 0
        Lighting.Technology = Enum.Technology.Compatibility
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.Plastic; v.Reflectance = 0 end
        end
    end
end

local function MakeDraggable(frame)
    local dragging, dragInput, startPos, startFramePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(startFramePos.X.Scale, startFramePos.X.Offset + delta.X, startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y)
        end
    end)
end

-- GUI Parent
local guiParent = player:WaitForChild("PlayerGui")

-- 1. FIX ICON (Bo góc chuẩn, không tràn)
local IconGui = Instance.new("ScreenGui", guiParent)
IconGui.Name = "IconGui"
IconGui.ResetOnSpawn = false

local Icon = Instance.new("ImageButton", IconGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0, 15, 0.5, -30)
Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icon.ClipsDescendants = true -- Quan trọng để bo góc hình ảnh bên trong
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2
MakeDraggable(Icon)

local AvatarLogo = Instance.new("ImageLabel", Icon)
AvatarLogo.Size = UDim2.new(1, 0, 1, 0)
AvatarLogo.BackgroundTransparency = 1
AvatarLogo.Image = "rbxassetid://107925154921311"
AvatarLogo.ScaleType = Enum.ScaleType.Crop

-- 2. MAIN GUI
local MainGui = Instance.new("ScreenGui", guiParent)
MainGui.Name = "MainGui"
MainGui.ResetOnSpawn = false

local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0, 600, 0, 420)
Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
MakeDraggable(Main)

-- TopBar & Title
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "TVH HUB - FIX LAG"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- FIX: Separator (Kẻ ngang full menu, màu nhạt)
local Separator = Instance.new("Frame", Main)
Separator.Size = UDim2.new(1, 0, 0, 1)
Separator.Position = UDim2.new(0, 0, 0, 45)
Separator.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Separator.BackgroundTransparency = 0.6 -- Màu nhạt hơn
Separator.BorderSizePixel = 0

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 500)

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -175, 1, -60)
PagesContainer.Position = UDim2.new(0, 170, 0, 55)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

local function createTab(name, index)
    local pg = Instance.new("ScrollingFrame", PagesContainer)
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = (index == 1)
    pg.ScrollBarThickness = 2
    pg.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
    Pages[name] = pg

    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.Position = UDim2.new(0, 0, 0, (index-1)*45)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = (index==1) and Color3.new(1,1,1) or Color3.new(0.5, 0.5, 0.5)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13

    -- FIX: Thêm đường kẻ nhỏ cho từng Tab
    local TabLine = Instance.new("Frame", btn)
    TabLine.Size = UDim2.new(0.8, 0, 0, 1)
    TabLine.Position = UDim2.new(0.1, 0, 1, -1)
    TabLine.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    TabLine.BackgroundTransparency = 0.8 -- Rất nhạt
    TabLine.BorderSizePixel = 0

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        pg.Visible = true
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.new(0.5, 0.5, 0.5) end
        end
        btn.TextColor3 = Color3.new(1,1,1)
    end)
    return pg
end

-- Toggle UI Component
local function createToggle(parent, text, yPos, configKey)
    local tgl = Instance.new("TextButton", parent)
    tgl.Size = UDim2.new(1, -10, 0, 40)
    tgl.Position = UDim2.new(0, 5, 0, yPos)
    tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tgl.Text = "   " .. text
    tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
    tgl.Font = Enum.Font.Gotham
    tgl.TextSize = 14
    tgl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tgl).CornerRadius = UDim.new(0, 6)

    local dot = Instance.new("Frame", tgl)
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = UDim2.new(1, -30, 0.5, -9)
    dot.BackgroundColor3 = _G.Configs[configKey] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    tgl.MouseButton1Click:Connect(function()
        _G.Configs[configKey] = not _G.Configs[configKey]
        TweenService:Create(dot, TweenInfo.new(0.2), {
            BackgroundColor3 = _G.Configs[configKey] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)
        }):Play()
        ExecuteLogic(configKey, _G.Configs[configKey])
    end)
end

-- Tabs Initialization
local Tab1 = createTab("Hệ Thống", 1)
local Tab2 = createTab("Tự Động Farm", 2)

createToggle(Tab1, "Giảm Lag (Trắng Màn Hình)", 10, "WhiteScreen")
createToggle(Tab1, "FPS Booster", 60, "FPSBooster")
createToggle(Tab1, "Chế Độ Mobile Siêu Nhẹ", 110, "MobileMode")

Icon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)
