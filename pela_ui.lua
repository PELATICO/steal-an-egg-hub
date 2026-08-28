-- Pela UI - Custom UI Library (Redz Hub Style)
local PelaUI = {}
PelaUI.__index = PelaUI

-- Colors (Redz Hub Style - Dark with Neon Cyan)
local Colors = {
    Primary = Color3.fromRGB(20, 20, 30),      -- Dark background
    Secondary = Color3.fromRGB(30, 30, 45),   -- Slightly lighter
    Accent = Color3.fromRGB(0, 200, 255),     -- Neon Cyan
    Text = Color3.fromRGB(255, 255, 255),     -- White
    TextDim = Color3.fromRGB(150, 150, 150),  -- Gray text
    Danger = Color3.fromRGB(255, 50, 50),     -- Red
    Success = Color3.fromRGB(50, 200, 100),   -- Green
}

-- Main Window Constructor
function PelaUI:CreateWindow(config)
    config = config or {}
    
    local self = setmetatable({}, PelaUI)
    self.Name = config.Name or "Pela Hub"
    self.Size = config.Size or UDim2.new(0, 550, 0, 650)
    self.Position = config.Position or UDim2.new(0.5, -275, 0.5, -325)
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "PelaUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = self.Position
    self.MainFrame.BackgroundColor3 = Colors.Primary
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    
    -- Corner radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = self.MainFrame
    
    -- Stroke (border)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Colors.Accent
    Stroke.Thickness = 2
    Stroke.Parent = self.MainFrame
    
    -- Header
    self.Header = Instance.new("Frame")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 50)
    self.Header.BackgroundColor3 = Colors.Secondary
    self.Header.BorderSizePixel = 0
    self.Header.Parent = self.MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = self.Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Colors.Accent
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.Text = self.Name
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Header
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    CloseBtn.BackgroundColor3 = Colors.Danger
    CloseBtn.TextColor3 = Colors.Text
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.Parent = self.Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        self.MainFrame.Visible = not self.MainFrame.Visible
    end)
    
    -- Tab Buttons Frame
    self.TabButtonFrame = Instance.new("Frame")
    self.TabButtonFrame.Name = "TabButtonFrame"
    self.TabButtonFrame.Size = UDim2.new(1, 0, 0, 45)
    self.TabButtonFrame.Position = UDim2.new(0, 0, 0, 50)
    self.TabButtonFrame.BackgroundColor3 = Colors.Secondary
    self.TabButtonFrame.BorderSizePixel = 0
    self.TabButtonFrame.Parent = self.MainFrame
    
    local TabScroll = Instance.new("UIListLayout")
    TabScroll.FillDirection = Enum.FillDirection.Horizontal
    TabScroll.Padding = UDim.new(0, 5)
    TabScroll.SortOrder = Enum.SortOrder.LayoutOrder
    TabScroll.Parent = self.TabButtonFrame
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.Parent = self.TabButtonFrame
    
    -- Content Area
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, 0, 1, -95)
    self.ContentArea.Position = UDim2.new(0, 0, 0, 95)
    self.ContentArea.BackgroundColor3 = Colors.Primary
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ScrollBarThickness = 8
    self.ContentArea.ScrollBarImageColor3 = Colors.Accent
    self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentArea.Parent = self.MainFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Vertical
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = self.ContentArea
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingTop = UDim.new(0, 10)
    ContentPadding.PaddingBottom = UDim.new(0, 10)
    ContentPadding.Parent = self.ContentArea
    
    -- Connect layout changes
    ContentLayout.Changed:Connect(function()
        self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    self.TabButtonFrame = self.TabButtonFrame
    
    return self
end

-- Create Tab
function PelaUI:CreateTab(name)
    local tab = {
        Name = name,
        Elements = {},
        Frame = Instance.new("Frame"),
    }
    
    tab.Frame.Name = name
    tab.Frame.Size = UDim2.new(1, 0, 0, 0)
    tab.Frame.BackgroundTransparency = 1
    tab.Frame.BorderSizePixel = 0
    tab.Frame.LayoutOrder = #self.Tabs + 1
    tab.Frame.Parent = self.ContentArea
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Vertical
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = tab.Frame
    
    TabLayout.Changed:Connect(function()
        tab.Frame.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name
    TabBtn.Size = UDim2.new(0, 100, 1, 0)
    TabBtn.BackgroundColor3 = Colors.Secondary
    TabBtn.TextColor3 = Colors.TextDim
    TabBtn.TextSize = 14
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Text = name
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = self.TabButtonFrame
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 8)
    TabBtnCorner.Parent = TabBtn
    
    -- Tab switching
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
        end
        tab.Frame.Visible = true
        
        for _, btn in pairs(self.TabButtonFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Colors.Secondary
                btn.TextColor3 = Colors.TextDim
            end
        end
        
        TabBtn.BackgroundColor3 = Colors.Accent
        TabBtn.TextColor3 = Colors.Primary
    end)
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        TabBtn.BackgroundColor3 = Colors.Accent
        TabBtn.TextColor3 = Colors.Primary
        tab.Frame.Visible = true
    else
        tab.Frame.Visible = false
    end
    
    return tab
end

-- Add Section
function PelaUI:AddSection(tab, name)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundColor3 = Colors.Secondary
    Section.BorderSizePixel = 0
    Section.LayoutOrder = #tab.Elements + 1
    Section.Parent = tab.Frame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, -20, 1, 0)
    SectionLabel.Position = UDim2.new(0, 10, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.TextColor3 = Colors.Accent
    SectionLabel.TextSize = 14
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Text = name
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.Parent = Section
    
    table.insert(tab.Elements, Section)
    
    return Section
end

-- Add Toggle
function PelaUI:AddToggle(tab, config)
    config = config or {}
    
    local Container = Instance.new("Frame")
    Container.Name = config.Name or "Toggle"
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundColor3 = Colors.Secondary
    Container.BorderSizePixel = 0
    Container.LayoutOrder = #tab.Elements + 1
    Container.Parent = tab.Frame
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Colors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.Text = config.Name or "Toggle"
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    ToggleBtn.BackgroundColor3 = config.Default and Colors.Success or Colors.TextDim
    ToggleBtn.TextSize = 0
    ToggleBtn.Parent = Container
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleBtn
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 21, 0, 21)
    ToggleCircle.Position = config.Default and UDim2.new(1, -24, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.Parent = ToggleBtn
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local State = config.Default or false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        State = not State
        ToggleBtn.BackgroundColor3 = State and Colors.Success or Colors.TextDim
        
        local TweenService = game:GetService("TweenService")
        local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Tween = TweenService:Create(ToggleCircle, TweenInfo, {
            Position = State and UDim2.new(1, -24, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        })
        Tween:Play()
        
        if config.Callback then
            config.Callback(State)
        end
    end)
    
    table.insert(tab.Elements, Container)
    
    return {
        Toggle = ToggleBtn,
        GetState = function() return State end,
        SetState = function(newState)
            State = newState
            ToggleBtn.BackgroundColor3 = State and Colors.Success or Colors.TextDim
            ToggleBtn.Circle.Position = State and UDim2.new(1, -24, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        end
    }
end

-- Add Slider
function PelaUI:AddSlider(tab, config)
    config = config or {}
    config.Min = config.Min or 0
    config.Max = config.Max or 100
    config.Default = config.Default or config.Min
    
    local Container = Instance.new("Frame")
    Container.Name = config.Name or "Slider"
    Container.Size = UDim2.new(1, 0, 0, 60)
    Container.BackgroundColor3 = Colors.Secondary
    Container.BorderSizePixel = 0
    Container.LayoutOrder = #tab.Elements + 1
    Container.Parent = tab.Frame
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 8)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Colors.Text
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.Text = config.Name .. ": " .. config.Default
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Name = "SliderBg"
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.Position = UDim2.new(0, 10, 0, 35)
    SliderBg.BackgroundColor3 = Colors.Primary
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Container
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 3)
    SliderCorner.Parent = SliderBg
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Colors.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBg
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill
    
    local Thumb = Instance.new("Frame")
    Thumb.Name = "Thumb"
    Thumb.Size = UDim2.new(0, 16, 0, 16)
    Thumb.Position = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), -8, 0.5, -8)
    Thumb.BackgroundColor3 = Colors.Accent
    Thumb.BorderSizePixel = 0
    Thumb.Parent = SliderBg
    
    local ThumbCorner = Instance.new("UICorner")
    ThumbCorner.CornerRadius = UDim.new(1, 0)
    ThumbCorner.Parent = Thumb
    
    local CurrentValue = config.Default
    local Dragging = false
    
    local function UpdateSlider(input)
        local MouseLocation = game:GetService("UserInputService"):GetMouseLocation()
        local RelativeX = MouseLocation.X - SliderBg.AbsolutePosition.X
        local SliderWidth = SliderBg.AbsoluteSize.X
        
        local Percentage = math.clamp(RelativeX / SliderWidth, 0, 1)
        local NewValue = math.round(config.Min + (Percentage * (config.Max - config.Min)))
        
        CurrentValue = NewValue
        SliderFill.Size = UDim2.new(Percentage, 0, 1, 0)
        Thumb.Position = UDim2.new(Percentage, -8, 0.5, -8)
        Label.Text = config.Name .. ": " .. CurrentValue
        
        if config.Callback then
            config.Callback(CurrentValue)
        end
    end
    
    Thumb.MouseButton1Down:Connect(function()
        Dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessed)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    table.insert(tab.Elements, Container)
    
    return {
        GetValue = function() return CurrentValue end,
        SetValue = function(newValue)
            CurrentValue = math.clamp(newValue, config.Min, config.Max)
            local Percentage = (CurrentValue - config.Min) / (config.Max - config.Min)
            SliderFill.Size = UDim2.new(Percentage, 0, 1, 0)
            Thumb.Position = UDim2.new(Percentage, -8, 0.5, -8)
            Label.Text = config.Name .. ": " .. CurrentValue
        end
    }
