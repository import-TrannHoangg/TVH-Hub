repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local State = {
    MasterAntiLag = false,
    ReduceFruitEffects = false,
    ReduceWeaponEffects = false,
    ReduceSelfEffects = false,
    HideFarIslands = false,
    AutoFPSBoost = false
}

local function disableEffects(model)
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Smoke")
        or v:IsA("Fire")
        or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("Explosion") then
            v.BlastPressure = 0
            v.BlastRadius = 0
        end
    end
end

local function reduceFruitEffects()
    for _, v in pairs(Workspace:GetDescendants()) do
        local n = v.Name:lower()
        if n:find("dragon") or n:find("dough")
        or n:find("tiger") or n:find("venom")
        or n:find("phoenix") then
            disableEffects(v)
        end
    end
end

local function reduceWeaponEffects()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Trail") or v:IsA("ParticleEmitter") then
            v.Enabled = false
        end
    end
end

local function reduceSelfEffects()
    if player.Character then
        disableEffects(player.Character)
    end
end

local function hideFarIslands()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Size.Magnitude > 300 then
            v.LocalTransparencyModifier = 1
        end
    end
end

local function applyFPSBoost()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    settings().Rendering.QualityLevel = 1
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TVH Fix Lag - by Trần Văn Hoàng"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 270, 0, 330)
frame.Position = UDim2.new(0, 20, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local function createToggle(label, order, stateKey, onEnable)
    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, 10 + order * 45)
    container.BackgroundTransparency = 1

    local text = Instance.new("TextLabel", container)
    text.Size = UDim2.new(0.7, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255,255,255)
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Text = label
    text.TextSize = 14

    local toggle = Instance.new("Frame", container)
    toggle.Size = UDim2.new(0, 50, 0, 22)
    toggle.Position = UDim2.new(1, -50, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
    toggle.BorderSizePixel = 0

    local knob = Instance.new("Frame", toggle)
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 1, 0, 1)
    knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
    knob.BorderSizePixel = 0

    local function update()
        if State[stateKey] then
            toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
            knob.Position = UDim2.new(1, -21, 0, 1)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(70,70,70)
            knob.Position = UDim2.new(0, 1, 0, 1)
        end
    end

    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            State[stateKey] = not State[stateKey]
            update()
            if State[stateKey] and onEnable then
                onEnable()
            end
        end
    end)

    update()
end

createToggle("Fix Lag", 0, "MasterAntiLag", function()
    applyFPSBoost()
    reduceFruitEffects()
    reduceWeaponEffects()
end)

createToggle("Giảm Hiệu Ứng Các Trái Ác Quỷ", 1, "ReduceFruitEffects", reduceFruitEffects)
createToggle("Giảm Hiệu Ứng Các Vũ Khí", 2, "ReduceWeaponEffects", reduceWeaponEffects)
createToggle("Giảm Hiệu Ứng Bản Thân", 3, "ReduceSelfEffects", reduceSelfEffects)
createToggle("Ẩn Đảo Xa", 4, "HideFarIslands", hideFarIslands)
createToggle("FPS Boost Tự Động", 5, "AutoFPSBoost")

RunService.Heartbeat:Connect(function()
    if State.MasterAntiLag then
        reduceFruitEffects()
        reduceWeaponEffects()
    end

    if State.ReduceSelfEffects then
        reduceSelfEffects()
    end

    if State.HideFarIslands then
        hideFarIslands()
    end

    if State.AutoFPSBoost then
        applyFPSBoost()
    end
end)