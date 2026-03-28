if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().Settings = {
    JoinTeam = true,
    Team = "Pirates"
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

if getgenv().Settings.JoinTeam then
    local args = {
        getgenv().Settings.Team
    }
    ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", unpack(args))
end

local Config = {
    Main = {
        AutoFruit = true,
        AutoStoreFruit = true
    },

    Server = {
        HopDelay = 15,
        MaxServersCheck = 100
    },

    Performance = {
        LoopDelay = 1.5,
        SaveCooldown = 2
    },

    Data = {
        FruitLog = {}
    }
}

local function LoadFruitLog()
    if isfile("Fruit_Log.json") then
        Config.Data.FruitLog = HttpService:JSONDecode(readfile("Fruit_Log.json"))
    end
end

local function SaveFruitLog()
    writefile("Fruit_Log.json", HttpService:JSONEncode(Config.Data.FruitLog))
end

local function LogFruit(fruitName)
    table.insert(Config.Data.FruitLog, {
        fruit = fruitName,
        time = os.date("%Y-%m-%d %H:%M:%S")
    })
    SaveFruitLog()
end

task.wait(1)

local function ApplyFruitESP(part, name)
    if part:FindFirstChild("FruitESP") then return end

    local bgu = Instance.new("BillboardGui")
    bgu.Name = "FruitESP"
    bgu.Parent = part
    bgu.AlwaysOnTop = true
    bgu.Size = UDim2.new(0, 120, 0, 40)
    bgu.MaxDistance = 20000

    local txt = Instance.new("TextLabel", bgu)
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.fromRGB(255, 170, 0)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextScaled = true

    task.spawn(function()
        while part and part.Parent and Config.Main.AutoFruit do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((char.HumanoidRootPart.Position - part.Position).Magnitude)
                txt.Text = name .. " [" .. dist .. "m]"
            end
            task.wait(0.2)
        end
        bgu:Destroy()
    end)
end

local function GetAllFruits()
    local fruits = {}

    for _, v in pairs(workspace:GetDescendants()) do
        
        if v:IsA("Tool") and v.Name:find("Fruit") then
            table.insert(fruits, v)

        elseif v:IsA("Model") and (v.Name == "Fruit" or v.Name == "fruit") then
            table.insert(fruits, v)

        end

    end

    return fruits
end

local function CollectItem(item)
    if not item then return false end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end

    if item:IsA("Tool") then
        local handle = item:FindFirstChild("Handle")
        if handle then
            handle.CFrame = char.HumanoidRootPart.CFrame
            task.wait(0.3)
            return not item:IsDescendantOf(workspace)
        end

    elseif item:IsA("Model") then
        local basePart = item:FindFirstChildWhichIsA("BasePart")
        if basePart then
            for i = 1, 20 do
                char.HumanoidRootPart.CFrame = basePart.CFrame + Vector3.new(0,3,0)
                task.wait(0.1)
                if not item:IsDescendantOf(workspace) then
                    return true
                end
            end
        end
    end

    return false
end

local function HopServer()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    
    local success, result = pcall(function()
        local auth = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        return game:HttpGet(auth)
    end)
    
    if success then
        local data = HttpService:JSONDecode(result)
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id)
                    return
                end
            end
        end
    end
    TeleportService:Teleport(PlaceId)
end

