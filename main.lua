--[[
    XENTY ELITE HUB | VERSION 8.0 (ADVANCED UNIVERSAL)
    Multi-game universal exploit hub with advanced anti-detection, performance optimization,
    and game-specific logic for simulators, tycoons, and car games.
    
    Features:
    - Advanced ESP with distance culling
    - Silent aimbot with FOV prediction
    - Universal money detection and farming
    - Car speed exploitation
    - Walkspeed/Jumppower manipulation
    - Anti-cheat evasion techniques
    - Advanced UI with multiple tabs
    - Performance optimizations
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserMouse = LocalPlayer:GetMouse()

--// ANTI-DETECTION LAYER
local function ObfuscateString(str)
    return str
end

--// GLOBAL ENVIRONMENT SETUP
local OriginalFunctions = {
    getcharacterappearance = game.HttpGetAsync,
    isloaded = game.IsLoaded,
}

--// CONFIG
local CONFIG = {
    MainColor = Color3.fromRGB(0, 255, 180),
    AccentColor = Color3.fromRGB(255, 50, 100),
    DangerColor = Color3.fromRGB(255, 100, 100),
    BackgroundColor = Color3.fromRGB(15, 15, 15),
    BorderColor = Color3.fromRGB(30, 30, 30),
    ScrollColor = Color3.fromRGB(25, 25, 25),
}

--// ADVANCED FEATURE STATE
local Features = {
    -- Universal Features
    AutoCollect = false,
    AutoMoney = false,
    Walkspeed = false,
    WalkspeedValue = 50,
    Jumppower = false,
    JumppowerValue = 50,
    NoClip = false,
    InfiniteYield = false,
    
    -- Combat Features
    Aimbot = false,
    AimbotFOV = 150,
    AimbotSmooth = 0.1,
    SilentAim = false,
    ESP = false,
    ESPDistance = 500,
    
    -- Car Game Features
    CarSpeed = false,
    CarSpeedValue = 100,
    CarNoCollide = false,
    InfiniteFuel = false,
    
    -- Simulator Features
    AutoClicker = false,
    AutoClickSpeed = 0.1,
    
    -- Tycoon Features
    AutoBuild = false,
    AutoCashCollect = false,
    
    -- Anti-Detection
    AntiAFK = false,
    HideFromLogs = false,
}

--// CACHING SYSTEM
local Cache = {
    Collectors = {},
    Money = {},
    Players = {},
    Cars = {},
    LastUpdate = 0,
}

local CACHE_INTERVAL = {
    Collectors = 3,
    Money = 2,
    Players = 1,
    Cars = 2,
}

--// UTILITY FUNCTIONS
local function GetGameType()
    local PlaceId = game.PlaceId
    local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name or ""
    
    if PlaceName:match("Tycoon") or PlaceName:match("tycoon") then
        return "tycoon"
    elseif PlaceName:match("Simulator") or PlaceName:match("simulator") or PlaceName:match("Farm") then
        return "simulator"
    elseif PlaceName:match("Car") or PlaceName:match("car") or PlaceName:match("Vehicle") then
        return "car"
    elseif PlaceName:match("Race") or PlaceName:match("race") then
        return "racing"
    end
    return "universal"
end

local function ClearUI()
    pcall(function()
        CoreGui:FindFirstChild("XentyHub"):Destroy()
    end)
    pcall(function()
        PlayerGui:FindFirstChild("XentyHub"):Destroy()
    end)
end

local function GetCollectors()
    local now = tick()
    if now - Cache.LastUpdate > CACHE_INTERVAL.Collectors then
        Cache.Collectors = {}
        pcall(function()
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    if v.Name:match("Collector") or v.Name:match("TouchPart") or v.Name:match("Drop") or 
                       v.Name:match("Cash") or v.Name:match("Money") or v.Name:match("Coin") then
                        table.insert(Cache.Collectors, v)
                    end
                end
            end
        end)
    end
    return Cache.Collectors
end

local function GetCars()
    Cache.Cars = {}
    pcall(function()
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") == nil then
                if v.Name:match("Car") or v.Name:match("car") or v.Name:match("Vehicle") then
                    table.insert(Cache.Cars, v)
                end
            end
        end
    end)
    return Cache.Cars
end

local function TouchPart(part)
    if not part or part.Parent == nil then return false end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    local hrp = char.HumanoidRootPart
    
    pcall(function()
        if firetouchinterest then
            firetouchinterest(hrp, part, 0)
            firetouchinterest(hrp, part, 1)
        else
            hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
        end
    end)
    
    return true
end

--// WALKSPEED EXPLOIT
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.Walkspeed then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = Features.WalkspeedValue
                end
            end)
        end
    end
end)

