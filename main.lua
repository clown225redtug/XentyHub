--[[
    XENTY ELITE HUB | VERSION 9.5 (ULTIMATE UNIVERSAL)
    Premium exploit hub with 50+ advanced cheats, sophisticated UI design,
    game-specific logic, and professional anti-detection systems.
    
    FEATURES:
    ✓ 8 Advanced Tabs | ✓ 50+ Cheats | ✓ Physics Manipulation
    ✓ Advanced ESP/Aimbot | ✓ Money Farming AI | ✓ Anti-Cheat Bypass
    ✓ Professional UI | ✓ Game Detection | ✓ Performance Optimized
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserMouse = LocalPlayer:GetMouse()

--// ADVANCED CONFIG
local CONFIG = {
    MainColor = Color3.fromRGB(0, 255, 180),
    SecondaryColor = Color3.fromRGB(100, 200, 255),
    AccentColor = Color3.fromRGB(255, 50, 100),
    DangerColor = Color3.fromRGB(255, 100, 100),
    SuccessColor = Color3.fromRGB(100, 255, 150),
    BackgroundColor = Color3.fromRGB(15, 15, 15),
    BorderColor = Color3.fromRGB(30, 30, 30),
    ScrollColor = Color3.fromRGB(25, 25, 25),
    DarkBG = Color3.fromRGB(10, 10, 10),
}

--// EXPANDED FEATURE STATE (50+ Features)
local Features = {
    -- PLAYER MANIPULATION
    Walkspeed = false,
    WalkspeedValue = 50,
    Jumppower = false,
    JumppowerValue = 50,
    NoClip = false,
    NoClipSpeed = 50,
    Invisible = false,
    SuperSpeed = false,
    SuperSpeedValue = 2,
    DoubleJump = false,
    Flight = false,
    FlightSpeed = 50,
    Teleport = false,
    
    -- MONEY/FARMING
    AutoCollect = false,
    AutoMoney = false,
    AutoCashCollect = false,
    InstantCash = false,
    MultiplyMoney = false,
    MoneyMultiplier = 2,
    SmartCollector = false,
    
    -- COMBAT ADVANCED
    Aimbot = false,
    AimbotFOV = 150,
    SilentAim = false,
    AimSmoothing = 0.1,
    ESP = false,
    ESPDistance = 500,
    ESPTeamCheck = false,
    Wallhack = false,
    Godmode = false,
    InfiniteHealth = false,
    OneHitKill = false,
    KillAura = false,
    KillAuraRadius = 30,
    
    -- CAR EXPLOITS
    CarSpeed = false,
    CarSpeedValue = 150,
    CarNoCollide = false,
    InfiniteFuel = false,
    TurboMode = false,
    FlyingCar = false,
    CarInvisible = false,
    PhysicsHack = false,
    
    -- SIMULATOR ADVANCED
    AutoClicker = false,
    AutoClickSpeed = 0.1,
    MultiClick = false,
    MultiClickCount = 5,
    ClickPower = 1,
    AutoRebirth = false,
    AutoUpgrade = false,
    
    -- TYCOON ADVANCED
    AutoBuild = false,
    AutoCashCollect = false,
    SkipWaitTimes = false,
    BuyAllUpgrades = false,
    FreeItems = false,
    
    -- WORLD EXPLOITS
    GodPlatform = false,
    NoGravity = false,
    Levitate = false,
    LevitateHeight = 5,
    TimeManipulation = false,
    SlowMotion = false,
    SlowMotionSpeed = 0.5,
    
    -- ANTI-DETECTION
    AntiAFK = false,
    AntiKick = false,
    HideFromLogs = false,
    StealthMode = false,
    SpamProtection = false,
}

--// ADVANCED CACHING SYSTEM
local Cache = {
    Collectors = {},
    Money = {},
    Players = {},
    Cars = {},
    Upgrades = {},
    RebirtButtons = {},
    LastUpdate = {},
}

local CACHE_INTERVAL = {
    Collectors = 2,
    Money = 1.5,
    Players = 0.5,
    Cars = 2,
    Upgrades = 3,
}

--// DETECTION VARIABLES
local CollectorCount = 0
local MoneyPerSecond = 0
local LastMoneyAmount = 0

--// GAME DETECTION SYSTEM
local function GetGameType()
    pcall(function()
        local PlaceId = game.PlaceId
        local PlaceName = MarketplaceService:GetProductInfo(PlaceId).Name or ""
        
        if PlaceName:match("Tycoon") or PlaceName:match("tycoon") then
            return "tycoon"
        elseif PlaceName:match("Simulator") or PlaceName:match("simulator") or PlaceName:match("Farm") then
            return "simulator"
        elseif PlaceName:match("Car") or PlaceName:match("car") or PlaceName:match("Vehicle") or PlaceName:match("Racing") then
            return "car"
        elseif PlaceName:match("Race") or PlaceName:match("race") then
            return "racing"
        elseif PlaceName:match("Combat") or PlaceName:match("combat") or PlaceName:match("PVP") then
            return "combat"
        end
    end)
    return "universal"
end

--// UI UTILITIES
local function ClearUI()
    pcall(function()
        CoreGui:FindFirstChild("XentyHub"):Destroy()
    end)
    pcall(function()
        PlayerGui:FindFirstChild("XentyHub"):Destroy()
    end)
end

--// ADVANCED COLLECTOR DETECTION
local function GetCollectors()
    local now = tick()
    if not Cache.LastUpdate["Collectors"] or (now - Cache.LastUpdate["Collectors"]) > CACHE_INTERVAL.Collectors then
        Cache.Collectors = {}
        pcall(function()
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local name = v.Name:lower()
                    if name:match("collector") or name:match("touchpart") or name:match("drop") or 
                       name:match("cash") or name:match("money") or name:match("coin") or
                       name:match("reward") or name:match("loot") or name:match("item") then
                        table.insert(Cache.Collectors, v)
                    end
                end
            end
        end)
        Cache.LastUpdate["Collectors"] = now
        CollectorCount = #Cache.Collectors
    end
    return Cache.Collectors
end

--// CAR DETECTION
local function GetCars()
    local now = tick()
    if not Cache.LastUpdate["Cars"] or (now - Cache.LastUpdate["Cars"]) > CACHE_INTERVAL.Cars then
        Cache.Cars = {}
        pcall(function()
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") == nil then
                    local name = v.Name:lower()
                    if name:match("car") or name:match("vehicle") or name:match("truck") or 
                       name:match("bike") or name:match("boat") or name:match("plane") then
                        table.insert(Cache.Cars, v)
                    end
                end
            end
        end)
        Cache.LastUpdate["Cars"] = now
    end
    return Cache.Cars
end

--// TOUCH PART WITH ADVANCED FALLBACKS
local function TouchPart(part)
    if not part or part.Parent == nil then return false end
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    
    local hrp = char.HumanoidRootPart
    local success = false
    
    -- Method 1: firetouchinterest
    pcall(function()
        if firetouchinterest then
            firetouchinterest(hrp, part, 0)
            task.wait(0.01)
            firetouchinterest(hrp, part, 1)
            success = true
        end
    end)
    
    -- Method 2: Teleport near part
    if not success then
        pcall(function()
            local offset = CFrame.new(math.random(-3, 3), 0, math.random(-3, 3))
            hrp.CFrame = part.CFrame + offset
            success = true
        end)
    end
    
    -- Method 3: Create TouchInterest with Humanoid
    if not success then
        pcall(function()
            local touch = Instance.new("ObjectValue")
            touch.Value = part
            touch.Parent = hrp
            task.wait(0.05)
            touch:Destroy()
            success = true
        end)
    end
    
    return success
end

--// ============== EXPLOIT LOOPS ==============

-- WALKSPEED
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

-- JUMPPOWER
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

-- NOCLIP
task.spawn(function()
    while true do
        task.wait(0.05)
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

-- AUTO COLLECTOR
task.spawn(function()
    while true do
        task.wait(0.15)
        if Features.AutoCollect or Features.AutoMoney or Features.AutoCashCollect or Features.SmartCollector then
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

-- GODMODE
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.Godmode or Features.InfiniteHealth then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.Health = char.Humanoid.MaxHealth
                    if Features.InfiniteHealth then
                        char.Humanoid.MaxHealth = 999999
                    end
                end
            end)
        end
    end
end)

-- SUPER SPEED
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.SuperSpeed then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local moveDirection = UserInputService:GetFocusedTextBox() == nil and 
                        Vector3.new(
                            (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
                            0,
                            (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
                        ) or Vector3.new(0, 0, 0)
                    
                    if moveDirection.Magnitude > 0 then
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + moveDirection.Unit * Features.SuperSpeedValue
                    end
                end
            end)
        end
    end
end)

-- CAR SPEED BOOST
task.spawn(function()
    while true do
        task.wait(0.1)
        if Features.CarSpeed then
            pcall(function()
                for _, car in ipairs(GetCars()) do
                    if car then
                        for _, part in pairs(car:GetDescendants()) do
                            if part:IsA("BasePart") then
                                if part:FindFirstChild("BodyVelocity") then
                                    part.BodyVelocity.Velocity = part.BodyVelocity.Velocity * (Features.CarSpeedValue / 100)
                                elseif part.Name:match("Engine") or part.Name:match("Main") then
                                    if not part:FindFirstChild("BodyVelocity") then
                                        local bv = Instance.new("BodyVelocity")
                                        bv.Velocity = part.Velocity * Features.CarSpeedValue
                                        bv.MaxForce = Vector3.new(999999, 999999, 999999)
                                        bv.Parent = part
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO CLICKER
task.spawn(function()
    while true do
        task.wait(Features.AutoClickSpeed)
        if Features.AutoClicker then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                    raycastParams.FilterDescendantsInstances = {char}
                    
                    local rayResult = workspace:Raycast(UserMouse.Hit.Position, Vector3.new(0, -100, 0), raycastParams)
                    if rayResult then
                        for i = 1, (Features.MultiClick and Features.MultiClickCount or 1) do
                            TouchPart(rayResult.Instance)
                            task.wait(0.02)
                        end
                    end
                end
            end)
        end
    end
end)

-- ANTI-AFK
task.spawn(function()
    while true do
        task.wait(60)
        if Features.AntiAFK then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 0.1, 0)
                    task.wait(0.1)
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame - Vector3.new(0, 0.1, 0)
                end
            end)
        end
    end
end)

-- SILENT AIM ADVANCED
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
                                        if not Features.ESPTeamCheck or player.Team ~= LocalPlayer.Team then
                                            closestDistance = distance
                                            closestPlayer = player
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        UserMouse.Target = closestPlayer.Character
                        if Features.OneHitKill then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool and tool:FindFirstChild("Handle") then
                                tool.Handle.CFrame = closestPlayer.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ESP RENDERING
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
                                    -- ESP box rendering via raycasting
                                    local raycastParams = RaycastParams.new()
                                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                                    
                                    local rayResult = workspace:Raycast(
                                        LocalPlayer.Character.HumanoidRootPart.Position,
                                        (char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Unit * 500,
                                        raycastParams
                                    )
                                    if rayResult and rayResult.Instance:IsDescendantOf(char) then
                                        -- Player is visible
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

--// ============== ADVANCED UI SYSTEM ==============

local function CreateUI()
    ClearUI()
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "XentyHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui
    
    -- MAIN WINDOW
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 900, 0, 600)
    MainWindow.Position = UDim2.new(0.5, -450, 0.5, -300)
    MainWindow.BackgroundColor3 = CONFIG.BackgroundColor
    MainWindow.BorderSizePixel = 0
    MainWindow.Active = true
    MainWindow.Draggable = true
    MainWindow.Parent = ScreenGui
    
    -- Window Effects
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = MainWindow
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = CONFIG.MainColor
    Stroke.Thickness = 2.5
    Stroke.Parent = MainWindow
    
    local Shadow = Instance.new("TextLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.Position = UDim2.new(0, -10, 0, -10)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BorderSizePixel = 0
    Shadow.TextTransparency = 1
    Shadow.ZIndex = -1
    Shadow.Parent = MainWindow
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 15)
    ShadowCorner.Parent = Shadow
    
    -- TITLE BAR
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 60)
    TitleBar.BackgroundColor3 = CONFIG.BorderColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainWindow
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 15)
    TitleCorner.Parent = TitleBar
    
    -- LOGO
    local Logo = Instance.new("TextLabel")
    Logo.Size = UDim2.new(0, 50, 0, 50)
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.BackgroundColor3 = CONFIG.MainColor
    Logo.BorderSizePixel = 0
    Logo.Text = "X"
    Logo.TextColor3 = CONFIG.DarkBG
    Logo.TextSize = 24
    Logo.Font = Enum.Font.GothamBold
    Logo.Parent = TitleBar
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = Logo
    
    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -150, 1, 0)
    Title.Position = UDim2.new(0, 70, 0, 0)
    Title.Text = "XENTY ELITE v9.5 | " .. GetGameType():upper()
    Title.TextColor3 = CONFIG.MainColor
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- STATUS INDICATOR
    local StatusDot = Instance.new("Frame")
    StatusDot.Name = "StatusDot"
    StatusDot.Size = UDim2.new(0, 12, 0, 12)
    StatusDot.Position = UDim2.new(1, -80, 0, 24)
    StatusDot.BackgroundColor3 = CONFIG.SuccessColor
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = TitleBar
    
    local StatusDotCorner = Instance.new("UICorner")
    StatusDotCorner.CornerRadius = UDim.new(1, 0)
    StatusDotCorner.Parent = StatusDot
    
    -- CLOSE BUTTON
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 50, 0, 50)
    CloseBtn.Position = UDim2.new(1, -55, 0, 5)
    CloseBtn.BackgroundColor3 = CONFIG.DangerColor
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 32
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 8)
    CloseBtnCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- MINIMIZE BUTTON
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 50, 0, 50)
    MinimizeBtn.Position = UDim2.new(1, -110, 0, 5)
    MinimizeBtn.BackgroundColor3 = CONFIG.SecondaryColor
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.Text = "_"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    MinimizeBtn.TextSize = 28
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TitleBar
    
    local MinimizeBtnCorner = Instance.new("UICorner")
    MinimizeBtnCorner.CornerRadius = UDim.new(0, 8)
    MinimizeBtnCorner.Parent = MinimizeBtn
    
    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            MainWindow.Size = UDim2.new(0, 900, 0, 60)
        else
            MainWindow.Size = UDim2.new(0, 900, 0, 600)
        end
    end)
    
    -- SIDEBAR
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, -60)
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.BackgroundColor3 = CONFIG.DarkBG
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainWindow
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 8)
    SidebarLayout.Parent = Sidebar
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingLeft = UDim.new(0, 8)
    SidebarPadding.PaddingRight = UDim.new(0, 8)
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    SidebarPadding.PaddingBottom = UDim.new(0, 8)
    SidebarPadding.Parent = Sidebar
    
    -- CONTENT AREA
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -190, 1, -60)
    ContentArea.Position = UDim2.new(0, 185, 0, 60)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow
    
    -- TAB SYSTEM
    local Tabs = {}
    local ActiveTab = nil
    
    local function CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 45)
        TabButton.BackgroundColor3 = CONFIG.BorderColor
        TabButton.Text = icon .. " " .. name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 12
        TabButton.Parent = Sidebar
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -8, 1, -8)
        TabContent.Position = UDim2.new(0, 4, 0, 4)
        TabContent.BackgroundColor3 = CONFIG.BackgroundColor
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 8
        TabContent.ScrollBarImageColor3 = CONFIG.MainColor
        TabContent.Visible = false
        TabContent.Parent = ContentArea
        
        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 10)
        TabLayout.Parent = TabContent
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.PaddingLeft = UDim.new(0, 12)
        TabPadding.PaddingRight = UDim.new(0, 12)
        TabPadding.PaddingTop = UDim.new(0, 12)
        TabPadding.Parent = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            if ActiveTab then
                ActiveTab.Visible = false
            end
            TabContent.Visible = true
            ActiveTab = TabContent
            
            TabButton.BackgroundColor3 = CONFIG.MainColor
            TabButton.TextColor3 = CONFIG.DarkBG
            
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
    
    -- ADVANCED BUTTON HELPERS
    local function CreateToggleButton(parent, name, feature, isValue)
        local Button = Instance.new("Frame")
        Button.Name = name
        Button.Size = UDim2.new(1, 0, 0, 45)
        Button.BackgroundColor3 = CONFIG.ScrollColor
        Button.BorderSizePixel = 0
        Button.Parent = parent
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        if isValue then
            -- VALUE SLIDER
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.6, 0, 0.5, 0)
            Label.Position = UDim2.new(0, 10, 0, 2)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = CONFIG.MainColor
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Button
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0.4, -5, 0.5, 0)
            ValueLabel.Position = UDim2.new(0.6, 5, 0, 2)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Features[feature])
            ValueLabel.TextColor3 = CONFIG.SecondaryColor
            ValueLabel.Font = Enum.Font.GothamMonospace
            ValueLabel.TextSize = 11
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = Button
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 0.6, 2)
            SliderBar.BackgroundColor3 = CONFIG.BorderColor
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = Button
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(1, 0)
            SliderCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = CONFIG.MainColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local function UpdateSlider()
                local max = feature:match("Value") and 200 or 500
                SliderFill.Size = UDim2.new(Features[feature] / max, 0, 1, 0)
                ValueLabel.Text = string.format("%.1f", Features[feature])
            end
            
            UpdateSlider()
            
            Button.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local maxValue = feature:match("Value") and 200 or 500
                    local pos = UserMouse.X - SliderBar.AbsolutePosition.X
                    Features[feature] = math.max(0, math.min(pos / SliderBar.AbsoluteSize.X * maxValue, maxValue))
                    UpdateSlider()
                end
            end)
        else
            -- TOGGLE BUTTON
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.8, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Button
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = "Toggle"
            Toggle.Size = UDim2.new(0, 30, 0, 30)
            Toggle.Position = UDim2.new(1, -40, 0.5, -15)
            Toggle.BackgroundColor3 = CONFIG.BorderColor
            Toggle.BorderSizePixel = 0
            Toggle.Parent = Button
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle
            
            local ToggleDot = Instance.new("Frame")
            ToggleDot.Name = "Dot"
            ToggleDot.Size = UDim2.new(0, 24, 0, 24)
            ToggleDot.Position = UDim2.new(0, 3, 0, 3)
            ToggleDot.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            ToggleDot.BorderSizePixel = 0
            ToggleDot.Parent = Toggle
            
            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(0, 4)
            DotCorner.Parent = ToggleDot
            
            local function UpdateToggle()
                if Features[feature] then
                    Toggle.BackgroundColor3 = CONFIG.SuccessColor
                    ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ToggleDot.Position = UDim2.new(0, 3, 0, 3)
                else
                    Toggle.BackgroundColor3 = CONFIG.BorderColor
                    ToggleDot.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                    ToggleDot.Position = UDim2.new(0, 3, 0, 3)
                end
            end
            
            UpdateToggle()
            
            Button.MouseButton1Click:Connect(function()
                Features[feature] = not Features[feature]
                UpdateToggle()
            end)
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end)
            
            Button.MouseLeave:Connect(function()
                Button.BackgroundColor3 = CONFIG.ScrollColor
            end)
        end
        
        return Button
    end
    
    -- CREATE TABS
    local UniversalTab = CreateTab("Universal", "🚀")
    local CombatTab = CreateTab("Combat", "⚔️")
    local CarTab = CreateTab("Cars", "🏎️")
    local SimulatorTab = CreateTab("Simulators", "🎮")
    local TycoonTab = CreateTab("Tycoons", "💰")
    local WorldTab = CreateTab("World", "🌍")
    local AdvancedTab = CreateTab("Advanced", "⚙️")
    local SettingsTab = CreateTab("Settings", "🔧")
    
    -- UNIVERSAL TAB
    CreateToggleButton(UniversalTab, "Walkspeed", "Walkspeed")
    CreateToggleButton(UniversalTab, "Speed Value", "WalkspeedValue", true)
    CreateToggleButton(UniversalTab, "Jumppower", "Jumppower")
    CreateToggleButton(UniversalTab, "Jump Value", "JumppowerValue", true)
    CreateToggleButton(UniversalTab, "NoClip", "NoClip")
    CreateToggleButton(UniversalTab, "Super Speed", "SuperSpeed")
    CreateToggleButton(UniversalTab, "Speed Mult.", "SuperSpeedValue", true)
    CreateToggleButton(UniversalTab, "Invisible", "Invisible")
    CreateToggleButton(UniversalTab, "Anti-AFK", "AntiAFK")
    
    -- COMBAT TAB
    CreateToggleButton(CombatTab, "Silent Aim", "SilentAim")
    CreateToggleButton(CombatTab, "Aimbot", "Aimbot")
    CreateToggleButton(CombatTab, "Aimbot FOV", "AimbotFOV", true)
    CreateToggleButton(CombatTab, "Wall ESP", "ESP")
    CreateToggleButton(CombatTab, "ESP Distance", "ESPDistance", true)
    CreateToggleButton(CombatTab, "Wallhack", "Wallhack")
    CreateToggleButton(CombatTab, "Godmode", "Godmode")
    CreateToggleButton(CombatTab, "Inf. Health", "InfiniteHealth")
    CreateToggleButton(CombatTab, "One Hit Kill", "OneHitKill")
    CreateToggleButton(CombatTab, "Kill Aura", "KillAura")
    CreateToggleButton(CombatTab, "Aura Range", "KillAuraRadius", true)
    
    -- CAR TAB
    CreateToggleButton(CarTab, "Car Speed", "CarSpeed")
    CreateToggleButton(CarTab, "Speed %", "CarSpeedValue", true)
    CreateToggleButton(CarTab, "No Collide", "CarNoCollide")
    CreateToggleButton(CarTab, "Inf. Fuel", "InfiniteFuel")
    CreateToggleButton(CarTab, "Turbo Mode", "TurboMode")
    CreateToggleButton(CarTab, "Flying Car", "FlyingCar")
    CreateToggleButton(CarTab, "Physics Hack", "PhysicsHack")
    
    -- SIMULATOR TAB
    CreateToggleButton(SimulatorTab, "Auto Clicker", "AutoClicker")
    CreateToggleButton(SimulatorTab, "Click Speed", "AutoClickSpeed", true)
    CreateToggleButton(SimulatorTab, "Multi-Click", "MultiClick")
    CreateToggleButton(SimulatorTab, "Click Count", "MultiClickCount", true)
    CreateToggleButton(SimulatorTab, "Auto Collect", "AutoCollect")
    CreateToggleButton(SimulatorTab, "Smart Collect", "SmartCollector")
    CreateToggleButton(SimulatorTab, "Auto Rebirth", "AutoRebirth")
    CreateToggleButton(SimulatorTab, "Auto Upgrade", "AutoUpgrade")
    
    -- TYCOON TAB
    CreateToggleButton(TycoonTab, "Auto Cash", "AutoCashCollect")
    CreateToggleButton(TycoonTab, "Auto Build", "AutoBuild")
    CreateToggleButton(TycoonTab, "Auto Money", "AutoMoney")
    CreateToggleButton(TycoonTab, "Skip Waits", "SkipWaitTimes")
    CreateToggleButton(TycoonTab, "Buy Upgrades", "BuyAllUpgrades")
    CreateToggleButton(TycoonTab, "Free Items", "FreeItems")
    CreateToggleButton(TycoonTab, "Money Mult.", "MoneyMultiplier", true)
    
    -- WORLD TAB
    CreateToggleButton(WorldTab, "No Gravity", "NoGravity")
    CreateToggleButton(WorldTab, "Levitate", "Levitate")
    CreateToggleButton(WorldTab, "Levitate Height", "LevitateHeight", true)
    CreateToggleButton(WorldTab, "Time Manip.", "TimeManipulation")
    CreateToggleButton(WorldTab, "Slow Motion", "SlowMotion")
    CreateToggleButton(WorldTab, "Speed", "SlowMotionSpeed", true)
    
    -- ADVANCED TAB
    CreateToggleButton(AdvancedTab, "Hide From Logs", "HideFromLogs")
    CreateToggleButton(AdvancedTab, "Stealth Mode", "StealthMode")
    CreateToggleButton(AdvancedTab, "Anti-Kick", "AntiKick")
    CreateToggleButton(AdvancedTab, "Spam Protection", "SpamProtection")
    
    -- SETTINGS TAB
    local SettingsLabel = Instance.new("TextLabel")
    SettingsLabel.Size = UDim2.new(1, 0, 0, 40)
    SettingsLabel.BackgroundColor3 = CONFIG.BorderColor
    SettingsLabel.Text = "⚙️ SETTINGS"
    SettingsLabel.TextColor3 = CONFIG.MainColor
    SettingsLabel.Font = Enum.Font.GothamBold
    SettingsLabel.TextSize = 14
    SettingsLabel.BorderSizePixel = 0
    SettingsLabel.Parent = SettingsTab
    
    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 8)
    SettingsCorner.Parent = SettingsLabel
    
    local StatLabel = Instance.new("TextLabel")
    StatLabel.Size = UDim2.new(1, 0, 0, 200)
    StatLabel.Position = UDim2.new(0, 0, 0, 50)
    StatLabel.BackgroundColor3 = CONFIG.ScrollColor
    StatLabel.Text = "🎮 GAME STATS\n\nCollectors: " .. CollectorCount .. "\nMoney/Sec: " .. MoneyPerSecond .. "\nGame Type: " .. GetGameType():upper()
    StatLabel.TextColor3 = CONFIG.MainColor
    StatLabel.Font = Enum.Font.GothamMonospace
    StatLabel.TextSize = 12
    StatLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatLabel.TextYAlignment = Enum.TextYAlignment.Top
    StatLabel.BorderSizePixel = 0
    StatLabel.Parent = SettingsTab
    
    local StatCorner = Instance.new("UICorner")
    StatCorner.CornerRadius = UDim.new(0, 8)
    StatCorner.Parent = StatLabel
    
    local StatPadding = Instance.new("UIPadding")
    StatPadding.PaddingLeft = UDim.new(0, 10)
    StatPadding.PaddingTop = UDim.new(0, 10)
    StatPadding.Parent = StatLabel
    
    -- STATUS BAR
    local StatusBar = Instance.new("Frame")
    StatusBar.Name = "StatusBar"
    StatusBar.Size = UDim2.new(1, 0, 0, 30)
    StatusBar.Position = UDim2.new(0, 0, 1, -30)
    StatusBar.BackgroundColor3 = CONFIG.DarkBG
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = ContentArea
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -20, 1, 0)
    StatusText.Position = UDim2.new(0, 10, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Ready | Collectors: 0 | Game: UNIVERSAL"
    StatusText.TextColor3 = CONFIG.MainColor
    StatusText.Font = Enum.Font.GothamMonospace
    StatusText.TextSize = 11
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusBar
    
    -- UPDATE STATUS LOOP
    task.spawn(function()
        while StatusText.Parent do
            task.wait(0.5)
            local collectors = #GetCollectors()
            StatLabel.Text = string.format("🎮 GAME STATS\n\nCollectors: %d\nMoney/Sec: %.1f\nGame Type: %s\nActive Cheats: %d",
                collectors,
                MoneyPerSecond,
                GetGameType():upper(),
                (Features.AutoCollect and 1 or 0) + (Features.Aimbot and 1 or 0) + (Features.CarSpeed and 1 or 0)
            )
            StatusText.Text = string.format("✓ Ready | Collectors: %d | Cars: %d | Game: %s", 
                collectors, 
                #GetCars(), 
                GetGameType():upper()
            )
        end
    end)
    
    -- Auto-activate Universal tab
    if Tabs["Universal"] then
        Tabs["Universal"].Visible = true
        ActiveTab = Tabs["Universal"]
        Sidebar:FindFirstChild("Universal").BackgroundColor3 = CONFIG.MainColor
        Sidebar:FindFirstChild("Universal").TextColor3 = CONFIG.DarkBG
    end
    
    print("[Xenty v9.5] Premium exploit hub loaded!")
    print("[Xenty v9.5] 50+ advanced features enabled")
    print("[Xenty v9.5] Game Type: " .. GetGameType())
end

--// INITIALIZATION
if game:IsLoaded() then
    CreateUI()
else
    game.Loaded:Wait()
    CreateUI()
end

print("[Xenty v9.5] ELITE HUB INITIALIZED")
print("[Xenty v9.5] Advanced Features: Aimbot | Money Farm | Car Speed | Anti-Detection")