local function CreateUI()
    local ui = {}
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "FruitFinder_Premium"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -180)
    MainFrame.Size = UDim2.new(0, 320, 0, 360)
    
    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 10)
    
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(45, 45, 50)
    MainStroke.Thickness = 1.5

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    
    local TopCorner = Instance.new("UICorner", TopBar)
    TopCorner.CornerRadius = UDim.new(0, 10)
    
    local Cover = Instance.new("Frame", TopBar)
    Cover.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    Cover.BorderSizePixel = 0
    Cover.Position = UDim2.new(0, 0, 1, -5)
    Cover.Size = UDim2.new(1, 0, 0, 5)

    local Title = Instance.new("TextLabel", TopBar)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -30, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Script Tìm Trái Ác Quỷ"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Author = Instance.new("TextLabel", TopBar)
    Author.BackgroundTransparency = 1
    Author.Position = UDim2.new(0, 0, 0, 0)
    Author.Size = UDim2.new(1, -15, 1, 0)
    Author.Font = Enum.Font.Gotham
    Author.Text = "by Tr.Hoàng"
    Author.TextColor3 = Color3.fromRGB(150, 150, 150)
    Author.TextSize = 12
    Author.TextXAlignment = Enum.TextXAlignment.Right

    local Content = Instance.new("Frame", MainFrame)
    Content.BackgroundTransparency = 1
    Content.Position = UDim2.new(0, 15, 0, 60)
    Content.Size = UDim2.new(1, -30, 1, -75)

    local ToggleButton = Instance.new("TextButton", Content)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    ToggleButton.Size = UDim2.new(1, 0, 0, 40)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "Tự Động Tìm Trái : Bật"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14
    ToggleButton.AutoButtonColor = false
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 6)
    
    local StatusBox = Instance.new("Frame", Content)
    StatusBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    StatusBox.Position = UDim2.new(0, 0, 0, 50)
    StatusBox.Size = UDim2.new(1, 0, 0, 35)
    Instance.new("UICorner", StatusBox).CornerRadius = UDim.new(0, 6)
    
    local StatusLabel = Instance.new("TextLabel", StatusBox)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Text = "Trạng Thái : Đang Khởi Tạo ..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 13

    local LogLabelTitle = Instance.new("TextLabel", Content)
    LogLabelTitle.BackgroundTransparency = 1
    LogLabelTitle.Position = UDim2.new(0, 5, 0, 95)
    LogLabelTitle.Size = UDim2.new(0, 100, 0, 20)
    LogLabelTitle.Font = Enum.Font.GothamBold
    LogLabelTitle.Text = "Log Trái"
    LogLabelTitle.TextColor3 = Color3.fromRGB(100, 100, 110)
    LogLabelTitle.TextSize = 11
    LogLabelTitle.TextXAlignment = Enum.TextXAlignment.Left

    local LogFrame = Instance.new("ScrollingFrame", Content)
    LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    LogFrame.BorderSizePixel = 0
    LogFrame.Position = UDim2.new(0, 0, 0, 115)
    LogFrame.Size = UDim2.new(1, 0, 1, -115)
    LogFrame.ScrollBarThickness = 2
    LogFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    LogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 6)
    
    local LogLayout = Instance.new("UIListLayout", LogFrame)
    LogLayout.Padding = UDim.new(0, 5)
    LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", LogFrame).PaddingTop = UDim.new(0, 8)
    Instance.new("UIPadding", LogFrame).PaddingLeft = UDim.new(0, 10)

    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    ToggleButton.MouseButton1Click:Connect(function()
        Config.Main.AutoFruit = not Config.Main.AutoFruit
        Config.Main.AutoStoreFruit = Config.Main.AutoFruit
        
        local isEnabled = Config.Main.AutoFruit
        local targetColor = isEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
        local targetText = isEnabled and "Tự Động Tìm Trái : Bật" or "Tự Động Tìm Trái : Tắt"
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
        ToggleButton.Text = targetText
    end)

    ToggleButton.MouseEnter:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    ToggleButton.MouseLeave:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    function ui.updateLog()
        for _, child in ipairs(LogFrame:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        
        local fruitCounts = {}
        for _, entry in ipairs(Config.Data.FruitLog) do
            fruitCounts[entry.fruit] = fruitCounts[entry.fruit] or {count = 0, lastTime = entry.time}
            fruitCounts[entry.fruit].count += 1
            fruitCounts[entry.fruit].lastTime = entry.time
        end
        
        local sortedFruits = {}
        for fruit, data in pairs(fruitCounts) do
            table.insert(sortedFruits, {name = fruit, count = data.count, lastTime = data.lastTime})
        end
        
        table.sort(sortedFruits, function(a, b) return a.lastTime > b.lastTime end)
        
        for i, data in ipairs(sortedFruits) do
            local label = Instance.new("TextLabel", LogFrame)
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, -10, 0, 20)
            label.Font = Enum.Font.Gotham
            label.TextColor3 = Color3.fromRGB(220, 220, 220)
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            label.Text = data.count > 1 and 
                string.format("%s (%d) - %s", data.name, data.count, data.lastTime) or
                string.format("%s - %s", data.name, data.lastTime)
        end
    end
    
    ui.updateStatus = function(status)
        StatusLabel.Text = "Trạng Thái : " .. status
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    LoadFruitLog()
    ui.updateLog()
    
    return ui
