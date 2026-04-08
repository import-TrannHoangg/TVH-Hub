local OldBounty = game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value
local Bounty = tostring(game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value)
local Earned = tostring(game:GetService("Players").LocalPlayer.leaderstats["Bounty/Honor"].Value - OldBounty)
local sub = string.sub
local len = string.len
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 450)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Active = true
Main.Draggable = true

local UIGradient = Instance.new("UIGradient", Main)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,170,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(170,0,255))
}

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,45)
Title.Text = "TVH Hub - PvP"
Title.TextSize = 24
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)

local Visible = true
UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        Visible = not Visible
        Main.Visible = Visible

        TweenService:Create(blur, TweenInfo.new(0.3), {
            Size = Visible and 20 or 0
        }):Play()
    end
end)

local TabFrame = Instance.new("Frame", Main)
TabFrame.Size = UDim2.new(1,0,0,40)
TabFrame.Position = UDim2.new(0,0,0,45)
TabFrame.BackgroundTransparency = 1

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,0,1,-85)
Content.Position = UDim2.new(0,0,0,85)
Content.BackgroundTransparency = 1

local Tabs = {}
local Current

function createTab(name)
    local Btn = Instance.new("TextButton", TabFrame)
    Btn.Size = UDim2.new(0,120,1,0)
    Btn.Text = name
    Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1,0,1,0)
    Frame.Visible = false
    Frame.BackgroundTransparency = 1

    local Layout = Instance.new("UIListLayout", Frame)
    Layout.Padding = UDim.new(0,6)

    Btn.MouseButton1Click:Connect(function()
        for _,v in pairs(Content:GetChildren()) do
            if v:IsA("Frame") then v.Visible = false end
        end
        Frame.Visible = true
        Current = Frame
    end)

    if not Current then
        Frame.Visible = true
        Current = Frame
    end

    return Frame
end

function ripple(btn)
    local c = Instance.new("Frame", btn)
    c.BackgroundColor3 = Color3.fromRGB(255,255,255)
    c.BackgroundTransparency = 0.7
    c.Size = UDim2.new(0,0,0,0)
    c.Position = UDim2.new(0.5,0,0.5,0)
    c.AnchorPoint = Vector2.new(0.5,0.5)

    TweenService:Create(c, TweenInfo.new(0.4), {
        Size = UDim2.new(2,0,2,0),
        BackgroundTransparency = 1
    }):Play()

    game.Debris:AddItem(c,0.4)
end

function addToggle(parent,text,default,callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1,-10,0,40)
    Btn.Text = text.." : "..(default and "On" or "Off")
    Btn.BackgroundColor3 = Color3.fromRGB(25,25,25)

    local state = default

    Btn.MouseButton1Click:Connect(function()
        ripple(Btn)
        state = not state
        Btn.Text = text.." : "..(state and "On" or "Off")

        TweenService:Create(Btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(25,25,25)
        }):Play()

        callback(state)
    end)
end

