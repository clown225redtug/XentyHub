--// Xenty Elite Hub v8.0 [Full UI Edition]
--// Optimized for Xeno & PC Performance

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

--// 1. GLOBAL SETTINGS
getgenv().Xenty = {
    MainColor = Color3.fromRGB(0, 255, 180),
    AutoCollect = false,
    AutoFarm = false,
    Aimbot = false,
    ESP = false
}

--// 2. UI CONSTRUCTION
local function BuildFullUI()
    if CoreGui:FindFirstChild("XentyHub_Final") then CoreGui.XentyHub_Final:Destroy() end

    local Hub = Instance.new("ScreenGui")
    Hub.Name = "XentyHub_Final"
    Hub.Parent = CoreGui

    -- Main Window
    local Main = Instance.new("Frame", Hub)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true 

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local Glow = Instance.new("UIStroke", Main)
    Glow.Color = getgenv().Xenty.MainColor
    Glow.Thickness = 2

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.BorderSizePixel = 0
    Instance.new("UICorner", Sidebar)

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "XENTY ELITE"
    Title.TextColor3 = getgenv().Xenty.MainColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.BackgroundTransparency = 1

    -- Container for Tabs
    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -140, 1, -10)
    Container.Position = UDim2.new(0, 135, 0, 5)
    Container.BackgroundTransparency = 1

    -- Tab Switching Logic
    local function CreateTab(name, order)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.Position = UDim2.new(0.05, 0, 0, 60 + (order * 40))
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 14
        Instance.new("UICorner", TabBtn)
        
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = (order == 0)
        Page.ScrollBarThickness = 2

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do v.Visible = false end
            Page.Visible = true
        end)
        return Page
    end

    -- Create the Pages
    local MainP = CreateTab("Main/FPS", 0)
    local SimP = CreateTab("Simulators", 1)
    local TycoonP = CreateTab("Tycoons", 2)

    -- Example Function (Add these to pages)
    local function AddToggle(parent, text, config_var)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(1, -10, 0, 40)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        b.Text = text .. ": OFF"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", b)

        b.MouseButton1Click:Connect(function()
            getgenv().Xenty[config_var] = not getgenv().Xenty[config_var]
            b.Text = text .. ": " .. (getgenv().Xenty[config_var] and "ON" or "OFF")
            b.TextColor3 = getgenv().Xenty[config_var] and getgenv().Xenty.MainColor or Color3.fromRGB(255, 255, 255)
        end)
    end

    -- Populate Pages
    AddToggle(MainP, "Silent Aim", "Aimbot")
    AddToggle(MainP, "Visual ESP", "ESP")
    AddToggle(SimP, "Auto-Farm Clicker", "AutoFarm")
    AddToggle(TycoonP, "Auto-Collect Cash", "AutoCollect")
end

BuildFullUI()
