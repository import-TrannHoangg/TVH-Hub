local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

_G.Configs = {
    AutoFarmLevel = false,
    AutoFarmNearest = false,
    AutoValentine = false,
    AutoBones = false,
    AutoSoulReaper = false,
    AutoKatakuri = false,
    AutoBerry = false,
    AutoChestTween = false,
    AutoBoss = false,
    AutoMaterial = false
}

local function ExecuteLogic(key, state)
    if not state then return end

    if key == "AutoFarmLevel" then
        task.spawn(function()
            while _G.Configs.AutoFarmLevel do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "AutoBones" then
        task.spawn(function()
            while _G.Configs.AutoBones do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "AutoChestTween" then
        task.spawn(function()
            while _G.Configs.AutoChestTween do
                pcall(function()
                end)
                task.wait(0.5)
            end
        end)

    elseif key == "AutoBerry" then
        task.spawn(function()
            while _G.Configs.AutoBerry do
                pcall(function()
                end)
                task.wait(0.5)
            end
        end)
    end
end

local IconGui = Instance.new("ScreenGui", guiParent)
IconGui.Name = "IconGui"
IconGui.ResetOnSpawn = false

local Icon = Instance.new("ImageButton", IconGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0, 25, 0.5, -30)
Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Icon.Draggable = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

local GithubLogo = Instance.new("ImageLabel", Icon)
GithubLogo.Size = UDim2.new(0, 35, 0, 35)
GithubLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
GithubLogo.AnchorPoint = Vector2.new(0.5, 0.5)
GithubLogo.BackgroundTransparency = 1
GithubLogo.Image = "rbxassetid://124960121109677"

local Stroke = Instance.new("UIStroke", Icon)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 200, 255)

task.spawn(function()
    while true do
        TweenService:Create(Stroke, TweenInfo.new(1), {Color = Color3.fromRGB(170, 0, 255)}):Play()
        task.wait(1)
        TweenService:Create(Stroke, TweenInfo.new(1), {Color = Color3.fromRGB(0, 200, 255)}):Play()
        task.wait(1)
    end
end)

local Gui = Instance.new("ScreenGui", guiParent)
Gui.Enabled = false
Gui.ResetOnSpawn = false

Icon.MouseButton1Click:Connect(function()
    Gui.Enabled = not Gui.Enabled
end)

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 750, 0, 480)
Main.Position = UDim2.new(0.5, -375, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -20)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 500)

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -200, 1, -20)
PagesContainer.Position = UDim2.new(0, 190, 0, 10)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

local function createLabel(parent, text, yPos)
    local lb = Instance.new("TextLabel", parent)
    lb.Size = UDim2.new(1, -10, 0, 30)
    lb.Position = UDim2.new(0, 10, 0, yPos)
    lb.BackgroundTransparency = 1
    lb.Text = text:upper()
    lb.TextColor3 = Color3.fromRGB(0, 200, 255)
    lb.Font = Enum.Font.GothamBold
    lb.TextSize = 13
    lb.TextXAlignment = Enum.TextXAlignment.Left
end

local function createToggle(parent, text, yPos, configKey)
    local toggleFrame = Instance.new("TextButton", parent)
    toggleFrame.Size = UDim2.new(1, -10, 0, 38)
    toggleFrame.Position = UDim2.new(0, 5, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggleFrame.Text = ""
    toggleFrame.AutoButtonColor = false
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switchBg = Instance.new("Frame", toggleFrame)
    switchBg.Size = UDim2.new(0, 36, 0, 18)
    switchBg.Position = UDim2.new(1, -45, 0.5, -9)
    switchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", switchBg)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    toggleFrame.MouseButton1Click:Connect(function()
        _G.Configs[configKey] = not _G.Configs[configKey]
        local active = _G.Configs[configKey]
        
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = active and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)}):Play()
        
        ExecuteLogic(configKey, active)
    end)
end

local function createTab(name, index)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = (index == 1)
    page.ScrollBarThickness = 2
    page.CanvasSize = UDim2.new(0, 0, 0, 1000)
    Pages[name] = page

    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(1, -10, 0, 35)
    tabBtn.Position = UDim2.new(0, 5, 0, (index-1) * 40)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = name
    tabBtn.TextColor3 = (index == 1) and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        page.Visible = true
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end
        end
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
    end)
    return page
end

local farm = createTab("Farm", 1)
createLabel(farm, "Tự Động Farm", 0)
createToggle(farm, "Tự Động Farm Level", 35, "AutoFarmLevel")
createToggle(farm, "Tự Động Farm Quái Gần Nhất", 80, "AutoFarmNearest")

createLabel(farm, "Farm Xương", 130)
createToggle(farm, "Tự Động Farm Xương", 165, "AutoBones")

createLabel(farm, "Rương & Vật Phẩm", 215)
createToggle(farm, "Tự Động Farm Rương [Tween]", 250, "AutoChestTween")
createToggle(farm, "Tự Động Nhặt Berry", 295, "AutoBerry")

createTab("Nhiệm Vụ / Vật Phẩm", 2)
createTab("Sự Kiện Biển", 3)
createTab("Điểm Chỉ Chỉ Số", 4)
createTab("Dịch Chuyển", 5)
createTab("Cài Đặt", 6)