function addDropdown(parent,text,default,list,callback)
    local MainBtn = Instance.new("TextButton", parent)
    MainBtn.Size = UDim2.new(1,-10,0,40)
    MainBtn.Text = text.." : "..(default or "None")
    MainBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)

    local Drop = Instance.new("Frame", parent)
    Drop.Size = UDim2.new(1,-10,0,#list*35)
    Drop.Visible = false
    Drop.BackgroundColor3 = Color3.fromRGB(20,20,20)

    local Layout = Instance.new("UIListLayout", Drop)

    for _,v in pairs(list) do
        local Item = Instance.new("TextButton", Drop)
        Item.Size = UDim2.new(1,0,0,35)
        Item.Text = v
        Item.BackgroundColor3 = Color3.fromRGB(35,35,35)

        Item.MouseButton1Click:Connect(function()
            ripple(Item)
            MainBtn.Text = text.." : "..v
            Drop.Visible = false
            callback(v)
        end)
    end

    MainBtn.MouseButton1Click:Connect(function()
        ripple(MainBtn)
        Drop.Visible = not Drop.Visible
    end)
end

function addTextbox(text, default, callback)
    local Box = Instance.new("TextBox", Main)
    Box.Size = UDim2.new(1,-10,0,35)
    Box.Text = text..": "..tostring(default)
    Box.BackgroundColor3 = Color3.fromRGB(40,40,40)

    Box.FocusLost:Connect(function()
        local val = tonumber(Box.Text:match("%d+")) or default
        Box.Text = text..": "..val
        callback(val)
    end)
end

spawn(function()
    while wait() do
        pcall(function()
            local Bounty = tostring(game.Players.LocalPlayer.leaderstats["Bounty/Honor"].Value)
            local Earned = tostring(game.Players.LocalPlayer.leaderstats["Bounty/Honor"].Value - OldBounty)spawn(function()

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
          end)
    end
end)

local PvpWeaponList = {"Melee", "Sword", "Blox Fruit", "Gun"}
addDropdown("Lựa Chọn Vũ Khí Để PvP", PvpSelectedWeapon, PvpWeaponList, function(Value)
     PvpSelectedWeapon = Value
end)

task.spawn(function()
     while wait() do
         pcall(function()
             if PvpSelectedWeapon == "Melee" then
                 for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                     if v.ToolTip == "Melee" then
                          if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                              SelectWeaponPvp = v.Name
                          end
                     end
                 end

             elseif PvpSelectedWeapon == "Sword" then
                 for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                     if v.ToolTip == "Sword" then
                          if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                              SelectWeaponPvp = v.Name
                          end
                     end
                 end

             elseif PvpSelectedWeapon == "Blox Fruit" then
                 for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                     if v.ToolTip == "Blox Fruit" then
                          if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                              SelectWeaponPvp = v.Name
                          end
                     end
                 end

             elseif PvpSelectedWeapon == "Gun" then
                 for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                     if v.ToolTip == "Gun" then
                          if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
                              SelectWeaponPvp = v.Name
                          end
                      end
                  end
              end
         end)
     end
end)

local PvpTable = {
     "Trên Đầu",
     "Dưới Chân",
     "Sau Địch"
}

AutoPvpType = "Sau Lưng"
addDropdown("Chọn Kiểu PvP", AutoPvpType, PvpTable, function(Value)
     AutoPvpType = Value
end)

spawn(function()
     while wait() do
         if AutoPvpType == "Trên Đầu" then
              Pvp_Mode = CFrame.new(0,DisPvp,0) * CFrame.Angles(math.rad(-90),0,0)
         elseif AutoPvpType == "Dưới Chân" then
              Pvp_Mode = CFrame.new(0,DisPvp,0) * CFrame.Angles(math.rad(90),0,0)
         elseif AutoPvpType == "Sau Địch" then
              Pvp_Mode = CFrame.new(0,0,DisPvp) * CFrame.Angles(math.rad(0),0,0)
         end
     end
end)

DisPvp = 10
addTextbox("PvP Tầm Xa", DisPvp, function(Value)
     DisPvp = Value
end)

addToggle("ESP Người Chơi", _G.ESPPlayer, function(Value)
     _G.ESPPlayer = Value
end)

spawn(function()
     while wait() do
         pcall(function()
             if _G.ESPPlayer then
                 for i,v in pairs(game.Players:GetChildren()) do
                     if v.Name ~= game.Players.LocalPlayer.Name then
                          if not v.Character.HumanoidRootPart:FindFirstChild("PlayerESP") then
                              local BillboardGui = Instance.new("BillboardGui")
                              local TextLabel = Instance.new("TextLabel")

                              BillboardGui.Parent = v.Character.HumanoidRootPart
                              BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                              BillboardGui.Active = true
                              BillboardGui.Name = "PlayerESP"
                              BillboardGui.AlwaysOnTop = true
                              BillboardGui.LightInfluence = 1.000
                              BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                              BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                             TextLabel.Parent = BillboardGui
                             TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                             TextLabel.BackgroundTransparency = 1.000
                             TextLabel.Size = UDim2.new(0, 200, 0, 50)
                             TextLabel.Font = Enum.Font.GothamBold
                             TextLabel.FontSize = "Size14"
                             TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                             TextLabel.Text.Size = 35
                             TextLabel.TextStrokeTransparency = 0.5
                        end
                        local Dis = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude)
                        v.Character.HumanoidRootPart:FindFirstChild("PlayerESP").TextLabel.Text = v.DisplayName.."\n\n"..Dis.." M."
                        if v.Team == game.Players.LocalPlayer.Team then
                            v.Character.HumanoidRootPart:FindFirstChild("PlayerESP").TextLabel.TextColor3 = Color3.fromRGB(255,0,0)
                        else
                            v.Character.HumanoidRootPart:FindFirstChild("PlayerESP").TextLabel.TextColor3 = Color3.new(0,255,0)
                           end
                       end
                   end
              else
                   for i,v in pairs(game.Players:GetChildren()) do
                       if v.Name ~= game.Players.LocalPlayer.Name then
                           if v.Character.HumanoidRootPart:FindFirstChild("PlayerESP") then
                               v.Character.HumanoidRootPart.PlayerESP:Destroy()
                           end
                       end
                   end
              end
         end)
     end
end)

addToggle("Bắt Đầu PvP", EnablePVP, function(Value)
     EnablePVP = Value
end)

spawn(function()
     pcall(function()
         while wait(.1) do
             if EnablePVP then
                 if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                 end
             end
         end
    end)
end)

local PlayerList = {}
for i,v in pairs(game.Players:GetChildren()) do
       if v.Name ~= game.Players.LocalPlayer.Name then
             table.insert(PlayerList, v.DisplayName)
       end
end

local DropdownPlayer = Main_Pvp:addDropdown("Chọn Người Chơi", SelectedPlayer, PlayerList, function(Value)
     SelectedPlayer = Value
end)

Main_Pvp:addButton("Làm Mới Người Chơi",function()
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

Main_Pvp:addToggle("Xem Người Chơi", Spectate, function(value)
      Spectate = value
      local LocalPlayer = game.Players.LocalPlayer.Character.Humanoid
      local FindFirstChild = game.Players:FindFirstChild(SelectedPlayer)
      repeat task.wait()
            game.Workspace.Camera.CameraSubject = FindFirstChild.Character.Humanoid
      until Spectate == false
      game.Workspace.Camera.CameraSubject = LocalPlayer
end)

function CancelTween(target)
    if not target then
        _G.StopTween = true
        wait(.1)
        Tween(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait(.1)
        _G.StopTween = false
    end
end

Main_Pvp:addToggle("Người Chơi Chiến Đấu", TweenToPlayer, function(Value)
     TweenToPlayer = Value
     CancelTween(TweenToPlayer)
end)

function EquipTool(Tool)
    pcall(function()
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack[Tool])
    end)
end

function Tween(P1)
    local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance > 1 then
        Speed = 350
    end

function AutoClick()
     game:GetService('VirtualUser'):CaptureController()
     game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
end

spawn(function()
     while task.wait() do
         if TweenToPlayer then
             pcall(function()
                 for i,v in pairs(game.Players:GetChildren()) do
                      if v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
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

Main_Pvp:addToggle("Aimbot Chiêu", AimbotSkillPlayer, function(Value)
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
                      if AimbotSkillPlayer then
                          if type(args[2]) == "vector" then
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
                     if v.Name == Player_Name and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
                        Player_Position = v.Character.HumanoidRootPart.Position
                        repeat game:GetService("RunService").Heartbeat:wait()
                            if game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectWeaponPvp) then
                                game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectWeaponPvp).MousePos.Value = Player_Position
                                if PvpSkillZ then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "Z", false, game)
                                    wait(.1)
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "Z", false, game)
                                end
                                
                                if PvpSkillX then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
                                    wait(.1)
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
                                end
                                
                                if PvpSkillC then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "C", false, game)
                                    wait(.1)
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "C", false, game)
                                end
                                
                                if PvpSkillV then
                                    game:service('VirtualInputManager'):SendKeyEvent(true, "V", false, game)
                                    wait(.1)
                                    game:service('VirtualInputManager'):SendKeyEvent(false, "V", false, game)
                                  end
                              end
                          until not AimbotSkillPlayer or v.Character.Humanoid.Health == 0 or not game.Players:FindFirstChild(v.Name)
                      end
                  end
             end)
         end
     end
end)

Skill_Pvp:addToggle('Chiêu Z', PvpSkillZ, function(Value)
     PvpSkillZ = Value
end)

Skill_Pvp:addToggle('Chiêu X', PvpSkillX, function(Value)
    PvpSkillX = Value
end)

Skill_Pvp:addToggle('Chiêu C', PvpSkillC, function(Value)
     PvpSkillC = Value
end)

Skill_Pvp:addToggle('Chiêu V', PvpSkillV, function(Value)
     PvpSkillV = Value
end)