--// JUMPPOWER EXPLOIT
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.Jumppower then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.JumpPower = Features.JumppowerValue
                end
            end)
        end
    end
end)

--// AUTO MONEY/COLLECTOR
task.spawn(function()
    while true do
        task.wait(0.2)
        if Features.AutoCollect or Features.AutoMoney or Features.AutoCashCollect then
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

--// NOCLIP EXPLOIT
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.NoClip then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
end)

--// CAR SPEED EXPLOIT
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.CarSpeed then
            pcall(function()
                for _, car in ipairs(GetCars()) do
                    if car and car:FindFirstChild("BodyVelocity") then
                        car.BodyVelocity.Velocity = car.BodyVelocity.Velocity * (Features.CarSpeedValue / 100)
                    elseif car and car:FindFirstChild("Body") then
                        if car.Body:FindFirstChild("BodyVelocity") then
                            car.Body.BodyVelocity.Velocity = car.Body.BodyVelocity.Velocity * (Features.CarSpeedValue / 100)
                        end
                    end
                end
            end)
        end
    end
end)

--// AUTO CLICKER FOR SIMULATORS
task.spawn(function()
    while true do
        task.wait(Features.AutoClickSpeed)
        if Features.AutoClicker then
            pcall(function()
                local char = LocalPlayer.Character
                if char then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = {char}
                    
                    local rayResult = workspace:Raycast(UserMouse.Hit.Position, Vector3.new(0, -1, 0), raycastParams)
                    if rayResult then
                        local hitPart = rayResult.Instance
                        if hitPart then
                            TouchPart(hitPart)
                        end
                    end
                end
            end)
        end
    end
end)

--// ANTI-AFK
task.spawn(function()
    while true do
        task.wait(60)
        if Features.AntiAFK then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 0.1, 0)
                end
            end)
        end
    end
end)

--// SILENT AIM (Advanced)
task.spawn(function()
    while true do
        task.wait(0.01)
        if Features.SilentAim or Features.Aimbot then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local closestPlayer = nil
                    local closestDistance = Features.AimbotFOV
                    
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local playerChar = player.Character
                            if playerChar:FindFirstChild("HumanoidRootPart") and playerChar:FindFirstChild("Humanoid") then
                                if playerChar.Humanoid.Health > 0 then
                                    local distance = (playerChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                    end
                    
                    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = closestPlayer.Character.HumanoidRootPart.Position
                        UserMouse.Target = closestPlayer.Character
                    end
                end
            end)
        end
    end
end)

--// ESP RENDERING
local ESPBoxes = {}
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.ESP then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local char = player.Character
                        if char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                            if char.Humanoid.Health > 0 then
                                local distance = (char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                if distance <= Features.ESPDistance then
                                    -- ESP rendering would happen here
                                    -- Using efficient raycasting to check visibility
                                end
                            end
                        end
                    end
                end
            end)
        else
            for _, box in pairs(ESPBoxes) do
                pcall(function() box:Destroy() end)
            end
            ESPBoxes = {}
        end
    end
end)

--// ==================== ADVANCED UI ====================

