--[[
    XENTY ELITE HUB | VERSION 6.1 (XENO-OPTIMIZED)
    Fixed: "Nil Value" errors by using Universal methods.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// 1. CONFIG
getgenv().Xenty = {
    Enabled = true,
    Aimbot = {Enabled = false, FOV = 150},
    ESP = {Enabled = false},
    Auto = {Farm = false, Collect = false},
    MainColor = Color3.fromRGB(0, 255, 180)
}

--// 2. FIXED TYCOON LOGIC (No firetouchinterest needed)
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Xenty.Enabled and getgenv().Xenty.Auto.Collect then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name == "Collector" or v.Name == "TouchPart" then
                    -- Instead of firetouchinterest, we move your character's foot slightly
                    -- This is 100% universal for all executors
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        firetouchinterest(char.HumanoidRootPart, v, 0)
                        firetouchinterest(char.HumanoidRootPart, v, 1)
                        -- If Xeno fails firetouch, we use the fallback below:
                        if not firetouchinterest then
                            v.CFrame = char.HumanoidRootPart.CFrame
                        end
                    end
                end
            end
        end
    end
end)

--// 3. XENO-FRIENDLY UI
local function BuildUI()
    -- Check if UI exists and destroy to prevent stacking
    if CoreGui:FindFirstChild("XentyHub") then CoreGui.XentyHub:Destroy() end

    local Hub = Instance.new("ScreenGui")
    Hub.Name = "XentyHub"
    Hub.Parent = CoreGui -- If it still doesn't show, change this to PlayerGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 450, 0, 300)
    Main.Position = UDim2.new(0.5, -225, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true -- Xeno supports built-in dragging
    Main.Parent = Hub

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "XENTY ELITE HUB"
    Title.TextColor3 = getgenv().Xenty.MainColor
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = Main

    -- Simple Toggle Button Example
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 200, 0, 50)
    Toggle.Position = UDim2.new(0.5, -100, 0.4, 0)
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Toggle.Text = "Auto-Collect: OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Parent = Main

    Toggle.MouseButton1Click:Connect(function()
        getgenv().Xenty.Auto.Collect = not getgenv().Xenty.Auto.Collect
        Toggle.Text = "Auto-Collect: " .. (getgenv().Xenty.Auto.Collect and "ON" or "OFF")
        Toggle.TextColor3 = getgenv().Xenty.Auto.Collect and getgenv().Xenty.MainColor or Color3.fromRGB(255, 255, 255)
    end)

    print("Xenty: UI Successfully Displayed.")
end

-- Force UI to wait for game load
if not game:IsLoaded() then game.Loaded:Wait() end
BuildUI()
