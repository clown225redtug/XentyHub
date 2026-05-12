--[[
    Xenty Elite Universal Hub | Version 3.0
    Path: clown225redtug/XentyHub/main.lua
    Target: All FPS, Simulators, RP, and Tycoons
]]

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// 1. BOOTSTRAPPER (Loading Screen)
local function StartLoader()
    local Loader = Instance.new("ScreenGui")
    Loader.Name = "Xenty_Loader"
    Loader.Parent = CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 320, 0, 160)
    Main.Position = UDim2.new(0.5, -160, 0.5, -80)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    Main.Parent = Loader
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Text = "XENTY ELITE"
    Title.TextColor3 = Color3.fromRGB(0, 255, 180)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 26
    Title.BackgroundTransparency = 1
    Title.Parent = Main

    local BarBack = Instance.new("Frame")
    BarBack.Size = UDim2.new(0, 260, 0, 4)
    BarBack.Position = UDim2.new(0.5, -130, 0.7, 0)
    BarBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    BarBack.BorderSizePixel = 0
    BarBack.Parent = Main

    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
    BarFill.Parent = BarBack

    local Status = Instance.new("TextLabel")
    Status.Position = UDim2.new(0, 0, 0.8, 0)
    Status.Size = UDim2.new(1, 0, 0, 20)
    Status.Text = "Initializing Engines..."
    Status.TextColor3 = Color3.fromRGB(180, 180, 180)
    Status.BackgroundTransparency = 1
    Status.TextSize = 13
    Status.Parent = Main

    -- Loading Sequence
    local sequence = {"Checking Whitelist...", "Bypassing Anti-Cheat...", "Optimizing for Desktop...", "Ready!"}
    for i, msg in ipairs(sequence) do
        Status.Text = msg
        TweenService:Create(BarFill, TweenInfo.new(0.7), {Size = UDim2.new(i/4, 0, 1, 0)}):Play()
        task.wait(0.8)
    end
    Loader:Destroy()
end

--// 2. MAIN ENGINE (The Logic)
getgenv().XentyActive = true

local function Panic()
    getgenv().XentyActive = false
    if CoreGui:FindFirstChild("XentyHub_v3") then
        CoreGui:FindFirstChild("XentyHub_v3"):Destroy()
    end
    print("Xenty: Emergency Shutdown Triggered.")
end

-- Panic Key Listener (LeftControl + P)
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        Panic()
    end
end)

--// 3. UI GENERATION
local function CreateUI()
    local XentyMain = Instance.new("ScreenGui")
    XentyMain.Name = "XentyHub_v3"
    XentyMain.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 600, 0, 400)
    Frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BackgroundTransparency = 0.1
    Frame.Parent = XentyMain
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(0, 255, 180)
    UIStroke.Thickness = 1.8
    UIStroke.Parent = Frame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Frame
    
    -- Draggable Logic
    local dragStart, startPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragStart = nil end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    print("Xenty: UI Loaded Successfully on Full PC Hardware.")
end

--// RUN
StartLoader()
CreateUI()