end

local function HandleAutoStore(tool)
    if Config.Main.AutoStoreFruit and tool:IsA("Tool") and tool.Name:find("Fruit") then
        task.spawn(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", tool:GetAttribute("OriginalName"), tool)
        end)
    end
end

local function StartFruitFinder()
    local ui = CreateUI()
    local lastServerHop = tick()
    local collecting = false
    
    while task.wait(1) do
        if Config.Main.AutoFruit and not collecting then
            pcall(function()
                local foundFruit = false
                local collected = false
                
                for _, v in ipairs(workspace:GetDescendants()) do
                    
                    local isTool = v:IsA("Tool") and (v.Name:lower():find("fruit") or v.Name:find("Trái"))
                    local isSpawn = v:IsA("Model") and (v.Name == "Fruit" or v.Name == "fruit")

                    if isTool or isSpawn then
                        foundFruit = true
                        collecting = true

                        local name = isTool and v.Name or "Trái Ác Quỷ"
                        local part = v:FindFirstChild("Handle") or v:FindFirstChildWhichIsA("BasePart")

                        if part then
                            ApplyFruitESP(part, name)
                        end

                        ui.updateStatus("Tìm Thấy Trái " .. name)

                        if CollectItem(v) then
                            collected = true
                            ui.updateLog()
                        end

                        collecting = false
                        break
                    end
                    
                end
                
                if collected and Config.Main.AutoStoreFruit then
                    ui.updateStatus("Đang Kiểm Tra Túi Đồ...")
                    task.wait(1.5)

                    local hasStoredAnything = false
                    local inventory = {}
                    
                    for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do table.insert(inventory, v) end
                    for _, v in ipairs(LocalPlayer.Character:GetChildren()) do table.insert(inventory, v) end

                    for _, item in ipairs(inventory) do
                        if item:IsA("Tool") and (item.Name:find("Fruit") or item.Name:find("Trái")) then
                            ui.updateStatus("Đang Cất Trái " .. item.Name)
                            
                            local success = HandleAutoStore(item)
                            
                            if success then
                                hasStoredAnything = true
                                LogFruit(item.Name)
                            end
                            task.wait(0.5)
                        end
                    end

                    if hasStoredAnything then
                        ui.updateStatus("Hoàn Tất Việc Lưu Trữ Trái !")
                    else
                        ui.updateStatus("Không Cất Được Trái Nào Do Rương Đầy !")
                    end
                    task.wait(1)
                end
                
                if not foundFruit then
                    if tick() - lastServerHop >= Config.Server.HopDelay then
                        ui.updateStatus("Đang Đổi Server...")
                        task.wait(1)
                        HopServer()
                        lastServerHop = tick()
                    end
                end
            end)
        end
    end
end

task.spawn(function()
    while task.wait() do
        if Config.Main.AutoStoreFruit then
            pcall(function()
                for _, fr in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    HandleAutoStore(fr)
                end
                for _, fr in ipairs(LocalPlayer.Character:GetChildren()) do
                    HandleAutoStore(fr)
                end
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(HandleAutoStore)
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(HandleAutoStore)
end

print("✅️ Load Script Tìm Trái Thành Công !")
StartFruitFinder()