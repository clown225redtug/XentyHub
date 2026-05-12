--// Xenty Elite Hub v9.0 [Xeno Ultimate Fix]
--// Optimized for: clown225redtug/XentyHub

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

--// 1. GLOBAL SETTINGS
getgenv().Xenty = {
    MainColor = Color3.fromRGB(0, 255, 180),
    AutoCollect = false,
    AutoFarm = false,
    Aimbot = false,
    ESP = false
}

--// 2. UI CONSTRUCTION (Rebuilt for Visibility)
local function BuildFullUI()
    -- Clear old UI to prevent overlapping
    if PlayerGui:FindFirstChild("XentyHub_Xeno") then PlayerGui.XentyHub_Xeno:Destroy() end

    local Hub = Instance.new("ScreenGui")
    Hub.Name = "XentyHub_Xeno"
    Hub.ResetOnSpawn = false
    Hub.Parent = PlayerGui -- CHANGED: Moved to PlayerGui for Xeno stability

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true 
    Main.Parent = Hub

    local UICorner = Instance.new("UICorner", Main)
    local UIStroke = Instance.new("UIStroke", Main)
    UIStroke.Color = getgenv().Xenty.MainColor
    UIStroke.Thickness = 2

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 120, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar)

    local Title = Instance.new("TextLabel", Sidebar)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "XENTY ELITE"
    Title.TextColor3 = getgenv().Xenty.MainColor
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1

    -- Tab Container (Where the buttons/cheats live)
    local Container = Instance.new("Frame", Main)
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -130, 1, -10)
    Container.Position = UDim2.new(0, 125, 0, 5)
    Container.BackgroundTransparency = 1

    -- PAGE SYSTEM
    local Pages = {}
    local function CreatePage(name, order)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = (order == 0)
        Page.ScrollBarThickness = 0
        
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0.9, 0, 0, 30)
        TabBtn.Position = UDim2.new(0.05, 0, 0, 50 + (order * 35))
        TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do p.Visible = false end
            Page.Visible = true
        end)
        
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 5)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        return Page
    end

    -- CREATE TABS
    local CombatPage = CreatePage("Combat/FPS", 0)
    local SimPage = CreatePage("Simulators", 1)
    local TycoonPage = CreatePage("Tycoons", 2)

    -- TOGGLE GENERATOR
    local function AddCheat(parent, text, config_var)
        local b = Instance.new("TextButton", parent)
        b.Size = UDim2.new(0.9, 0, 0, 35)
        b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b.Text = text .. ": OFF"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 12
        Instance.new("UICorner", b)

        b.MouseButton1Click:Connect(function()
            getgenv().Xenty[config_var] = not getgenv().Xenty[config_var]
            b.Text = text .. ": " .. (getgenv().Xenty[config_var] and "ON" or "OFF")
            b.TextColor3 = getgenv().Xenty[config_var] and getgenv().Xenty.MainColor or Color3.fromRGB(255, 255, 255)
        end)
    end

    -- FILL CHEATS
    AddCheat(CombatPage, "Silent Aim", "Aimbot")
    AddCheat(CombatPage, "Wall ESP", "ESP")
    AddCheat(SimPage, "Auto-Clicker", "AutoFarm")
    AddCheat(TycoonPage, "Cash Collect", "AutoCollect")

    print("Xenty: Full UI Build Complete for Xeno.")
end

-- Wait for game and execute
if not game:IsLoaded() then game.Loaded:Wait() end
pcall(BuildFullUI)
