-- Steal An Egg - Custom Script Hub with Trap Immunity
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Steal An Egg Hub 🥚", 
    HidePremium = false, 
    SaveConfig = false, 
    ConfigFolder = "StealEggConfig",
    IntroEnabled = true,
    IntroText = "Loading Steal An Egg Hub..."
})

-- Global Variables & State
local AutoStealEnabled = false
local AutoPlaceEnabled = false
local MinRaritySelected = "Eternal"
local InfiniteJumpEnabled = false
local AntiTrapEnabled = true -- Default enabled for safer auto-steal
local StealSpeedStuds = 150
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Rarity hierarchy system (Rank higher number = rarer egg)
local RarityRanks = {
    ["Common"] = 1,
    ["Uncommon"] = 2,
    ["Rare"] = 3,
    ["Epic"] = 4,
    ["Legendary"] = 5,
    ["Mythic"] = 6,
    ["Eternal"] = 7,
    ["Divine"] = 8
}

-- Check if an egg meets the chosen minimum rarity requirement
local function IsRarityValid(eggRarity)
    local targetRank = RarityRanks[MinRaritySelected] or 1
    local eggRank = RarityRanks[eggRarity] or 0
    return eggRank >= targetRank
end

-- Anti-Trap Loop: Disables collision and TouchInterest on traps
task.spawn(function()
    while true do
        if AntiTrapEnabled then
            local trapsFolder = workspace:FindFirstChild("Traps") or workspace:FindFirstChild("Hazards") or workspace
            for _, obj in pairs(trapsFolder:GetDescendants()) do
                local name = string.lower(obj.Name)
                if string.find(name, "trap") or string.find(name, "mine") or string.find(name, "spike") or string.find(name, "laser") then
                    if obj:IsA("BasePart") then
                        obj.CanCollide = false
                        obj.CanTouch = false
                    elseif obj:IsA("TouchInterest") then
                        obj:Destroy() -- Removes touch damage triggers
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- Helper: Move character smoothly based on target speed with dynamic height offset
local function MoveToTarget(targetCFrame)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    -- Apply small vertical offset if Anti-Trap is active to hover over ground traps
    local finalCFrame = targetCFrame
    if AntiTrapEnabled then
        finalCFrame = targetCFrame + Vector3.new(0, 3.5, 0)
    end
    
    if StealSpeedStuds >= 350 then
        hrp.CFrame = finalCFrame
    else
        local distance = (hrp.Position - finalCFrame.Position).Magnitude
        local duration = math.clamp(distance / math.max(StealSpeedStuds, 1), 0.05, 10)
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = finalCFrame})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- Helper: Find user's plot/base location
local function GetBaseCFrame()
    local player = game.Players.LocalPlayer
    local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(player.Name)
    if plot and plot:FindFirstChild("Garden") then
        return plot.Garden.CFrame + Vector3.new(0, 3, 0)
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return player.Character.HumanoidRootPart.CFrame
    end
    return CFrame.new(0, 5, 0)
end

-- Infinite Jump Event Listener
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ==================== MOBILE FLOATING TOGGLE ====================
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "OrionMobileToggleGui"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(140, 40, 240)
ToggleButton.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "TOGGLE"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12.000
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(0.5, 0)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    local OrionUI = game:GetService("CoreGui"):FindFirstChild("Orion") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("Orion")
    if OrionUI then
        OrionUI.Enabled = not OrionUI.Enabled
    end
end)

