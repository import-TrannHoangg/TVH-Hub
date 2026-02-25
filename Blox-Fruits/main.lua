local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

_G.Configs = _G.Configs or {
    AutoFarmLevel = false,
    SelectedWeapon = "Melee", 
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
IconGui.Name = "IconGui"; IconGui.ResetOnSpawn = false; IconGui.DisplayOrder = 999

local Icon = Instance.new("ImageButton", IconGui)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0, 15, 0.5, -27)
Icon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Icon.Draggable = true; Icon.Active = true
Icon.ClipsDescendants = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

local GithubLogo = Instance.new("ImageLabel", Icon)
GithubLogo.Size = UDim2.new(1, 0, 1, 0)
GithubLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
GithubLogo.AnchorPoint = Vector2.new(0.5, 0.5)
GithubLogo.BackgroundTransparency = 1
GithubLogo.Image = "rbxassetid://107925154921311"
GithubLogo.ZIndex = 2

local Stroke = Instance.new("UIStroke", Icon)
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainGui = Instance.new("ScreenGui", guiParent)
MainGui.Name = "MainGui"; MainGui.ResetOnSpawn = false
MainGui.Enabled = true

local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0, 600, 0, 420)
Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true; Main.Draggable = true
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

Icon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40); TopBar.BackgroundTransparency = 1

local SmallIcon = Instance.new("ImageLabel", TopBar)
SmallIcon.Size = UDim2.new(0, 28, 0, 28); SmallIcon.Position = UDim2.new(0, 10, 0, 6)
SmallIcon.BackgroundTransparency = 1; SmallIcon.Image = "rbxassetid://107925154921311"

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 300, 1, 0); Title.Position = UDim2.new(0, 45, 0, 0)
Title.Text = "TVH Hub - by Trần Văn Hoàng"; Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 17; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.SourceSansBold; CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", Sidebar)

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -10); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 0

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -170, 1, -50); PagesContainer.Position = UDim2.new(0, 170, 0, 45)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

local function createDropdown(parent, text, yPos, options, callback)
    local isOpened = false
    local dropFrame = Instance.new("Frame", parent)
    dropFrame.Size = UDim2.new(1, -10, 0, 38); dropFrame.Position = UDim2.new(0, 5, 0, yPos)
    dropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35); dropFrame.ClipsDescendants = true; dropFrame.ZIndex = 100
    Instance.new("UICorner", dropFrame)
    local btn = Instance.new("TextButton", dropFrame)
    btn.Size = UDim2.new(1, 0, 0, 38); btn.BackgroundTransparency = 1
    btn.Text = "  " .. text .. ": " .. _G.Configs.SelectedWeapon; btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 15; btn.TextXAlignment = Enum.TextXAlignment.Left
    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 38, 1, 0); arrow.Position = UDim2.new(1, -38, 0, 0)
    arrow.Text = "v"; arrow.TextColor3 = Color3.new(0,1,1); arrow.BackgroundTransparency = 1; arrow.Font = Enum.Font.SourceSansBold; arrow.TextSize = 18
    btn.MouseButton1Click:Connect(function()
        isOpened = not isOpened
        dropFrame:TweenSize(isOpened and UDim2.new(1, -10, 0, 38 + (#options * 32)) or UDim2.new(1, -10, 0, 38), "Out", "Quad", 0.2, true)
        arrow.Text = isOpened and "^" or "v"
    end)
    for i, v in pairs(options) do
        local opt = Instance.new("TextButton", dropFrame)
        opt.Size = UDim2.new(1, -10, 0, 28); opt.Position = UDim2.new(0, 5, 0, 38 + (i-1)*32)
        opt.Text = v; opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45); opt.TextColor3 = Color3.new(1,1,1)
        opt.Font = Enum.Font.SourceSans; opt.TextSize = 14; Instance.new("UICorner", opt)
        opt.MouseButton1Click:Connect(function()
            _G.Configs.SelectedWeapon = v; btn.Text = "  " .. text .. ": " .. v; isOpened = false
            dropFrame:TweenSize(UDim2.new(1,-10,0,38), "Out", "Quad", 0.2, true); arrow.Text = "v"; callback(v)
        end)
    end
end

local function createToggle(parent, text, yPos, configKey)
    local tgl = Instance.new("TextButton", parent)
    tgl.Size = UDim2.new(1, -10, 0, 38); tgl.Position = UDim2.new(0, 5, 0, yPos); tgl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    tgl.Text = "  "..text; tgl.TextColor3 = Color3.new(1,1,1); tgl.Font = Enum.Font.SourceSans; tgl.TextSize = 15; tgl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tgl)
    local dot = Instance.new("Frame", tgl)
    dot.Size = UDim2.new(0, 20, 0, 20); dot.Position = UDim2.new(1, -32, 0.5, -10); dot.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    tgl.MouseButton1Click:Connect(function()
        _G.Configs[configKey] = not _G.Configs[configKey]
        dot.BackgroundColor3 = _G.Configs[configKey] and Color3.new(0, 1, 1) or Color3.new(0.2, 0.2, 0.2)
    end)
end

local function createTab(name, index)
    local pg = Instance.new("ScrollingFrame", PagesContainer)
    pg.Size = UDim2.new(1, 0, 1, 0); pg.BackgroundTransparency = 1; pg.Visible = (index == 1); pg.ScrollBarThickness = 0
    Pages[name] = pg
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 42); btn.Position = UDim2.new(0, 0, 0, (index-1)*42); btn.BackgroundTransparency = 1
    btn.Text = name; btn.TextColor3 = (index==1) and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
    btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end; pg.Visible = true
        for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.new(0.6,0.6,0.6) end end
        btn.TextColor3 = Color3.new(1,1,1)
    end)
    return pg
end

local farm = createTab("Tab Farm", 1)
local function lb(txt, pos)
    local l = Instance.new("TextLabel", farm); l.Size = UDim2.new(1,0,0,25); l.Position = UDim2.new(0,5,0,pos)
    l.Text = txt:upper(); l.TextColor3 = Color3.new(0,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.SourceSansBold; l.TextSize = 13
end

lb("Lựa Chọn Công Cụ", 5)
createDropdown(farm, "Công Cụ", 32, {"Melee", "Kiếm", "Trái"}, function(s) end)

lb("Farm Cấp Độ", 85)
createToggle(farm, "Tự Động Farm Level", 115, "AutoFarmLevel")
createToggle(farm, "Tự Động Farm Quái Gần Nhất", 158, "AutoFarmNearest")

lb("Farm Xương", 205)
createToggle(farm, "Tự Động Farm Xương", 235, "AutoBones")

lb("Farm Rương & Nhặt Berry", 285)
createToggle(farm, "Tự Động Farm Rương [Tween]", 315, "AutoChestTween")
createToggle(farm, "Tự Động Nhặt Berry", 358, "AutoBerry")

createTab("Tab Nhiệm Vụ", 2)
createTab("Tab Sự Kiện Biển", 3)
createTab("Tab Điểm Chỉ Số", 4)
createTab("Tab Dịch Chuyển", 5)
createTab("Tab Cài Đặt", 6)
