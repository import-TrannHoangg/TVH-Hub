local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

_G.Configs = _G.Configs or {
    AutoFarmLevel = false,
    AutoFarmNearest = false,
    AutoBones = false,
    AutoKillSoulReaper = false,
    AutoTradeBones = false,
    AutoPray = false,
    AutoTryLuck = false,
    FarmKatakuri = false,
    FarmKatakuriV2 = false,
    AutoBerry = false,
    AutoChestTween = false,
    AutoChestBypass = false,
    AntiAFK = false,
    AutoCode = false,
    WhiteScreen = false,
    FPSBooster = false,
    HideFarObjects = false,
    AutoFPSBoost = false,
    MobileMode = false,
    SelectedWeapon = "Cận Chiến",
}

local BloxFruitsCodes = {
    "KITT_RESET",
    "SUB2OFFICIALNOOBIE",
    "AXIORE",
    "TANTAIGAMING",
    "STRAWHATMAINE",
    "SUB2NOOBMASTER123",
    "BIGNEWS",
    "THEGREATACE",
    "SUB2UNCLEKIZARU",
    "SUB2DAIGROCK",
    "FUDD10",
    "FUDD10_V2",
}

local function RedeemCode(code)
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
    end)
end

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

    elseif key == "AutoFarmNearest" then
        task.spawn(function()
            while _G.Configs.AutoFarmNearest do
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

    elseif key == "AutoKillSoulReaper" then
        task.spawn(function()
            while _G.Configs.AutoKillSoulReaper do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "AutoTradeBones" then
        task.spawn(function()
            while _G.Configs.AutoTradeBones do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "AutoPray" then
        task.spawn(function()
            while _G.Configs.AutoPray do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "AutoTryLuck" then
        task.spawn(function()
            while _G.Configs.AutoTryLuck do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "FarmKatakuri" then
        task.spawn(function()
            while _G.Configs.FarmKatakuri do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "FarmKatakuriV2" then
        task.spawn(function()
            while _G.Configs.FarmKatakuriV2 do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "AutoBerry" then
        task.spawn(function()
            while _G.Configs.AutoBerry do
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

    elseif key == "AutoChestBypass" then
        task.spawn(function()
            while _G.Configs.AutoChestBypass do
                pcall(function()
                end)
                task.wait(0.1)
            end
        end)

    elseif key == "AntiAFK" then
        local Players = game:GetService("Players")
        local VirtualUser = game:GetService("VirtualUser")

        local function connectAntiAFK()
            if _G.__AntiAFKConnection then return end

            local player = Players.LocalPlayer
            if not player then return end

            _G.__AntiAFKConnection = player.Idled:Connect(function()
                if _G.Configs.AntiAFK then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        end

        local function disconnectAntiAFK()
            if _G.__AntiAFKConnection then
                _G.__AntiAFKConnection:Disconnect()
                _G.__AntiAFKConnection = nil
            end
        end

        if state then
            connectAntiAFK()

            if not _G.__AntiAFKRespawn then
                _G.__AntiAFKRespawn = Players.LocalPlayer.CharacterAdded:Connect(function()
                    task.wait(2)
                    if _G.Configs.AntiAFK then
                        connectAntiAFK()
                    end
                end)
            end
        else
            disconnectAntiAFK()
        end

    elseif key == "AutoCode" then
        task.spawn(function()
            if _G.__CodesRedeemed then return end
            _G.__CodesRedeemed = true

            for _, code in ipairs(BloxFruitsCodes) do
                if not _G.Configs.AutoCode then break end
                RedeemCode(code)
                task.wait(1)
            end
        end)

    elseif key == "FPSBoost" then
        if state then
            local Lighting = game:GetService("Lighting")
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            Lighting.Brightness = 1
            Lighting.Technology = Enum.Technology.Compatibility

            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end

    elseif key == "HideFarMap" then
        task.spawn(function()
            while _G.Configs.HideFarMap do
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = player.Character.HumanoidRootPart.Position

                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
                            if (v.Position - pos).Magnitude > 300 then
                                v.LocalTransparencyModifier = 1
                            else
                                v.LocalTransparencyModifier = 0
                            end
                        end
                    end
                end
                task.wait(2)
            end
        end)

    elseif key == "AutoLowFPS" then
        task.spawn(function()
            while _G.Configs.AutoLowFPS do
                local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
                if fps < 30 then
                    _G.Configs.FPSBoost = true
                end
                task.wait(5)
            end
        end)

    elseif key == "MobileMode" then
        if state then
            local Lighting = game:GetService("Lighting")
            Lighting.GlobalShadows = false
            Lighting.Brightness = 0
            Lighting.FogEnd = 1e6
            Lighting.Technology = Enum.Technology.Compatibility

            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                end
                if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
        end
    end
end

local UserInputService = game:GetService("UserInputService")
local function MakeDraggable(frame)
    local dragging = false
    local dragInput, startPos, startFramePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(
                startFramePos.X.Scale,
                startFramePos.X.Offset + delta.X,
                startFramePos.Y.Scale,
                startFramePos.Y.Offset + delta.Y
            )
        end
    end)
end

local IconGui = Instance.new("ScreenGui", guiParent)
IconGui.Name = "IconGui"
IconGui.ResetOnSpawn = false
IconGui.DisplayOrder = 999

local Icon = Instance.new("ImageButton", IconGui)
Icon.Size = UDim2.new(0, 55, 0, 55)
Icon.Position = UDim2.new(0, 15, 0.5, -27)
Icon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Icon.Active = true
MakeDraggable(Icon)
Icon.ClipsDescendants = true
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1, 0)

local AvatarLogo = Instance.new("ImageLabel", Icon)
AvatarLogo.Size = UDim2.new(1, 0, 1, 0)
AvatarLogo.AnchorPoint = Vector2.new(0.5, 0.5)
AvatarLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
AvatarLogo.BackgroundTransparency = 1
AvatarLogo.Image = "rbxassetid://107925154921311"
AvatarLogo.ScaleType = Enum.ScaleType.Crop

local stroke = Instance.new("UIStroke", Icon)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 255, 255)

local MainGui = Instance.new("ScreenGui", guiParent)
MainGui.Name = "MainGui"
MainGui.ResetOnSpawn = false
MainGui.Enabled = true

local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0, 600, 0, 420)
Main.Position = UDim2.new(0.5, -300, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false
Main.Active = true
MakeDraggable(Main)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

Icon.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1

local SmallIcon = Instance.new("ImageLabel", TopBar)
SmallIcon.Size = UDim2.new(0, 28, 0, 28)
SmallIcon.Position = UDim2.new(0, 10, 0, 6)
SmallIcon.BackgroundTransparency = 1
SmallIcon.Image = "rbxassetid://107925154921311"

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.Text = "TVH Hub - by Trần Văn Hoàng"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

local Separator = Instance.new("Frame", Main)
Separator.Size = UDim2.new(1, -20, 0, 1)
Separator.Position = UDim2.new(0, 10, 0, 40)
Separator.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Separator.BorderSizePixel = 0
Separator.BackgroundTransparency = 0.3

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Instance.new("UICorner", Sidebar)

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1, -170, 1, -50)
PagesContainer.Position = UDim2.new(0, 170, 0, 45)
PagesContainer.BackgroundTransparency = 1

local Pages = {}

local function createTab(name, index)
    local pg = Instance.new("ScrollingFrame", PagesContainer)
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = (index == 1)
    pg.ScrollBarThickness = 0
    Pages[name] = pg

    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, (index-1)*42)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = (index==1) and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        pg.Visible = true
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                b.TextColor3 = Color3.new(0.6,0.6,0.6)
            end
        end
        btn.TextColor3 = Color3.new(1,1,1)
    end)

    return pg
end

local function createWeaponDropdown(parent, text, yPos, options)
    local isOpened = false

    local dropFrame = Instance.new("Frame", parent)
    dropFrame.Size = UDim2.new(1, -10, 0, 38)
    dropFrame.Position = UDim2.new(0, 5, 0, yPos)
    dropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    dropFrame.ClipsDescendants = true
    Instance.new("UICorner", dropFrame)

    local stroke = Instance.new("UIStroke", dropFrame)
    stroke.Color = Color3.fromRGB(0,255,255)
    stroke.Transparency = 0.7

    local btn = Instance.new("TextButton", dropFrame)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundTransparency = 1
    btn.Text = "  "..text..": ".._G.Configs.SelectedWeapon
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left

    local arrow = Instance.new("TextLabel", btn)
    arrow.Size = UDim2.new(0, 38, 1, 0)
    arrow.Position = UDim2.new(1, -38, 0, 0)
    arrow.Text = "v"
    arrow.TextColor3 = Color3.fromRGB(0,255,255)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.GothamBold

    btn.MouseButton1Click:Connect(function()
        isOpened = not isOpened
        dropFrame:TweenSize(
            isOpened and UDim2.new(1,-10,0,38 + (#options*32)) or UDim2.new(1,-10,0,38),
            "Out","Quad",0.2,true
        )
        arrow.Text = isOpened and "^" or "v"
    end)

    for i,v in ipairs(options) do
        local opt = Instance.new("TextButton", dropFrame)
        opt.Size = UDim2.new(1, -10, 0, 28)
        opt.Position = UDim2.new(0, 5, 0, 38 + (i-1)*32)
        opt.Text = v
        opt.BackgroundColor3 = Color3.fromRGB(45,45,45)
        opt.TextColor3 = Color3.new(1,1,1)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        Instance.new("UICorner", opt)

        opt.MouseButton1Click:Connect(function()
            _G.Configs.SelectedWeapon = v
            btn.Text = "  "..text..": "..v
            isOpened = false
            dropFrame:TweenSize(UDim2.new(1,-10,0,38),"Out","Quad",0.2,true)
            arrow.Text = "v"
            
            ExecuteLogic("SelectedWeapon", v)
        end)
    end
end

local function createToggle(parent, text, yPos, configKey)
    _G.Configs[configKey] = _G.Configs[configKey] or false

    local tgl = Instance.new("TextButton", parent)
    tgl.Size = UDim2.new(1, -10, 0, 38)
    tgl.Position = UDim2.new(0, 5, 0, yPos)
    tgl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    tgl.Text = "  "..text
    tgl.TextColor3 = Color3.new(1,1,1)
    tgl.Font = Enum.Font.Gotham
    tgl.TextSize = 14
    tgl.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", tgl)

    local dot = Instance.new("Frame", tgl)
    dot.Size = UDim2.new(0, 20, 0, 20)
    dot.Position = UDim2.new(1, -32, 0.5, -10)
    dot.BackgroundColor3 = _G.Configs[configKey] and Color3.fromRGB(0,255,255) or Color3.fromRGB(50,50,50)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function updateToggle()
        local color = _G.Configs[configKey] and Color3.fromRGB(0,255,255) or Color3.fromRGB(50,50,50)
        TweenService:Create(dot, tweenInfo, {BackgroundColor3 = color}):Play()
    end

    tgl.MouseButton1Click:Connect(function()
        _G.Configs[configKey] = not _G.Configs[configKey]
        updateToggle()

        ExecuteLogic(configKey, _G.Configs[configKey])
    end)
end

local function AutoCanvasSize(scrollingFrame, padding)
    padding = padding or 10

    local function update()
        local maxY = 0
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                local bottom = child.Position.Y.Offset + child.Size.Y.Offset
                if bottom > maxY then
                    maxY = bottom
                end
            end
        end
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, maxY + padding)
    end

    scrollingFrame.ChildAdded:Connect(update)
    scrollingFrame.ChildRemoved:Connect(update)

    update()
end

local farm = createTab("Tab Farm", 1)
AutoCanvasSize(farm)

local function label(txt, pos)
    local l = Instance.new("TextLabel", farm)
    l.Size = UDim2.new(1,0,0,25)
    l.Position = UDim2.new(0,5,0,pos)
    l.Text = txt:upper()
    l.TextColor3 = Color3.fromRGB(0,255,255)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
end

label("Lựa Chọn Công Cụ", 5)
createWeaponDropdown(farm, "Công Cụ", 32, {"Cận Chiến", "Kiếm", "Trái Ác Quỷ"})

label("Farm Cấp Độ", 85)
createToggle(farm, "Tự Động Farm Level", 115, "AutoFarmLevel")
createToggle(farm, "Tự Động Farm Quái Gần Nhất", 145, "AutoFarmNearest")

label("Farm Xương", 185)
createToggle(farm, "Tự Động Farm Xương", 215, "AutoBones")
createToggle(farm, "Tự Động Giết Soul Reaper", 245, "AutoKillSoulReaper")
createToggle(farm, "Tự Động Trao Đổi Xương", 275, "AutoTradeBones")
createToggle(farm, "Tự Động Cầu Nguyện", 305, "AutoPray")
createToggle(farm, "Tự Động Thử Vận May", 335, "AutoTryLuck")

label("Farm Katakuri", 375)
createToggle(farm, "Farm Katakuri", 405, "FarmKatakuri")
createToggle(farm, "Farm Katakuri V2", 435, "FarmKatakuriV2")

label("Farm Rương & Nhặt Berry", 475)
createToggle(farm, "Tự Động Nhặt Berry", 505, "AutoBerry")
createToggle(farm, "Tự Động Farm Rương [Tween]", 535, "AutoChestTween")
createToggle(farm, "Tự Động Farm Rương [Bypass]", 565, "AutoChestBypass")

createTab("Tab Nhiệm Vụ / Vật Phẩm", 2)
createTab("Tab Câu Cá", 3)
createTab("Tab Sự Kiện Biển", 4)
createTab("Tab Raid / Trái Ác Quỷ", 5)
createTab("Tab Điểm Chỉ Số", 6)
createTab("Tab Dịch Chuyển", 7)
createTab("Tab Trạng Thái", 8)
createTab("Tab Thị Giác", 9)
createTab("Tab Cửa Hàng", 10)

local settings = createTab("Tab Cài Đặt", 11)
AutoCanvasSize(settings)

local function createLabel(parent, txt, pos)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1,0,0,25)
    l.Position = UDim2.new(0,5,0,pos)
    l.Text = txt:upper()
    l.TextColor3 = Color3.fromRGB(0,255,255)
    l.BackgroundTransparency = 1
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
end

createLabel(settings, "Hệ Thống", 5)
createToggle(settings, "Chống Treo Máy (Anti-AFK)", 32, "AntiAFK")
createToggle(settings, "Giảm Lag (White Screen)", 70, "WhiteScreen")
createToggle(settings, "FPS Booster", 180, "FPSBooster")
createToggle(settings, "Ẩn Map Xa & Quái Xa", 210, "HideFarObjects")
createToggle(settings, "Tự Bật Khi FPS Thấp", 240, "AutoFPSBoost")
createToggle(settings, "Chế Độ Mobile Siêu Nhẹ", 270, "MobileMode")

createLabel(settings, "Tiện Ích", 120)
createToggle(settings, "Tự Động Nhập Code", 147, "AutoCode")