-- ==================== TAB 1: MAIN PAGE ====================
local MainTab = Window:MakeTab({
    Name = "Main Page",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSection({ Name = "Auto Steal Egg System" })

MainTab:AddDropdown({
    Name = "Minimum Rarity Filter",
    Default = "Eternal",
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Eternal", "Divine"},
    Callback = function(Value)
        MinRaritySelected = Value
        OrionLib:MakeNotification({
            Name = "Filter Updated",
            Content = "Now targeting " .. Value .. " and higher!",
            Time = 3
        })
    end
})

MainTab:AddToggle({
    Name = "Auto Steal Egg",
    Default = false,
    Callback = function(Value)
        AutoStealEnabled = Value
        
        if AutoStealEnabled then
            task.spawn(function()
                while AutoStealEnabled do
                    local eggsFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("DroppedEggs") or workspace
                    local baseCFrame = GetBaseCFrame()
                    
                    for _, egg in pairs(eggsFolder:GetChildren()) do
                        if not AutoStealEnabled then break end
                        
                        local eggRarity = egg:GetAttribute("Rarity") or (egg:FindFirstChild("Rarity") and egg.Rarity.Value) or egg.Name
                        
                        if IsRarityValid(eggRarity) and (egg:FindFirstChild("TouchInterest") or egg:IsA("BasePart") or egg:IsA("Model")) then
                            local targetCFrame = egg:IsA("BasePart") and egg.CFrame or (egg.PrimaryPart and egg.PrimaryPart.CFrame)
                            
                            if targetCFrame then
                                MoveToTarget(targetCFrame)
                                task.wait(0.2)
                                
                                local prompt = egg:FindFirstChildOfClass("ProximityPrompt") or egg:FindFirstChild("Prompt", true)
                                if prompt then
                                    fireproximityprompt(prompt)
                                end
                                task.wait(0.3)
                                
                                MoveToTarget(baseCFrame)
                                task.wait(0.5)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

MainTab:AddSection({ Name = "Yard & Garden Automation" })

MainTab:AddToggle({
    Name = "Auto Egg Place in Yard",
    Default = false,
    Callback = function(Value)
        AutoPlaceEnabled = Value
        
        if AutoPlaceEnabled then
            task.spawn(function()
                while AutoPlaceEnabled do
                    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage")
                    local placeRemote = remotes:FindFirstChild("PlaceEgg") or remotes:FindFirstChild("DeployEgg")
                    
                    if placeRemote and placeRemote:IsA("RemoteEvent") then
                        placeRemote:FireServer()
                    else
                        local char = game.Players.LocalPlayer.Character
                        local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(game.Players.LocalPlayer.Name)
                        
                        if char and plot and plot:FindFirstChild("Garden") then
                            char.HumanoidRootPart.CFrame = plot.Garden.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                    task.wait(1.5)
                end
            end)
        end
    end
})

-- ==================== TAB 2: EGG PREDICTOR ====================
local PredictorTab = Window:MakeTab({
    Name = "Egg Predictor",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PredictorTab:AddSection({ Name = "Inventory Egg Scanner" })

PredictorTab:AddButton({
    Name = "Scan & Predict Inventory Eggs 🔮",
    Callback = function()
        local player = game.Players.LocalPlayer
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        
        local eggCount = 0
        
        local function InspectEgg(item)
            if string.find(string.lower(item.Name), "egg") or item:GetAttribute("IsEgg") then
                eggCount = eggCount + 1
                
                local predictedPet = item:GetAttribute("OutcomePet") 
                    or item:GetAttribute("PredictedPet")
                    or (item:FindFirstChild("PetOutcome") and item.PetOutcome.Value)
                    or (item:FindFirstChild("Pet") and item.Pet.Value)
                    or "Unknown Pet (Unseeded)"

                local petIncome = item:GetAttribute("PetIncome") 
                    or item:GetAttribute("Income")
                    or (item:FindFirstChild("Income") and item.Income.Value)
                    or (item:FindFirstChild("Multiplier") and item.Multiplier.Value)
                    or "100/sec (Est.)"

                OrionLib:MakeNotification({
                    Name = item.Name .. " Prediction",
                    Content = "Will Hatch: " .. tostring(predictedPet) .. "\nIncome: $" .. tostring(petIncome),
                    Time = 6
                })
            end
        end

        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do InspectEgg(tool) end
        end

        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then InspectEgg(tool) end
            end
        end

        if eggCount == 0 then
            OrionLib:MakeNotification({
                Name = "Egg Predictor",
                Content = "No eggs found in your inventory/backpack!",
                Time = 4
            })
        end
    end
})

-- ==================== TAB 3: PLAYER CONTROLS ====================
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSection({ Name = "Protections & Immunity" })

-- Trap Bypass Toggle
PlayerTab:AddToggle({
    Name = "Trap Immunity (Bypass Ground Hazards)",
    Default = true,
    Callback = function(Value)
        AntiTrapEnabled = Value
    end
})

PlayerTab:AddSection({ Name = "Movement Modifiers" })

PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 300,
    Default = 16,
    Color = Color3.fromRGB(140, 40, 240),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(140, 40, 240),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end    
})

PlayerTab:AddSection({ Name = "Abilities" })

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})

-- ==================== TAB 4: SETTINGS ====================
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddSection({ Name = "Auto-Steal Configuration" })

SettingsTab:AddSlider({
    Name = "Steal Speed (Studs/Sec)",
    Min = 0,
    Max = 350,
    Default = 150,
    Color = Color3.fromRGB(140, 40, 240),
    Increment = 5,
    ValueName = "Studs",
    Callback = function(Value)
        StealSpeedStuds = Value
    end    
})

-- Initialize Hub
OrionLib:Init()
