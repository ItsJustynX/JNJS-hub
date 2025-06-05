if not game:IsLoaded() then game.Loaded:Wait() end

local Lib = {}
local uis, ts = game:GetService("UserInputService"), game:GetService("TweenService")

function Create(typestring, instance, props)
    local obj = typestring == "Instance.new" and Instance.new(instance) or typestring == "Drawing.new" and Drawing.new(instance)
    if not obj then return nil end
    for i, v in pairs(props or {}) do pcall(function() obj[i] = v end) end
    return obj
end

local Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Background_ = Color3.fromRGB(45, 45, 45),
        Line = Color3.fromRGB(82, 82, 82),
        TextLabel = Color3.fromRGB(240, 240, 240),
        TextLabel_ = Color3.fromRGB(124, 124, 124),
        Accent = Color3.fromRGB(120, 180, 255),
    },
    Ocean = {
        Background = Color3.fromRGB(20, 30, 40),
        Background_ = Color3.fromRGB(35, 50, 70),
        Line = Color3.fromRGB(40, 90, 120),
        TextLabel = Color3.fromRGB(200, 230, 255),
        TextLabel_ = Color3.fromRGB(120, 160, 200),
        Accent = Color3.fromRGB(0, 170, 255),
    },
    Darker = {
        Background = Color3.fromRGB(15, 15, 15),
        Background_ = Color3.fromRGB(25, 25, 25),
        Line = Color3.fromRGB(50, 50, 50),
        TextLabel = Color3.fromRGB(220, 220, 220),
        TextLabel_ = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(255, 70, 70),
    }
}

function Lib:CreateWindow(options)
    local theme = Themes[Themes[options.Theme] and options.Theme or "Dark"]
    local minsize = math.min(workspace.CurrentCamera.ViewportSize.X, workspace.CurrentCamera.ViewportSize.Y)

    local sg = Create("Instance.new", "ScreenGui", {
        Name = "Ui_Lib",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        Parent = (gethui and gethui()) or game.CoreGui
    })

    local f = Create("Instance.new", "Frame", {
        Name = "Main_Frame",
        Size = UDim2.new(0, minsize * 0.8, 0, minsize * 0.73),
        Position = UDim2.new(0.5, -minsize * 0.4, 0.5, -minsize * 0.365),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Visible = true,
        Parent = sg
    })

    local f_ = Create("Instance.new", "Frame", {
        Name = "Top_Bar",
        Size = UDim2.new(1, 0, 0, minsize * 0.06),
        BackgroundColor3 = theme.Background_,
        BorderSizePixel = 0,
        Parent = f
    })

    Create("Instance.new", "TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        TextSize = 12,
        TextColor3 = theme.TextLabel,
        Text = options.Title or "Executor UI",
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f_
    })

    local tabList = Create("Instance.new", "Frame", {
        Name = "Tab_List",
        Size = UDim2.new(0, minsize * 0.15, 1, -minsize * 0.12),
        Position = UDim2.new(0, 0, 0, minsize * 0.06),
        BackgroundColor3 = theme.Background_,
        BorderSizePixel = 0,
        Parent = f
    })

    Create("Instance.new", "UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = tabList
    })

    local contentFrame = Create("Instance.new", "Frame", {
        Name = "Tab_Content",
        Size = UDim2.new(1, -minsize * 0.15, 1, -minsize * 0.12),
        Position = UDim2.new(0, minsize * 0.15, 0, minsize * 0.06),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = f
    })

    local scroll = Create("Instance.new", "ScrollingFrame", {
        Name = "Scrollable_Area",
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = contentFrame
    })

    Create("Instance.new", "UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = scroll
    })

    if options.ToggleUI then
        local toggleBtn = Create("Instance.new", "TextButton", {
            Text = "",
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Parent = sg,
            AnchorPoint = Vector2.new(0.5, 0.5),
        })

        toggleBtn.TextScaled = true
        toggleBtn.TextTransparency = 1
        toggleBtn.AutoButtonColor = false
        toggleBtn.BackgroundTransparency = 0
        toggleBtn.ClipsDescendants = true
        toggleBtn.ZIndex = 2
        toggleBtn.Name = "UI_Toggle_Button"

        local uicorner = Instance.new("UICorner", toggleBtn)
        uicorner.CornerRadius = UDim.new(1, 0)

        local dragging, offset
        toggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                offset = input.Position - toggleBtn.Position
            end
        end)

        uis.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                toggleBtn.Position = UDim2.new(0, input.Position.X - offset.X.Offset, 0, input.Position.Y - offset.Y.Offset)
            end
        end)

        uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        local visible = true
        toggleBtn.MouseButton1Click:Connect(function()
            visible = not visible
            f.Visible = visible
            toggleBtn.BackgroundColor3 = visible and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
        end)
    end

    function Lib:CreateTab(name)
        local tabBtn = Create("Instance.new", "TextButton", {
            Text = name,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = theme.Background_,
            TextColor3 = theme.TextLabel_,
            BorderSizePixel = 0,
            Parent = tabList
        })

        local tabContent = Create("Instance.new", "Frame", {
            Name = name .. "_Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = scroll
        })

        Create("Instance.new", "UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            Parent = tabContent
        })

        tabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(scroll:GetChildren()) do
                if child:IsA("Frame") then
                    child.Visible = false
                end
            end
            tabContent.Visible = true
        end)

        if #scroll:GetChildren() == 1 then
            tabContent.Visible = true
        else
            tabContent.Visible = false
        end

        local api = {}

        function api:AddLabel(text)
            Create("Instance.new", "TextLabel", {
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = theme.TextLabel_,
                TextSize = 14,
                Size = UDim2.new(1, -10, 0, 20),
                Parent = tabContent
            })
        end

        function api:AddButton(opts)
            local btn = Create("Instance.new", "TextButton", {
                Text = opts.Name or "Button",
                TextSize = 14,
                BackgroundColor3 = theme.Line,
                TextColor3 = theme.TextLabel,
                Size = UDim2.new(1, -10, 0, 25),
                BorderSizePixel = 0,
                Parent = tabContent
            })
            btn.MouseButton1Click:Connect(function()
                if opts.Callback then opts.Callback() end
            end)
        end

        function api:AddToggle(opts)
            local value = opts.Default or false
            local toggle = Create("Instance.new", "TextButton", {
                Text = opts.Name or "Toggle",
                TextSize = 14,
                BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0),
                TextColor3 = theme.TextLabel,
                Size = UDim2.new(1, -10, 0, 25),
                BorderSizePixel = 0,
                Parent = tabContent
            })
            toggle.MouseButton1Click:Connect(function()
                value = not value
                toggle.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
                if opts.Callback then opts.Callback(value) end
            end)
        end

        return api
    end

    return Lib
end

return Lib
