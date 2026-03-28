if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().Settings = getgenv().Settings or {
    JoinTeam = true,
    Team = "Pirates"
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

local function GetCommF()
    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if Remotes then
        return Remotes:FindFirstChild("CommF_")
    end
end

local function JoinTeam()
    local CommF = GetCommF()
    if not CommF then return end

    if LocalPlayer.Team == nil then
        pcall(function()
            CommF:InvokeServer("SetTeam", getgenv().Settings.Team)
        end)
    end
end

if getgenv().Settings.JoinTeam then
    JoinTeam()
end

getgenv().DodgeHP = 3500
getgenv().AutoKen = true

local function Predict(target)
    local hrp = target.Character.HumanoidRootPart
    local vel = hrp.Velocity

    if vel.Y < -5 then vel = vel * Vector3.new(1, 0, 1) end 
    
    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local t = math.clamp(ping + 0.1, 0.1, 0.3)
    return hrp.Position + (vel * t)
end

local function Aim(target)
    local hrp = LocalPlayer.Character.HumanoidRootPart
    hrp.CFrame = CFrame.new(hrp.Position, Predict(target))
end

local function Stick(target)
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local pos = Predict(target)
    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(pos + Vector3.new(math.random(-3,3),3,math.random(-3,3))),0.6)
end

local function UseSkill(key, hold)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(hold or 0)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function GetTarget()
    local best, score = nil, math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team then
            local char = v.Character
            if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                local hp = char.Humanoid.Health
                if hp > 0 then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    local s = hp + dist
                    if s < score then
                        score = s
                        best = v
                    end
                end
            end
        end
    end

    return best
end

local function IsWeapon(tool)
    return tool:IsA("Tool") and tool:FindFirstChild("Handle")
end

local function GetWeapons()
    local list = {}
    for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
        if IsWeapon(v) then table.insert(list, v.Name) end
    end
    for _, v in pairs(LocalPlayer.Character:GetChildren()) do
        if IsWeapon(v) then table.insert(list, v.Name) end
    end
    return list
end

local function Equip(name)
    local tool = LocalPlayer.Backpack:FindFirstChild(name)
    if tool then
        LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end

local function SpamSkill(target)
    local keys = {"Z","X","C","V","F"}

    for i = #keys, 2, -1 do
        local j = math.random(1,i)
        keys[i], keys[j] = keys[j], keys[i]
    end

    for _, key in pairs(keys) do
        Aim(target)
        UseSkill(key, 0)
        task.wait(0.08)
    end
end

local function Combat(target)
    local weapons = GetWeapons()

    for i = #weapons, 2, -1 do
        local j = math.random(1,i)
        weapons[i], weapons[j] = weapons[j], weapons[i]
    end

    for _, w in pairs(weapons) do
        Equip(w)
        SpamSkill(target)
        task.wait(0.1)
    end
end

local function Escape()
    local hrp = LocalPlayer.Character.HumanoidRootPart
    hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-50,50),60,math.random(-50,50))
end

local lastHP = 0
local function AntiCombo()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    local hp = hum.Health

    if lastHP ~= 0 and (lastHP - hp) > 800 then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Ken", true)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("ActivateAbility")
        end)

        for i=1,3 do
            Escape()
            task.wait(0.1)
        end
    end

    lastHP = hp
end

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoKen then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Ken", true)
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("ActivateAbility")
        end)
    end
end)

local NoPvP = 0

local function ServerHop()
    local id = game.PlaceId
    local data = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..id.."/servers/Public?limit=100"))

    for _, v in pairs(data.data) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(id, v.id)
            break
        end
    end
end

task.spawn(function()
    while task.wait() do
        pcall(function()
            local target = GetTarget()

            AntiCombo()

            if target and target.Character then
                local hp = LocalPlayer.Character.Humanoid.Health

                if hp < getgenv().DodgeHP then
                    Escape()
                else
                    Stick(target)
                    Aim(target)
                    Combat(target)
                end

                NoPvP = 0
            else
                NoPvP += 1
            end

            if NoPvP > 60 then
                ServerHop()
            end
        end)
    end
end)