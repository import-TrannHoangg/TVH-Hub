local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local State = {
    FPSBooster = false,
    MobileMode = false,
    HiddenIsland = false,
    FPSBoost = true,
    FixLagMode = false,
    HideNPCs = false
}

local TabIcons = {
    ["Tab Farm"] = "rbxassetid://70492079783125",
    ["Tab Nhiệm Vụ, Item"] = "rbxassetid://85923648556160",
    ["Tab Câu Cá"] = "rbxassetid://117464735534300",
    ["Tab Sự Kiện Sea"] = "rbxassetid://96594171535657",
    ["Tab Raid/Trái"] = "rbxassetid://117786143421965",
    ["Tab Chỉ Số"] = "rbxassetid://1131983014082260",
    ["Tab Dịch Chuyển"] = "rbxassetid://83054494283840",
    ["Tab Trạng Thái"] = "rbxassetid://86375240234504",
    ["Tab Thị Giác"] = "rbxassetid://137611999012404",
    ["Tab Cửa Hàng"] = "rbxassetid://91250120807261",
    ["Tab Cài Đặt"] = "rbxassetid://70767352650956"
}

local FILE = "TVH-Hub_Config.json"
local function SaveConfig()
    if writefile then writefile(FILE, HttpService:JSONEncode(State)) end
end

local function LoadConfig()
    if readfile and isfile and isfile(FILE) then
        local status, data = pcall(function() return HttpService:JSONDecode(readfile(FILE)) end)
        if status then for k,v in pairs(data) do State[k] = v end end
    end
end
LoadConfig()

local PlayerGui = player:WaitForChild("PlayerGui")

local IconGui = Instance.new("ScreenGui", PlayerGui)
IconGui.Name = "TVH_IconGui"
IconGui.ResetOnSpawn = false

local Icon = Instance.new("ImageButton", IconGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0, 15, 0.5, -30)
Icon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Icon.ClipsDescendants = true
Icon.BorderSizePixel = 0
Instance.new("UICorner", Icon).CornerRadius = UDim.new(0, 12)

local AvatarLogo = Instance.new("ImageLabel", Icon)
AvatarLogo.Size = UDim2.new(1, 0, 1, 0)
AvatarLogo.BackgroundTransparency = 1
AvatarLogo.Image = "rbxassetid://107925154921311"
AvatarLogo.ScaleType = Enum.ScaleType.Crop

local IconStroke = Instance.new("UIStroke", Icon)
IconStroke.Thickness = 2
IconStroke.Color = Color3.fromRGB(0, 255, 255)

local MainGui = Instance.new("ScreenGui", PlayerGui)
MainGui.Name = "TVH_MainGui"
MainGui.ResetOnSpawn = false

local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0, 580, 0, 400)
Main.Position = UDim2.new(0.5, -290, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "TVH Hub - by Trần Văn Hoàng"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local Separator = Instance.new("Frame", Main)
Separator.Size = UDim2.new(1, 0, 0, 1)
Separator.Position = UDim2.new(0, 0, 0, 45)
Separator.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Separator.BackgroundTransparency = 0.7
Separator.BorderSizePixel = 0

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -165, 1, -60)
PagesContainer.Position = UDim2.new(0, 160, 0, 55)
PagesContainer.BackgroundTransparency = 1

local Pages = {}
local TabButtons = {}

local function CreateTab(name, order)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 0, 500)
    page.Visible = (order == 1)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    Pages[name] = page

    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (order-1)*40)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local unselectedColor = Color3.fromRGB(160, 160, 160)
    local selectedColor = Color3.new(1, 1, 1)

    local iconImg = Instance.new("ImageLabel", btn)
    iconImg.Size = UDim2.new(0, 20, 0, 20)
    iconImg.Position = UDim2.new(0, 12, 0.5, -10)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = TabIcons[name] or ""
    iconImg.ImageColor3 = (order == 1) and selectedColor or unselectedColor

    local btnLabel = Instance.new("TextLabel", btn)
    btnLabel.Size = UDim2.new(1, -45, 1, 0)
    btnLabel.Position = UDim2.new(0, 40, 0, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = name:gsub("Tab ", "")
    btnLabel.TextColor3 = (order == 1) and selectedColor or unselectedColor
    btnLabel.Font = Enum.Font.GothamBold
    btnLabel.TextSize = 13
    btnLabel.TextXAlignment = Enum.TextXAlignment.Left

    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 3, 0.5, 0)
    indicator.Position = UDim2.new(0, 2, 0.25, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Visible = (order == 1)
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    TabButtons[name] = {btn = btn, label = btnLabel, indicator = indicator, icon = iconImg}

    btn.MouseButton1Click:Connect(function()
        for n, data in pairs(TabButtons) do
            local isSelected = (n == name)
            
            Pages[n].Visible = isSelected
            data.indicator.Visible = isSelected

            local targetColor = isSelected and selectedColor or unselectedColor
            
            TweenService:Create(data.label, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {TextColor3 = targetColor}):Play()
            TweenService:Create(data.icon, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {ImageColor3 = targetColor}):Play()
        end
    end)
    return page
end

local function CreateToggle(parent, text, y, key, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 45)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local switch = Instance.new("Frame", frame)
    switch.Size = UDim2.new(0, 38, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = State[key] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = State[key] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    btn.MouseButton1Click:Connect(function()
        State[key] = not State[key]
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = State[key] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = State[key] and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)}):Play()
        if callback then callback(State[key]) end
        SaveConfig()
    end)
end

local function MakeDraggable(frame)
    local dragging, startPos, startFramePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(startFramePos.X.Scale, startFramePos.X.Offset + delta.X, startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

MakeDraggable(Icon)
MakeDraggable(Main)
Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local TabFarm = CreateTab("Tab Farm", 1)
local TabQuestsItem = CreateTab("Tab Nhiệm Vụ, Item", 2)
local TabFishing = CreateTab("Tab Câu Cá", 3)
local TabSeaEvent = CreateTab("Tab Sự Kiện Sea", 4)
local TabRaidFruit = CreateTab("Tab Raid/Trái", 5)
local TabStats= CreateTab("Tab Chỉ Số", 6)
local TabTeleport = CreateTab("Tab Dịch Chuyển", 7)
local TabStatus = CreateTab("Tab Trạng Thái", 8)
local TabVirtual= CreateTab("Tab Thị Giác", 9)
local TabShop = CreateTab("Tab Cửa Hàng", 10)
local TabSettings = CreateTab("Tab Cài Đặt", 11)

CreateToggle(TabSettings, "FPS Booster", 10, "FPSBooster")
CreateToggle(TabSettings, "Ẩn Đảo Xa", 60, "HiddenIsland")
CreateToggle(TabSettings, "Ẩn NPC Tầm Xa", 110, "HideNPCs")
