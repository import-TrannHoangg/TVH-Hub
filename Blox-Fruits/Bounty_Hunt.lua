local Pvp_Left = Tab.Tab_Combat:addSection()
local Setting_Pvp = Pvp_Left:addMenu('#Setting Pvp')
local Current = Setting_Pvp:addLabel("Current Bounties : ")
local Earn = Setting_Pvp:addLabel("Earned : ")

local OldBounty = game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value
local Bounty = tostring(OldBounty)
local Earned = tostring(0)
local sub = string.sub
local len = string.len

spawn(function()
    while wait() do
        pcall(function()
            local value = game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value
            Bounty = tostring(value)
            Earned = tostring(value - OldBounty)

            if len(Bounty) == 4 then
                Bounty1 = sub(Bounty,1,1).."."..sub(Bounty,2,3).."K"
            elseif len(Bounty) == 5 then
                Bounty1 = sub(Bounty,1,2).."."..sub(Bounty,3,4).."K"
            elseif len(Bounty) == 6 then
                Bounty1 = sub(Bounty,1,3).."."..sub(Bounty,4,5).."K"
            elseif len(Bounty) == 7 then
                Bounty1 = sub(Bounty,1,1).."."..sub(Bounty,2,3).."M"
            elseif len(Bounty) == 8 then
                Bounty1 = sub(Bounty,1,2).."."..sub(Bounty,3,4).."M"
            elseif len(Bounty) <= 3 then
                Bounty1 = Bounty
            end

            if len(Earned) == 4 then
                Earned1 = sub(Earned,1,1).."."..sub(Earned,2,3).."K"
            elseif len(Earned) == 5 then
                Earned1 = sub(Earned,1,2).."."..sub(Earned,3,4).."K"
            elseif len(Earned) == 6 then
                Earned1 = sub(Earned,1,3).."."..sub(Earned,4,5).."K"
            elseif len(Earned) == 7 then
                Earned1 = sub(Earned,1,1).."."..sub(Earned,2,3).."M"
            elseif len(Earned) == 8 then
                Earned1 = sub(Earned,1,2).."."..sub(Earned,3,4).."M"
            elseif len(Earned) <= 3 then
                Earned1 = Earned
            end

            if tonumber(Bounty) == 25000000 then
                Current:Refresh("Current Bounties : "..Bounty1.." [ Max ]")
            elseif tonumber(Bounty) < 25000000 then
                Current:Refresh("Current Bounties : "..Bounty1)
            end

            Earn:Refresh("Earned : "..Earned1)
        end)
    end
end)

local PvpWeaponList = {"Melee", "Sword", "Blox Fruit", "Gun"}
Setting_Pvp:addDropdown("Select Weapon", PvpSelectedWeapon, PvpWeaponList,function(Value)
    PvpSelectedWeapon = Value
end)

task.spawn(function()
    while wait() do
        pcall(function()
            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v.ToolTip == PvpSelectedWeapon then
                    if game.Players.LocalPlayer.Backpack:FindFirstChild(v.Name) then
                        SelectWeaponPvp = v.Name
                    end
                end
            end
        end)
    end
end)

local PvpTable = {"Above","Bellow","Behind"}
AutoPvpType = "Behind"

Setting_Pvp:addDropdown("Select Pvp Type", AutoPvpType, PvpTable, function(Value)
    AutoPvpType = Value
end)

DisPvp = 10

spawn(function()
    while wait() do
        if AutoPvpType == "Above" then
            Pvp_Mode = CFrame.new(0,DisPvp,0) * CFrame.Angles(math.rad(-90),0,0)
        elseif AutoPvpType == "Bellow" then
            Pvp_Mode = CFrame.new(0,-DisPvp,0) * CFrame.Angles(math.rad(90),0,0)
        elseif AutoPvpType == "Behind" then
            Pvp_Mode = CFrame.new(0,0,DisPvp)
        end
    end
end)

Setting_Pvp:addTextbox("Distance Pvp", DisPvp, function(Value)
    DisPvp = tonumber(Value) or 10
end)

Setting_Pvp:addToggle("Player ESP", _G.ESPPlayer, function(Value)
    _G.ESPPlayer = Value
end)

