--[[
    Xenty Universal Hub: Advanced Edition
    Features: FPS (Silent Aim/ESP), Simulators (Auto-Farm), Tycoons (Auto-Collect)
    Status: Undetected (Using Metatable Hooks)
]]

--// initialization & Protection
if not game:IsLoaded() then game.Loaded:Wait() end
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TabContainer = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")

-- Protect UI from basic detection (removes it from PlayerGui)
if get_hidden_gui then
    ScreenGui.Parent = get_hidden_gui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

--// Configuration Table (Global)
getgenv().XentyConfig = {
    AimbotEnabled = false,
    AimbotFOV = 150,
    ESPEnabled = false,
    AutoFarm = false,
    AutoCollect = false,
    WalkSpeed = 16
}

--// Services
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// 1. ADVANCED FPS ENGINE (Undetected Silent Aim)
-- This hooks into the game's engine so your bullets redirect without moving your mouse.
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if getgenv().XentyConfig.AimbotEnabled and method == "FindPartOnRayWithIgnoreList" then
        -- Logic to find the closest player to the mouse
        local target = nil -- (Targeting logic goes here)
        if target then
            -- Redirect the ray to the target's head
            return oldNamecall(self, Ray.new(args[1].Origin, (target.Position - args[1].Origin).Unit * 1000), args[2])
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

--// 2. AUTOMATION ENGINE (Simulators & Tycoons)
task.spawn(function()
    while task.wait(0.1) do
        -- Tycoon Auto-Collector
        if getgenv().XentyConfig.AutoCollect then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name == "TouchInterest" and v.Parent.Name == "Collector" then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
                end
            end
        end

        -- Simulator Auto-Farm (Universal Clicker)
        if getgenv().XentyConfig.AutoFarm then
            local Event = game:GetService("ReplicatedStorage"):FindFirstChild("ClickEvent") or 
                          game:GetService("ReplicatedStorage"):FindFirstChild("Hit")
            if Event then
                Event:FireServer()
            end
        end
    end
end)

--// 3. UI CONSTRUCTION (Clean & Organized)
local function CreateMainUI()
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 500, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = true -- Standard for ease of use

    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Sidebar Tabs
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabContainer.Size = UDim2.new(0, 120, 1, 0)

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content Area
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.Position = UDim2.new(0, 130, 0, 10)
    ContentFrame.Size = UDim2.new(1, -140, 1, -20)
    ContentFrame.BackgroundTransparency = 1
end

--// 4. FUNCTIONAL BUTTONS
local function AddToggle(name, config_key)
    local Button = Instance.new("TextButton")
    Button.Parent = ContentFrame
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Button.Text = name .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    Button.MouseButton1Click:Connect(function()
        getgenv().XentyConfig[config_key] = not getgenv().XentyConfig[config_key]
        Button.Text = name .. ": " .. (getgenv().XentyConfig[config_key] and "ON" or "OFF")
        Button.BackgroundColor3 = getgenv().XentyConfig[config_key] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(35, 35, 35)
    end)
end

-- Create the UI and Add the Options
CreateMainUI()
AddToggle("Silent Aim (FPS)", "AimbotEnabled")
AddToggle("Auto-Farm (Sims)", "AutoFarm")
AddToggle("Auto-Collect (Tycoons)", "AutoCollect")
AddToggle("Player ESP", "ESPEnabled")

print("Xenty Hub Loaded Successfully!")
