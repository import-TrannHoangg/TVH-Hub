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

local FILE = "TVH-Hub_Config.json"

local function SaveConfig()
    if writefile then
        writefile(FILE, HttpService:JSONEncode(State))
    end
end

local function LoadConfig()
    if readfile and isfile and isfile(FILE) then
        local status, data = pcall(function() return HttpService:JSONDecode(readfile(FILE)) end)
        if status then
            for k,v in pairs(data) do State[k] = v end
        end
    end
end
LoadConfig()

local FPS = 60
RunService.RenderStepped:Connect(function(dt)
    FPS = math.floor(1/dt)
end)

local PlayerGui = player:WaitForChild("PlayerGui")
local FPSLabel = Instance.new("TextLabel", PlayerGui)
FPSLabel.Size = UDim2.new(0,200,0,30)
FPSLabel.Position = UDim2.new(0.5,-100,0,5)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 18
FPSLabel.TextColor3 = Color3.fromRGB(0,170,255)

RunService.RenderStepped:Connect(function()
    FPSLabel.Text = "FPS : "..FPS
end)

local function FixLagOptimize()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Technology = Enum.Technology.Compatibility
    Lighting.Brightness = 1

    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        elseif v:IsA("Explosion") then
            v.BlastPressure = 0
            v.BlastRadius = 0
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0.5
        end
    end
end

local function HiddenIsland()
    local camPos = workspace.CurrentCamera.CFrame.Position
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
            local dist = (v.Position - camPos).Magnitude
            if State.HiddenIsland and dist > 300 then
                v.LocalTransparencyModifier = 1
            else
                v.LocalTransparencyModifier = 0
            end
        end
    end
end

local function FixLagMode()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.FogEnd = 9e9
    
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0.8
        end
    end
end

local function HideNPCs()
    local camPos = workspace.CurrentCamera.CFrame.Position
    for _,npc in pairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc ~= player.Character then
            local root = npc:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - camPos).Magnitude
                for _,part in pairs(npc:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.LocalTransparencyModifier = (State.HideNPCs and dist > 250) and 1 or 0
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(2) do
        if State.FPSBooster and FPS < 35 then
            FixLagOptimize()
        end
        if State.HiddenIsland then
            HiddenIsland()
        end
        if State.HideNPCs then
            HideNPCs()
        end
    end
end)

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
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local MainGui = Instance.new("ScreenGui", PlayerGui)
MainGui.ResetOnSpawn = false

local Icon = Instance.new("ImageButton", MainGui)
Icon.Size = UDim2.new(0, 50, 0, 50)
Icon.Position = UDim2.new(0, 10, 0.5, -25)
Icon.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", Icon).CornerRadius = UDim.new(1,0)
MakeDraggable(Icon)

local Main = Instance.new("Frame", MainGui)
Main.Size = UDim2.new(0,550,0,380)
Main.Position = UDim2.new(0.5,-275,0.5,-190)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Visible = false
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)
MakeDraggable(Main)

Icon.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,150,1,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,10)

local PagesContainer = Instance.new("Frame", Main)
PagesContainer.Size = UDim2.new(1,-160,1,-20)
PagesContainer.Position = UDim2.new(0,160,0,10)
PagesContainer.BackgroundTransparency = 1

local Pages = {}
local function CreateTab(name, order)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Size = UDim2.new(1,0,1,0)
    page.CanvasSize = UDim2.new(0,0,2,0)
    page.Visible = (order==1)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    Pages[name] = page

    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1,-10,0,40)
    btn.Position = UDim2.new(0,5,0,(order-1)*45 + 10)
    btn.Text = name
    btn.BackgroundColor3 = order==1 and Color3.fromRGB(0,170,255) or Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        for _,p in pairs(Pages) do p.Visible=false end
        page.Visible=true
        for _,b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(30,30,30) end
        end
        btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    end)
    return page
end

local function CreateToggle(parent, text, y, key, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,-10,0,45)
    frame.Position = UDim2.new(0,5,0,y)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,-60,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local switch = Instance.new("Frame", frame)
    switch.Size = UDim2.new(0,40,0,20)
    switch.Position = UDim2.new(1,-50,0.5,-10)
    switch.BackgroundColor3 = State[key] and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,60)
    Instance.new("UICorner", switch).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", switch)
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = State[key] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    btn.MouseButton1Click:Connect(function()
        State[key] = not State[key]
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = State[key] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        }):Play()
        TweenService:Create(switch, TweenInfo.new(0.2), {
            BackgroundColor3 = State[key] and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,60)
        }):Play()
        if callback then callback(State[key]) end
        SaveConfig()
    end)
end

local TabFarm = CreateTab("Tab Farm", 1)
local TabSettings = CreateTab("Tab Cài Đặt", 2)

CreateToggle(TabSettings, "FPS Booster", 10, "FPSBooster")
CreateToggle(TabSettings, "Chế Độ Fix Lag Mobile", 60, "MobileMode", function(v) if v then FixLagMode() end end)
CreateToggle(TabSettings, "Ẩn Đảo Xa", 110, "HiddenIsland")
CreateToggle(TabSettings, "Ẩn NPC Ngoài Tầm Nhìn", 160, "HideNPCs")
CreateToggle(TabSettings, "Chế Độ Siêu Nhẹ", 210, "FixLagMode", function(v) if v then FixLagOptimize() end end)
CreateToggle(TabSettings, "Hiện FPS", 260, "FPSBoost", function(v) FPSLabel.Visible = v end)
