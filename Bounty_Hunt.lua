--// LOAD
repeat task.wait() until game:IsLoaded()

--// SETTINGS
getgenv().Settings = {
    JoinTeam = true,
    Team = "Pirates",
    DodgeHP = 3500,
    AutoKen = true
}

--// SERVICES
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TP = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local VIM = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer

--// REMOTE
local function CommF()
    return RS:WaitForChild("Remotes"):WaitForChild("CommF_")
end

--// JOIN TEAM
if getgenv().Settings.JoinTeam and not LP.Team then
    pcall(function()
        CommF():InvokeServer("SetTeam", getgenv().Settings.Team)
    end)
end

--// VALID TARGET
local function IsValidTarget(plr)
    if not plr or plr == LP then return false end
    if plr.Team == LP.Team then return false end

    local char = plr.Character
    if not char then return false end

    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not hum or not hrp then return false end
    if hum.Health <= 0 then return false end

    -- Safe zone
    if char:FindFirstChild("ForceField") then return false end

    -- PvP check
    local data = plr:FindFirstChild("Data")
    if data and data:FindFirstChild("PvPEnabled") then
        if not data.PvPEnabled.Value then return false end
    end

    return true
end

--// GET TARGET
local function GetTarget()
    local best, dist = nil, math.huge

    for _,v in pairs(Players:GetPlayers()) do
        if IsValidTarget(v) then
            local d = (LP.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                best = v
            end
        end
    end

    return best
end

--// PREDICT
local function Predict(plr)
    local hrp = plr.Character.HumanoidRootPart
    local vel = hrp.Velocity

    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    local t = math.clamp(0.12 + ping, 0.12, 0.25)

    if math.abs(vel.Y) > 50 then
        vel = Vector3.new(vel.X, 0, vel.Z)
    end

    return hrp.Position + vel * t
end

--// AIM
local function Aim(target)
    local hrp = LP.Character.HumanoidRootPart
    local pos = Predict(target)

    hrp.CFrame = hrp.CFrame:Lerp(
        CFrame.new(hrp.Position, pos),
        0.2
    )
end

--// STICK
local lastPos = nil
local function Stick(target)
    local hrp = LP.Character.HumanoidRootPart
    local pos = Predict(target)

    local offset = Vector3.new(
        math.random(-2,2),
        2,
        math.random(-2,2)
    )

    local goal = pos + offset

    if lastPos then
        goal = lastPos:Lerp(goal, 0.3)
    end

    lastPos = goal

    hrp.CFrame = hrp.CFrame:Lerp(
        CFrame.new(goal),
        0.25
    )
end

--// MOVE LIMIT
local lastMove = 0
local function CanMove()
    if tick() - lastMove > 0.05 then
        lastMove = tick()
        return true
    end
end

--// WEAPON
local function GetWeapons()
    local t = {}
    for _,v in pairs(LP.Backpack:GetChildren()) do
        if v:IsA("Tool") then table.insert(t, v.Name) end
    end
    return t
end

local function Equip(name)
    local tool = LP.Backpack:FindFirstChild(name)
    if tool then
        LP.Character.Humanoid:EquipTool(tool)
    end
end

--// SKILL
local function UseSkill(key)
    VIM:SendKeyEvent(true, key, false, game)
    task.wait(math.random(5,15)/100)
    VIM:SendKeyEvent(false, key, false, game)
end

local function SpamSkill(target)
    local keys = {"Z","X","C","V","F"}

    for _,k in pairs(keys) do
        Aim(target)
        UseSkill(k)
        task.wait(math.random(5,10)/100)
    end
end

--// COMBAT
local function Combat(target)
    local weapons = GetWeapons()

    for i = #weapons, 2, -1 do
        local j = math.random(1,i)
        weapons[i], weapons[j] = weapons[j], weapons[i]
    end

    for _,w in pairs(weapons) do
        Equip(w)
        SpamSkill(target)
    end
end

--// ESCAPE
local function Escape()
    local hrp = LP.Character.HumanoidRootPart

    for i = 1, 3 do
        hrp.CFrame = hrp.CFrame + Vector3.new(
            math.random(-60,60),
            math.random(40,60),
            math.random(-60,60)
        )
        task.wait(0.05)
    end
end

--// ANTI COMBO
local lastHP = 0
local function AntiCombo()
    local hum = LP.Character:FindFirstChild("Humanoid")
    if not hum then return end

    local hp = hum.Health

    if lastHP ~= 0 and (lastHP - hp) > 700 then
        pcall(function()
            CommF():InvokeServer("Ken", true)
            CommF():InvokeServer("ActivateAbility")
        end)
        Escape()
    end

    lastHP = hp
end

--// AUTO KEN
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Settings.AutoKen then
            pcall(function()
                CommF():InvokeServer("Ken", true)
            end)
        end
    end
end)

--// ABILITY
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            CommF():InvokeServer("ActivateAbility")
        end)
    end
end)

--// SERVER HOP
local function ServerHop()
    local id = game.PlaceId
    local data = Http:JSONDecode(game:HttpGet(
        "https://games.roblox.com/v1/games/"..id.."/servers/Public?limit=100"
    ))

    for _,v in pairs(data.data) do
        if v.playing < v.maxPlayers then
            TP:TeleportToPlaceInstance(id, v.id)
            break
        end
    end
end

--// MAIN
local idle = 0

task.spawn(function()
    while task.wait() do
        pcall(function()
            local target = GetTarget()

            AntiCombo()

            if target then
                local hp = LP.Character.Humanoid.Health

                if hp < getgenv().Settings.DodgeHP then
                    Escape()
                else
                    if CanMove() then
                        Stick(target)
                        Aim(target)
                    end
                    Combat(target)
                end

                idle = 0
            else
                idle += 1
            end

            if idle > 60 then
                ServerHop()
            end
        end)
    end
end)
