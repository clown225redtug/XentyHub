--[[
    XENTY ELITE HUB | VERSION 6.0 (OMNI-EDITION)
    Developed by: Xenty Development
    Repository: clown225redtug/XentyHub
    
    Features: 
    - Advanced Bootstrapper & UI
    - Drawing API ESP (Boxes & Tracers)
    - Metatable Silent Aim Hook
    - Universal Tycoon & Simulator Auto-Farm
    - Panic Key (LeftControl + P)
]]

--// 1. SERVICES & INITIALIZATION
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

--// 2. CONFIGURATION
getgenv().Xenty = {
    Enabled = true,
    Aimbot = {Enabled = false, FOV = 150, Smoothness = 1},
    ESP = {Enabled = false, Boxes = true, Tracers = true, Color = Color3.fromRGB(0, 255, 180)},
    Auto = {Farm = false, Collect = false},
    MainColor = Color3.fromRGB(0, 255, 180)
}

--// 3. PROTECTION & UTILS
local function Protect(Instance)
    if get_hidden_gui then Instance.Parent = get_hidden_gui()
    elseif syn and syn.protect_gui then syn.protect_gui(Instance); Instance.Parent = CoreGui
    else Instance.Parent = CoreGui end
end

--// 4. DRAWING ENGINE (ADVANCED VISUALS)
local function CreateESP(plr)
    local Box = Drawing.new("Square")
    local Tracer = Drawing.new("Line")
    
    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if getgenv().Xenty.Enabled and getgenv().Xenty.ESP.Enabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local Root = plr.Character.HumanoidRootPart
                local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)

                if OnScreen then
                    if getgenv().Xenty.ESP.Boxes then
                        Box.Visible = true
                        Box.Size = Vector2.new(2000 / Pos.Z, 3000 / Pos.Z)
                        Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                        Box.Color = getgenv().Xenty.ESP.Color
                        Box.Thickness = 1.5
                        Box.Filled = false
                    else Box.Visible = false end

                    if getgenv().Xenty.ESP.Tracers then
                        Tracer.Visible = true
                        Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        Tracer.To = Vector2.new(Pos.X, Pos.Y)
                        Tracer.Color = getgenv().Xenty.ESP.Color
                        Tracer.Thickness = 1
                    else Tracer.Visible = false end
                else
                    Box.Visible = false
                    Tracer.Visible = false
                end
            else
                Box.Visible = false
                Tracer.Visible = false
                if not plr.Parent then 
                    Connection:Disconnect()
                    Box:Remove()
                    Tracer:Remove() 
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer then CreateESP(v) end end
Players.PlayerAdded:Connect(CreateESP)

--// 5. METATABLE HOOK (SILENT AIM)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if getgenv().Xenty.Enabled and getgenv().Xenty.Aimbot.Enabled and method == "FindPartOnRayWithIgnoreList" then
        local target = nil
        local shortestDistance = math.huge
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local Pos, OnScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if OnScreen then
                    local dist = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < shortestDistance and dist < getgenv().Xenty.Aimbot.FOV then
                        shortestDistance = dist
                        target = p.Character.Head
                    end
                end
            end
        end
        
        if target then
            args[1] = Ray.new(args[1].Origin, (target.Position - args[1].Origin).Unit * 5000)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

--// 6. AUTOMATION LOGIC
task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().Xenty.Enabled then break end
        
        -- Auto-Collect Tycoons
        if getgenv().Xenty.Auto.Collect then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name == "TouchInterest" and v.Parent:FindFirstChild("Collector") then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end
        
        -- Auto-Clicker Simulators
        if getgenv().Xenty.Auto.Farm then
            local remotes = game:GetService("ReplicatedStorage")
            local click = remotes:FindFirstChild("Click") or remotes:FindFirstChild("Hit") or remotes:FindFirstChild("Tap")
            if click and click:IsA("RemoteEvent") then
                click:FireServer()
            end
        end
    end
end)

--// 7. LOADING SCREEN & UI
local function BuildUI()
    -- Loading Screen
    local Loader = Instance.new("ScreenGui")
    Protect(Loader)
    local LoadFrame = Instance.new("Frame", Loader)
    LoadFrame.Size = UDim2.new(0, 300, 0, 150)
    LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    local LCorn = Instance.new("UICorner", LoadFrame)
    
    local LTitle = Instance.new("TextLabel", LoadFrame)
    LTitle.Size = UDim2.new(1, 0, 1, 0)
    LTitle.Text = "XENTY LOADING..."
    LTitle.TextColor3 = getgenv().Xenty.MainColor
    LTitle.Font = Enum.Font.GothamBold
    LTitle.TextSize = 20
    LTitle.BackgroundTransparency = 1
    
    task.wait(2)
    Loader:Destroy()

    -- Main Hub
    local Hub = Instance.new("ScreenGui")
    Protect(Hub)
    Hub.Name = "XentyHub"

    local Main = Instance.new("Frame", Hub)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    local MCorn = Instance.new("UICorner", Main)
    local MStroke = Instance.new("UIStroke", Main)
    MStroke.Color = getgenv().Xenty.MainColor
    MStroke.Thickness = 2

    local Side = Instance.new("Frame", Main)
    Side.Size = UDim2.new(0, 120, 1, 0)
    Side.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    local SCorn = Instance.new("UICorner", Side)

    -- Draggable
    local dInput, dStart, sPos
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dStart = i.Position; sPos = Main.Position end end)
    UIS.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement and dStart then
        local delta = i.Position - dStart
        Main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + delta.X, sPos.Y.Scale, sPos.Y.Offset + delta.Y)
    end end)

    -- Panic Key
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.P and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            getgenv().Xenty.Enabled = false
            Hub:Destroy()
        end
    end)
    
    print("Xenty Elite v6.0 Fully Injected.")
end

BuildUI()
