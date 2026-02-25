local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

_G.Configs = _G.Configs or {
    AutoFarmLevel = false,
    SelectedWeapon = "Melee",
    AutoBones = false,
    AutoChestTween = false,
    AutoBerry = false,
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
    end
end

local IconGui = Instance.new("ScreenGui", guiParent)
IconGui.Name = "IconGui"
IconGui.ResetOnSpawn = false
IconGui.DisplayOrder = 999

local Icon = Instance.new("ImageButton", IconGui)
Icon.Size = UDim2.new(0, 60, 0, 60)
Icon.Position = UDim2.new(0, 25, 0.5, -30)
Icon.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Icon.Draggable = true
Icon.Active = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

local GithubLogo = Instance.new("ImageLabel", Icon)
GithubLogo.Size = UDim2.new(0, 40, 0, 40)
GithubLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
GithubLogo.AnchorPoint = Vector2.new(0.5, 0.5)
GithubLogo.BackgroundTransparency = 1
GithubLogo.Image = "rbxassetid://6030541910"
GithubLogo.ZIndex = 2

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

local MainGui = Instance.new("ScreenGui", guiParent)
MainGui.Name = "MainGui"
MainGui.Enabled = false
MainGui.ResetOnSpawn = false
MainGui.DisplayOrder = 1000

Icon.MouseButton1Click:Connect(function()
    MainGui.Enabled = not MainGui.Enabled
end)

local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0, 750, 0, 480)
Main.Position = UDim2.new(0.5, -375, 0.5, -240)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
CloseBtn.MouseButton1Click:Connect(function() MainGui.Enabled = false end)

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

local function createDropdown(parent, text, yPos, options, callback)
    local isOpened = false
    local dropdownFrame = Instance.new("Frame", parent)
    dropdownFrame.Size = UDim2.new(1, -10, 0, 40)
    dropdownFrame.Position = UDim2.new(0, 5, 0, yPos)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    dropdownFrame.ClipsDescendants = true
    dropdownFrame.ZIndex = 10
    Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0, 8)

    local mainBtn = Instance.new("TextButton", dropdownFrame)
    mainBtn.Size = UDim2.new(1, 0, 0, 40)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text = "  " .. text .. ": " .. _G.Configs.SelectedWeapon
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.TextSize = 14
    mainBtn.Font = Enum.Font.GothamSemibold
    mainBtn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", mainBtn)
    arrow.Size = UDim2.new(0, 40, 1, 0)
    arrow.Position = UDim2.new(1, -40, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "v"
    arrow.TextColor3 = Color3.fromRGB(0, 200, 255)
    arrow.TextSize = 16
    arrow.Font = Enum.Font.GothamBold

    local optionContainer = Instance.new("Frame", dropdownFrame)
    optionContainer.Size = UDim2.new(1, 0, 0, #options * 35)
    optionContainer.Position = UDim2.new(0, 0, 0, 40)
    optionContainer.BackgroundTransparency = 1

    mainBtn.MouseButton1Click:Connect(function()
        isOpened = not isOpened
        dropdownFrame:TweenSize(isOpened and UDim2.new(1, -10, 0, 40 + (#options * 35)) or UDim2.new(1, -10, 0, 40), "Out", "Quad", 0.3, true)
        arrow.Text = isOpened and "^" or "v"
    end)

    for i, option in pairs(options) do
        local optBtn = Instance.new("TextButton", optionContainer)
        optBtn.Size = UDim2.new(1, -10, 0, 30)
        optBtn.Position = UDim2.new(0, 5, 0, (i-1) * 35)
        optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        optBtn.Text = option
        optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 13
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

        optBtn.MouseButton1Click:Connect(function()
            _G.Configs.SelectedWeapon = option
            mainBtn.Text = "  " .. text .. ": " .. option
            isOpened = false
            dropdownFrame:TweenSize(UDim2.new(1, -10, 0, 40), "Out", "Quad", 0.3, true)
            arrow.Text = "v"
            callback(option)
        end)
    end
end

local function createToggle(parent, text, yPos, configKey)
    local toggleFrame = Instance.new("TextButton", parent)
    toggleFrame.Size = UDim2.new(1, -10, 0, 38); toggleFrame.Position = UDim2.new(0, 5, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40); toggleFrame.Text = ""
    Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", toggleFrame)
    label.Size = UDim2.new(1, -60, 1, 0); label.Position = UDim2.new(0, 15, 0, 0); label.BackgroundTransparency = 1
    label.Text = text; label.TextColor3 = Color3.fromRGB(200, 200, 200); label.TextSize = 14; label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switchBg = Instance.new("Frame", toggleFrame)
    switchBg.Size = UDim2.new(0, 36, 0, 18); switchBg.Position = UDim2.new(1, -45, 0.5, -9); switchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", switchBg)
    circle.Size = UDim2.new(0, 14, 0, 14); circle.Position = UDim2.new(0, 2, 0.5, -7); circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    toggleFrame.MouseButton1Click:Connect(function()
        _G.Configs[configKey] = not _G.Configs[configKey]
        local active = _G.Configs[configKey]
        circle:TweenPosition(active and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), "Out", "Quad", 0.2, true)
        switchBg.BackgroundColor3 = active and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(50, 50, 60)
        ExecuteLogic(configKey, active)
    end)
end

local function createTab(name, index)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = (index == 1)
    page.ScrollBarThickness = 2; page.CanvasSize = UDim2.new(0, 0, 0, 1000)
    Pages[name] = page
    local tabBtn = Instance.new("TextButton", TabContainer)
    tabBtn.Size = UDim2.new(1, -10, 0, 35); tabBtn.Position = UDim2.new(0, 5, 0, (index-1) * 40)
    tabBtn.BackgroundTransparency = 1; tabBtn.Text = name; tabBtn.TextColor3 = (index == 1) and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
    tabBtn.Font = Enum.Font.GothamBold; tabBtn.TextSize = 13
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end; page.Visible = true
        for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(150, 150, 150) end end
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
    end)
    return page
end

local farm = createTab("Tab Farm", 1)
createLabel(farm, "Cài Đặt Vũ Khí", 0)
createDropdown(farm, "Chọn Vũ Khí", 35, {"Melee", "Kiếm", "Trái"})

createLabel(farm, "Farm Cấp Độ", 95)
createToggle(farm, "Tự Động Farm Level", 130, "AutoFarmLevel")
createToggle(farm, "Tự Động Farm Quái Gần Nhất", 175, "AutoFarmNearest")

createLabel(farm, "Farm Xương", 225)
createToggle(farm, "Tự Động Farm Xương", 260, "AutoBones")

createLabel(farm, "Farm Rương & Nhặt Berry", 310)
createToggle(farm, "Tự Động Farm Rương [Tween]", 345, "AutoChestTween")
createToggle(farm, "Tự Động Nhặt Berry", 390, "AutoBerry")

createTab("Tab Nhiệm Vụ / Vật Phẩm", 2)
createTab("Tab Sự Kiện Biển", 3)
createTab("Tab Điểm Chỉ Số", 4)
createTab("Tab Dịch Chuyển", 5)
createTab("Tab Cài Đặt", 6)