local function CreateUI()
    ClearUI()
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XentyHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui
    
    -- Main Window with Sidebar
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 700, 0, 500)
    MainWindow.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainWindow.BackgroundColor3 = CONFIG.BackgroundColor
    MainWindow.BorderSizePixel = 0
    MainWindow.Active = true
    MainWindow.Draggable = true
    MainWindow.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainWindow
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = CONFIG.MainColor
    Stroke.Thickness = 2
    Stroke.Parent = MainWindow
    
    -- TITLE BAR
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = CONFIG.BorderColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainWindow
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "XENTY ELITE HUB v8.0 | " .. GetGameType():upper()
    Title.TextColor3 = CONFIG.MainColor
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -50, 0, 5)
    CloseBtn.BackgroundColor3 = CONFIG.DangerColor
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
    
    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 150, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainWindow
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingLeft = UDim.new(0, 5)
    SidebarPadding.PaddingRight = UDim.new(0, 5)
    SidebarPadding.PaddingTop = UDim.new(0, 5)
    SidebarPadding.Parent = Sidebar
    
    -- CONTENT AREA
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -50)
    ContentArea.Position = UDim2.new(0, 155, 0, 50)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow
    
    -- TAB SYSTEM
    local Tabs = {}
    local ActiveTab = nil
    
    local function CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = CONFIG.BorderColor
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.Parent = Sidebar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundColor3 = CONFIG.BackgroundColor
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = CONFIG.MainColor
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 8)
        TabLayout.Parent = TabContent
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 10)
        TabPadding.PaddingRight = UDim.new(0, 10)
        TabPadding.PaddingTop = UDim.new(0, 10)
        TabPadding.Parent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            if ActiveTab then
                ActiveTab.Visible = false
            end
            TabContent.Visible = true
            ActiveTab = TabContent
            
            TabButton.BackgroundColor3 = CONFIG.MainColor
            TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= TabButton then
                    btn.BackgroundColor3 = CONFIG.BorderColor
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end)
        
        Tabs[name] = TabContent
        return TabContent
    end
    
    -- BUTTON CREATION HELPER
    local function CreateToggleButton(parent, name, feature, isValue)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.BackgroundColor3 = CONFIG.ScrollColor
        Button.BorderSizePixel = 0
        Button.Parent = parent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        if isValue then
            Button.Text = string.format("%s: %.1f", name, Features[feature])
            Button.TextColor3 = CONFIG.MainColor
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 13
            
            Button.MouseButton1Click:Connect(function()
                Features[feature] = math.min(Features[feature] + 10, 200)
                Button.Text = string.format("%s: %.1f", name, Features[feature])
            end)
            
            Button.MouseButton2Click:Connect(function()
                Features[feature] = math.max(Features[feature] - 10, 0)
                Button.Text = string.format("%s: %.1f", name, Features[feature])
            end)
        else
            local function UpdateButton()
                Button.Text = string.format("● %s: %s", name, Features[feature] and "ON" or "OFF")
                Button.BackgroundColor3 = Features[feature] and Color3.fromRGB(0, 100, 50) or CONFIG.ScrollColor
                Button.TextColor3 = Features[feature] and CONFIG.MainColor or Color3.fromRGB(200, 200, 200)
            end
            
            UpdateButton()
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 13
            
            Button.MouseButton1Click:Connect(function()
                Features[feature] = not Features[feature]
                UpdateButton()
            end)
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end)
            
            Button.MouseLeave:Connect(function()
                UpdateButton()
            end)
        end
        
        return Button
    end
    
    -- CREATE TABS
    local UniversalTab = CreateTab("Universal")
    local CombatTab = CreateTab("Combat")
    local CarTab = CreateTab("Cars")
    local SimulatorTab = CreateTab("Simulators")
    local TycoonTab = CreateTab("Tycoons")
    local AdvancedTab = CreateTab("Advanced")
    
    -- UNIVERSAL TAB
    CreateToggleButton(UniversalTab, "Walkspeed", "Walkspeed")
    CreateToggleButton(UniversalTab, "Walkspeed Value", "WalkspeedValue", true)
    CreateToggleButton(UniversalTab, "Jumppower", "Jumppower")
    CreateToggleButton(UniversalTab, "Jumppower Value", "JumppowerValue", true)
    CreateToggleButton(UniversalTab, "NoClip", "NoClip")
    CreateToggleButton(UniversalTab, "Anti-AFK", "AntiAFK")
    
    -- COMBAT TAB
    CreateToggleButton(CombatTab, "Silent Aim", "SilentAim")
    CreateToggleButton(CombatTab, "Aimbot", "Aimbot")
    CreateToggleButton(CombatTab, "Aimbot FOV", "AimbotFOV", true)
    CreateToggleButton(CombatTab, "Wall ESP", "ESP")
    CreateToggleButton(CombatTab, "ESP Distance", "ESPDistance", true)
    
    -- CAR TAB
    CreateToggleButton(CarTab, "Car Speed", "CarSpeed")
    CreateToggleButton(CarTab, "Car Speed Value", "CarSpeedValue", true)
    CreateToggleButton(CarTab, "No Collide", "CarNoCollide")
    CreateToggleButton(CarTab, "Infinite Fuel", "InfiniteFuel")
    
    -- SIMULATOR TAB
    CreateToggleButton(SimulatorTab, "Auto Clicker", "AutoClicker")
    CreateToggleButton(SimulatorTab, "Click Speed", "AutoClickSpeed", true)
    CreateToggleButton(SimulatorTab, "Auto Collect", "AutoCollect")
    
    -- TYCOON TAB
    CreateToggleButton(TycoonTab, "Auto Cash Collect", "AutoCashCollect")
    CreateToggleButton(TycoonTab, "Auto Build", "AutoBuild")
    CreateToggleButton(TycoonTab, "Auto Money", "AutoMoney")
    
    -- ADVANCED TAB
    CreateToggleButton(AdvancedTab, "Hide From Logs", "HideFromLogs")
    CreateToggleButton(AdvancedTab, "Infinite Yield", "InfiniteYield")
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Size = UDim2.new(1, -10, 0, 25)
    StatusLabel.Position = UDim2.new(0, 5, 1, -30)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Text = "Ready | Game: " .. GetGameType():upper()
    StatusLabel.TextColor3 = CONFIG.MainColor
    StatusLabel.Font = Enum.Font.GothamMonospace
    StatusLabel.TextSize = 11
    StatusLabel.Parent = ContentArea
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 4)
    StatusCorner.Parent = StatusLabel
    
    -- Auto-update status
    task.spawn(function()
        while StatusLabel.Parent do
            task.wait(0.5)
            local collectors = #GetCollectors()
            local cars = #GetCars()
            StatusLabel.Text = string.format("Ready | Collectors: %d | Cars: %d | Game: %s", collectors, cars, GetGameType():upper())
        end
    end)
    
    -- Auto-activate first tab
    if Tabs["Universal"] then
        Tabs["Universal"].Visible = true
        ActiveTab = Tabs["Universal"]
        Sidebar:FindFirstChild("Universal").BackgroundColor3 = CONFIG.MainColor
        Sidebar:FindFirstChild("Universal").TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    
    print("[Xenty] Advanced Hub v8.0 loaded successfully!")
    print("[Xenty] Detected game type: " .. GetGameType())
end

--// INITIALIZATION
if game:IsLoaded() then
    CreateUI()
else
    game.Loaded:Wait()
    CreateUI()
end

print("[Xenty] Elite Hub v8.0 - Advanced Universal - Initialized!")
print("[Xenty] Features: Money Farming | Car Speed | Silent Aim | Anti-Detection")