end

-- Add Button
function PelaUI:AddButton(tab, config)
    config = config or {}
    
    local Btn = Instance.new("TextButton")
    Btn.Name = config.Name or "Button"
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Colors.Accent
    Btn.TextColor3 = Colors.Primary
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = config.Name or "Button"
    Btn.BorderSizePixel = 0
    Btn.LayoutOrder = #tab.Elements + 1
    Btn.Parent = tab.Frame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
    
    table.insert(tab.Elements, Btn)
    
    return Btn
end

-- Add Dropdown
function PelaUI:AddDropdown(tab, config)
    config = config or {}
    config.Options = config.Options or {}
    config.Default = config.Default or config.Options[1] or "Select"
    
    local Container = Instance.new("Frame")
    Container.Name = config.Name or "Dropdown"
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundColor3 = Colors.Secondary
    Container.BorderSizePixel = 0
    Container.LayoutOrder = #tab.Elements + 1
    Container.Parent = tab.Frame
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0.5, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Colors.TextDim
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.Text = config.Name or "Dropdown"
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Name = "DropdownBtn"
    DropdownBtn.Size = UDim2.new(1, -20, 0.5, 0)
    DropdownBtn.Position = UDim2.new(0, 10, 0.5, 0)
    DropdownBtn.BackgroundColor3 = Colors.Primary
    DropdownBtn.TextColor3 = Colors.Accent
    DropdownBtn.TextSize = 14
    DropdownBtn.Font = Enum.Font.Gotham
    DropdownBtn.Text = config.Default
    DropdownBtn.BorderSizePixel = 0
    DropdownBtn.Parent = Container
    
    local DropCorner = Instance.new("UICorner")
    DropCorner.CornerRadius = UDim.new(0, 6)
    DropCorner.Parent = DropdownBtn
    
    local DropdownMenu = Instance.new("Frame")
    DropdownMenu.Name = "DropdownMenu"
    DropdownMenu.Size = UDim2.new(1, 0, 0, (#config.Options * 35))
    DropdownMenu.Position = UDim2.new(0, 0, 1, 5)
    DropdownMenu.BackgroundColor3 = Colors.Secondary
    DropdownMenu.BorderSizePixel = 0
    DropdownMenu.Parent = Container
    DropdownMenu.Visible = false
    DropdownMenu.ZIndex = 10
    
    local MenuCorner = Instance.new("UICorner")
    MenuCorner.CornerRadius = UDim.new(0, 8)
    MenuCorner.Parent = DropdownMenu
    
    local MenuLayout = Instance.new("UIListLayout")
    MenuLayout.FillDirection = Enum.FillDirection.Vertical
    MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MenuLayout.Parent = DropdownMenu
    
    local SelectedValue = config.Default
    
    for i, option in pairs(config.Options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Name = option
        OptionBtn.Size = UDim2.new(1, 0, 0, 35)
        OptionBtn.BackgroundColor3 = Colors.Secondary
        OptionBtn.TextColor3 = Colors.Text
        OptionBtn.TextSize = 14
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.Text = option
        OptionBtn.BorderSizePixel = 0
        OptionBtn.LayoutOrder = i
        OptionBtn.Parent = DropdownMenu
        
        OptionBtn.MouseButton1Click:Connect(function()
            SelectedValue = option
            DropdownBtn.Text = option
            DropdownMenu.Visible = false
            
            if config.Callback then
                config.Callback(option)
            end
        end)
    end
    
    DropdownBtn.MouseButton1Click:Connect(function()
        DropdownMenu.Visible = not DropdownMenu.Visible
    end)
    
    table.insert(tab.Elements, Container)
    
    return {
        GetValue = function() return SelectedValue end,
        SetValue = function(newValue)
            SelectedValue = newValue
            DropdownBtn.Text = newValue
        end
    }
end

return PelaUI
