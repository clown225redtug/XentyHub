--[[
    Xenty Elite Hub v7.0 (Xeno-Safe Edition)
    Fixed: "Nil Value" crashes by adding support checks.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

--// 1. CONFIGURATION
getgenv().Xenty = {
    Aimbot = false,
    AutoFarm = false,
    AutoCollect = false,
    MainColor = Color3.fromRGB(0, 255, 180)
}

--// 2. SAFE UTILS (Prevents the Nil Crash)
local function SafeFireTouch(part)
    -- This checks if firetouchinterest exists before calling it
    if firetouchinterest then
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 0)
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, part, 1)
    else
        -- Fallback: Teleport your character slightly to the part
        local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
        task.wait(0.1)
        LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
    end
end

--// 3. AUTOMATION LOOP
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().Xenty.AutoCollect then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "TouchInterest" and v.Parent:FindFirstChild("Collector") then
                    SafeFireTouch(v.Parent)
                end
            end
        end
    end
end)

--// 4. XENO-STABLE UI
local function BuildUI()
    -- Clean up old UI if it exists
    if CoreGui:FindFirstChild("XentyHub_Xeno") then CoreGui.XentyHub_Xeno:Destroy() end

    local Hub = Instance.new("ScreenGui")
    Hub.Name = "XentyHub_Xeno"
    Hub.Parent = CoreGui
    -- If it STILL won't show, uncomment the next line:
    -- Hub.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 400, 0, 250)
    Main.Position = UDim2.new(0.5, -200, 0.5, -125)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.Active = true
    Main.Draggable = true
    Main.Parent = Hub

    local UICorner = Instance.new("UICorner", Main)
    local UIStroke = Instance.new("UIStroke", Main)
    UIStroke.Color = getgenv().Xenty.MainColor
    UIStroke.Thickness = 2

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "XENTY ELITE [XENO]"
    Title.TextColor3 = getgenv().Xenty.MainColor
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    -- Example Function Button
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 180, 0, 40)
    Btn.Position = UDim2.new(0.5, -90, 0.4, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Btn.Text = "Auto-Collect: OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    Btn.MouseButton1Click:Connect(function()
        getgenv().Xenty.AutoCollect = not getgenv().Xenty.AutoCollect
        Btn.Text = "Auto-Collect: " .. (getgenv().Xenty.AutoCollect and "ON" or "OFF")
        Btn.TextColor3 = getgenv().Xenty.AutoCollect and getgenv().Xenty.MainColor or Color3.fromRGB(255, 255, 255)
    end)
end

BuildUI()
print("Xenty Xeno-Edition Loaded.")
