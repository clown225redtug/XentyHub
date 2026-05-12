--[[
    XENTY ELITE HUB | VERSION 7.0 (COMPLETELY REWRITTEN)
    Complete rewrite with proper architecture, error handling, and performance optimization.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// CONFIG
local CONFIG = {
    MainColor = Color3.fromRGB(0, 255, 180),
    AccentColor = Color3.fromRGB(255, 50, 100),
    BackgroundColor = Color3.fromRGB(15, 15, 15),
    BorderColor = Color3.fromRGB(30, 30, 30),
}

local Features = {
    AutoCollect = false,
    AutoFarm = false,
    Aimbot = false,
    ESP = false,
}

local CollectorCache = {}
local LastCacheUpdate = 0
local CACHE_UPDATE_INTERVAL = 5

--// UTILITIES
local function ClearUI()
    local existing = CoreGui:FindFirstChild("XentyHub")
    if existing then existing:Destroy() end
    local existingPlayer = PlayerGui:FindFirstChild("XentyHub")
    if existingPlayer then existingPlayer:Destroy() end
end

local function GetCollectors()
    local now = tick()
    -- Cache collectors to avoid expensive GetDescendants() every frame
    if now - LastCacheUpdate > CACHE_UPDATE_INTERVAL then
        CollectorCache = {}
        pcall(function()
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:match("Collector") or v.Name:match("TouchPart") or v.Name:match("Drop")) then
                    table.insert(CollectorCache, v)
                end
            end
        end)
        LastCacheUpdate = now
    end
    return CollectorCache
end

local function TouchPart(part)
    if not part or part.Parent == nil then return false end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    local hrp = char.HumanoidRootPart
    local success = false
    
    -- Try multiple methods for maximum compatibility
    pcall(function()
        if firetouchinterest then
            firetouchinterest(hrp, part, 0)
            firetouchinterest(hrp, part, 1)
            success = true
        end
    end)
    
    if not success then
        pcall(function()
            -- Fallback: teleport near the part
            local offset = CFrame.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
            hrp.CFrame = part.CFrame + offset
            success = true
        end)
    end
    
    return success
end

--// AUTO COLLECT LOOP
task.spawn(function()
    while true do
        task.wait(0.3) -- Optimized frequency
        
        if Features.AutoCollect then
            local collectors = GetCollectors()
            local char = LocalPlayer.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, part in ipairs(collectors) do
                    if part and part.Parent then
                        TouchPart(part)
                    end
                end
            end
        end
    end
end)

--// UI CREATION
local function CreateUI()
    ClearUI()
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XentyHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
    
    -- Main Window
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 500, 0, 400)
    MainWindow.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainWindow.BackgroundColor3 = CONFIG.BackgroundColor
    MainWindow.BorderSizePixel = 0
    MainWindow.Active = true
    MainWindow.Draggable = true
    MainWindow.Parent = ScreenGui
    
    -- Corner Radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainWindow
    
    -- Stroke
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = CONFIG.BorderColor
    Stroke.Thickness = 2
    Stroke.Parent = MainWindow
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = CONFIG.BorderColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainWindow
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "XENTY ELITE HUB v7.0"
    Title.TextColor3 = CONFIG.MainColor
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -50, 0, 5)
    CloseBtn.BackgroundColor3 = CONFIG.AccentColor
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 28
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 8)
    CloseBtnCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -70)
    ContentFrame.Position = UDim2.new(0, 10, 0, 60)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainWindow
    
    -- Padding
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.Parent = ContentFrame
    
    -- Layout
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 15)
    Layout.Parent = ContentFrame
    
    --// BUTTON CREATION HELPER
    local function CreateToggleButton(name, feature)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, 0, 0, 50)
        Button.BackgroundColor3 = CONFIG.BorderColor
        Button.BorderSizePixel = 0
        Button.Text = string.format("%s: %s", name, Features[feature] and "✓ ON" or "✗ OFF")
        Button.TextColor3 = Features[feature] and CONFIG.MainColor or Color3.fromRGB(200, 200, 200)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 16
        Button.Parent = ContentFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        Button.MouseButton1Click:Connect(function()
            Features[feature] = not Features[feature]
            Button.Text = string.format("%s: %s", name, Features[feature] and "✓ ON" or "✗ OFF")
            Button.TextColor3 = Features[feature] and CONFIG.MainColor or Color3.fromRGB(200, 200, 200)
            
            -- Visual feedback
            Button.BackgroundColor3 = Features[feature] and Color3.fromRGB(25, 35, 30) or CONFIG.BorderColor
        end)
        
        Button.MouseEnter:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)
        
        Button.MouseLeave:Connect(function()
            Button.BackgroundColor3 = Features[feature] and Color3.fromRGB(25, 35, 30) or CONFIG.BorderColor
        end)
        
        return Button
    end
    
    -- Add Buttons
    CreateToggleButton("Auto Collect", "AutoCollect")
    CreateToggleButton("Auto Farm", "AutoFarm")
    CreateToggleButton("Aimbot", "Aimbot")
    CreateToggleButton("Wall ESP", "ESP")
    
    -- Status Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Text = "Ready | Collectors: 0"
    StatusLabel.TextColor3 = CONFIG.MainColor
    StatusLabel.Font = Enum.Font.GothamMonospace
    StatusLabel.TextSize = 12
    StatusLabel.Parent = ContentFrame
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 6)
    StatusCorner.Parent = StatusLabel
    
    -- Update status
    task.spawn(function()
        while StatusLabel.Parent do
            task.wait(0.5)
            local count = #GetCollectors()
            StatusLabel.Text = string.format("Ready | Collectors: %d", count)
        end
    end)
    
    print("[Xenty] UI loaded successfully!")
end

--// INITIALIZATION
if game:IsLoaded() then
    CreateUI()
else
    game.Loaded:Wait()
    CreateUI()
end

print("[Xenty] Elite Hub v7.0 initialized!")