spawn(function()
    while wait() do
        pcall(function()
            for i,v in pairs(game.Players:GetChildren()) do
                if v.Name ~= game.Players.LocalPlayer.Name and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = v.Character.HumanoidRootPart

                    if _G.ESPPlayer then
                        if not hrp:FindFirstChild("PlayerESP") then
                            local BillboardGui = Instance.new("BillboardGui")
                            local TextLabel = Instance.new("TextLabel")

                            BillboardGui.Parent = hrp
                            BillboardGui.Name = "PlayerESP"
                            BillboardGui.AlwaysOnTop = true
                            BillboardGui.Size = UDim2.new(0,200,0,50)
                            BillboardGui.StudsOffset = Vector3.new(0,2.5,0)

                            TextLabel.Parent = BillboardGui
                            TextLabel.BackgroundTransparency = 1
                            TextLabel.Size = UDim2.new(1,0,1,0)
                            TextLabel.Font = Enum.Font.GothamBold
                            TextLabel.TextSize = 14
                            TextLabel.TextColor3 = Color3.new(1,1,1)
                            TextLabel.TextStrokeTransparency = 0.5
                        end

                        local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                        local esp = hrp:FindFirstChild("PlayerESP")

                        if esp and esp:FindFirstChild("TextLabel") then
                            esp.TextLabel.Text = v.DisplayName.."\n\n"..Dis.." M."
                            if v.Team == game.Players.LocalPlayer.Team then
                                esp.TextLabel.TextColor3 = Color3.new(1,0,0)
                            else
                                esp.TextLabel.TextColor3 = Color3.new(0,1,0)
                            end
                        end
                    else
                        if hrp:FindFirstChild("PlayerESP") then
                            hrp.PlayerESP:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)

Setting_Pvp:addToggle("Enable Pvp", EnablePVP, function(Value)
    EnablePVP = Value
end)

spawn(function()
    while wait(.1) do
        pcall(function()
            if EnablePVP then
                if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                end
            end
        end)
    end
end)

local Pvp_Right = Tab.Tab_Combat:addSection()
local Main_Pvp = Pvp_Right:addMenu("#Combat Player")

local PlayerList = {}
for i,v in pairs(game.Players:GetChildren()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
        table.insert(PlayerList, v.DisplayName)
    end
end

local DropdownPlayer = Main_Pvp:addDropdown("Select Player", SelectedPlayer, PlayerList, function(Value)
    SelectedPlayer = Value
end)

Main_Pvp:addButton("Refresh Player",function()
    NewPlayerList = {}
    for i,v in pairs(game.Players:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name then
            table.insert(NewPlayerList, v.DisplayName)
        end
    end
    DropdownPlayer:Clear()
    DropdownPlayer:Refresh(NewPlayerList)
end)

task.spawn(function()
    while wait() do
        pcall(function()
            for i,v in pairs(game.Players:GetChildren()) do
                if v.DisplayName == SelectedPlayer then
                    SelectedPlayer = v.Name
                end
            end
        end)
    end
end)

Main_Pvp:addToggle("Spectate Player", Spectate, function(value)
    Spectate = value
    local plr1 = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    local plr2 = game.Players:FindFirstChild(SelectedPlayer)

    repeat task.wait()
        if plr2 and plr2.Character and plr2.Character:FindFirstChild("Humanoid") then
            game.Workspace.Camera.CameraSubject = plr2.Character.Humanoid
        end
    until Spectate == false

    if plr1 then
        game.Workspace.Camera.CameraSubject = plr1
    end
end)

Main_Pvp:addToggle("Combat Player", TweenToPlayer, function(Value)
    TweenToPlayer = Value
    CancelTween(TweenToPlayer)
end)

spawn(function()
    while task.wait() do
        if TweenToPlayer then
            pcall(function()
                for i,v in pairs(game.Players:GetChildren()) do
                    if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                        if v.Name == SelectedPlayer then
                            repeat game:GetService("RunService").Heartbeat:wait()
                                EquipTool(SelectWeaponPvp)
                                Tween(v.Character.HumanoidRootPart.CFrame * Pvp_Mode)
                                Player_Name = v.Name
                                Player_Position = v.Character.HumanoidRootPart.Position
                                AutoClick()
                            until not TweenToPlayer or v.Character.Humanoid.Health == 0 or not game.Players:FindFirstChild(v.Name)
                        end
                    end
                end
            end)
        end
    end
end)

Main_Pvp:addToggle("Aimbot Skill", AimbotSkillPlayer, function(Value)
    AimbotSkillPlayer = Value
end)

spawn(function()
    local gg = getrawmetatable(game)
    local old = gg.__namecall
    setreadonly(gg,false)
    gg.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}

        if tostring(method) == "FireServer" then
            if tostring(args[1]) == "RemoteEvent" then
                if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if AimbotSkillPlayer and Player_Position then
                        if typeof(args[2]) == "Vector3" then
                            args[2] = Player_Position
                        else
                            args[2] = CFrame.new(Player_Position)
                        end
                        return old(unpack(args))
                    end
                end
            end
        end

        return old(...)
    end)
end)

spawn(function()
    while task.wait() do
        if AimbotSkillPlayer then
            pcall(function()
                for i,v in pairs(game.Players:GetChildren()) do
                    if v.Name == Player_Name and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                        Player_Position = v.Character.HumanoidRootPart.Position

                        repeat game:GetService("RunService").Heartbeat:wait()
                            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectWeaponPvp) then

                                local tool = game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectWeaponPvp)
                                if tool and tool:FindFirstChild("MousePos") then
                                    tool.MousePos.Value = Player_Position
                                end

                                if PvpSkillZ then
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
                                    wait(.1)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
                                end

                                if PvpSkillX then
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
                                    wait(.1)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
                                end

                                if PvpSkillC then
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
                                    wait(.1)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
                                end

                                if PvpSkillV then
                                    game:GetService('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
                                    wait(.1)
                                    game:GetService('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
                                end
                            end
                        until not AimbotSkillPlayer or v.Character.Humanoid.Health == 0 or not game.Players:FindFirstChild(v.Name)
                    end
                end
            end)
        end
    end
end)

local Skill_Pvp = Pvp_Right:addMenu("#Skill Setting")

Skill_Pvp:addToggle('Skill Z', PvpSkillZ, function(Value)
    PvpSkillZ = Value
end)

Skill_Pvp:addToggle('Skill X', PvpSkillX, function(Value)
    PvpSkillX = Value
end)

Skill_Pvp:addToggle('Skill C', PvpSkillC, function(Value)
    PvpSkillC = Value
end)

Skill_Pvp:addToggle('Skill V', PvpSkillV, function(Value)
    PvpSkillV = Value
end)