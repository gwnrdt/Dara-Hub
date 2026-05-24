if getgenv().RblxCallDialog then return end
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local function fetchImage(url, filename)
    local request = http_request or (syn and syn.request) or request
    local response = request({
        Url = url,
        Method = "GET",
    })
    
    if response and response.Body then
        local folder = ".temp/img"
        if not isfolder(folder) then
            makefolder(folder)
        end
        
        local path = folder .. "/" .. filename
        writefile(path, response.Body)
        local image = getcustomasset(path)
        
        task.delay(1, function()
            if isfile(path) then
                delfile(path)
            end
        end)
        
        return image
    end
    
    return nil
end

local function cleanupTempFolder()
    if isfolder(".temp/img") then
        local files = listfiles(".temp/img")
        if #files == 0 then
            delfolder(".temp/img")
        end
    end
    if isfolder(".temp") then
        local files = listfiles(".temp")
        if #files == 0 then
            delfolder(".temp")
        end
    end
end

getgenv().RblxCallDialog = function(config)
    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CallDialogScreen"
    screenGui.DisplayOrder = 8
    screenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui

    local overlay = Instance.new("TextButton")
    overlay.Name = "Overlay"
    overlay.Text = ""
    overlay.AutoButtonColor = false
    overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    overlay.BackgroundTransparency = 0.25
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Parent = screenGui
    
    local callDialog = Instance.new("ImageButton")
    callDialog.Name = "CallDialog"
    callDialog.Image = "rbxasset://LuaPackages/Packages/_Index/FoundationImages/FoundationImages/SpriteSheets/img_set_3x_19.png"
    callDialog.ImageColor3 = Color3.fromRGB(39, 41, 48)
    callDialog.ImageRectOffset = Vector2.new(970, 476)
    callDialog.ImageRectSize = Vector2.new(51, 51)
    callDialog.ScaleType = Enum.ScaleType.Slice
    callDialog.SliceCenter = Rect.new(24, 24, 27, 27)
    callDialog.SliceScale = 0.3333333432674408
    callDialog.AutoButtonColor = false
    callDialog.AnchorPoint = Vector2.new(0.5, 0.5)
    callDialog.BackgroundColor3 = Color3.fromRGB(39, 41, 48)
    callDialog.BackgroundTransparency = 1
    callDialog.BorderSizePixel = 0
    callDialog.ClipsDescendants = true
    callDialog.Position = UDim2.fromScale(0.5, 0.5)
    callDialog.Selectable = false
    callDialog.Size = UDim2.fromOffset(400, 0)
    callDialog.AutomaticSize = Enum.AutomaticSize.Y
    callDialog.Parent = screenGui

    local dialogListLayout = Instance.new("UIListLayout")
    dialogListLayout.Name = "DialogLayout"
    dialogListLayout.Padding = UDim.new(0, 0)
    dialogListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dialogListLayout.Parent = callDialog

    local alertContents = Instance.new("ImageLabel")
    alertContents.Name = "AlertContents"
    alertContents.BackgroundTransparency = 1
    alertContents.BorderSizePixel = 0
    alertContents.Size = UDim2.new(1, 0, 0, 0)
    alertContents.AutomaticSize = Enum.AutomaticSize.Y
    alertContents.LayoutOrder = 1
    alertContents.Parent = callDialog

    local alertListLayout = Instance.new("UIListLayout")
    alertListLayout.Name = "AlertLayout"
    alertListLayout.Padding = UDim.new(0, 0)
    alertListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    alertListLayout.Parent = alertContents

    local titleContainer = Instance.new("ImageLabel")
    titleContainer.Name = "TitleContainer"
    titleContainer.BackgroundTransparency = 1
    titleContainer.LayoutOrder = 1
    titleContainer.Size = UDim2.new(1, 0, 0, 0)
    titleContainer.AutomaticSize = Enum.AutomaticSize.Y
    titleContainer.Parent = alertContents

    local titleContainerLayout = Instance.new("UIListLayout")
    titleContainerLayout.Name = "TitleContainerLayout"
    titleContainerLayout.Padding = UDim.new(0, 8)
    titleContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    titleContainerLayout.Parent = titleContainer

    local titleContainerPadding = Instance.new("UIPadding")
    titleContainerPadding.Name = "TitleContainerPadding"
    titleContainerPadding.PaddingTop = UDim.new(0, 0)
    titleContainerPadding.Parent = titleContainer

    local titleArea = Instance.new("ImageLabel")
    titleArea.Name = "TitleArea"
    titleArea.BackgroundTransparency = 1
    titleArea.LayoutOrder = 1
    titleArea.Size = UDim2.new(1, 0, 0, 0)
    titleArea.AutomaticSize = Enum.AutomaticSize.Y
    titleArea.Parent = titleContainer

    local titleAreaLayout = Instance.new("UIListLayout")
    titleAreaLayout.Name = "TitleAreaLayout"
    titleAreaLayout.Padding = UDim.new(0, 12)
    titleAreaLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    titleAreaLayout.SortOrder = Enum.SortOrder.LayoutOrder
    titleAreaLayout.Parent = titleArea

    local iconOrder = config.IconOrder or "Bottom"

    if config.Icon and iconOrder == "Top" then
        local iconContainer = Instance.new("Frame")
        iconContainer.Name = "IconContainer"
        iconContainer.BackgroundTransparency = 1
        iconContainer.LayoutOrder = 1
        iconContainer.Size = UDim2.new(1, 0, 0, 0)
        iconContainer.AutomaticSize = Enum.AutomaticSize.Y
        iconContainer.Parent = titleArea

        local iconPadding = Instance.new("UIPadding")
        iconPadding.Name = "IconPadding"
        iconPadding.PaddingTop = UDim.new(0, 4)
        iconPadding.PaddingBottom = UDim.new(0, 4)
        iconPadding.Parent = iconContainer

        local iconSize = config.IconSize or 30
        
        if type(iconSize) == "number" then
            iconSize = UDim2.fromOffset(iconSize, iconSize)
        end

        if string.find(config.Icon, "rbxassetid://") or string.find(config.Icon, "https://") or string.find(config.Icon, "http://") then
            local iconLabel = Instance.new("ImageLabel")
            iconLabel.Name = "Icon"
            iconLabel.BackgroundTransparency = 1
            iconLabel.Size = iconSize
            iconLabel.AnchorPoint = Vector2.new(0.5, 0)
            iconLabel.Position = UDim2.new(0.5, 0, 0, 0)
            iconLabel.Parent = iconContainer

            if string.find(config.Icon, "https://") or string.find(config.Icon, "http://") then
                local filename = "icon_" .. tick() .. ".png"
                local image = fetchImage(config.Icon, filename)
                if image then
                    iconLabel.Image = image
                end
            else
                iconLabel.Image = config.Icon
            end
        else
            local iconLabel = Instance.new("TextLabel")
            iconLabel.Name = "Icon"
            iconLabel.BackgroundTransparency = 1
            iconLabel.Size = iconSize
            iconLabel.AnchorPoint = Vector2.new(0.5, 0)
            iconLabel.Position = UDim2.new(0.5, 0, 0, 0)
            iconLabel.Text = "<font family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json' weight='Regular' style='Normal'>" .. config.Icon .. "</font>"
            iconLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
            iconLabel.TextSize = iconSize.X.Offset
            iconLabel.RichText = true
            iconLabel.Parent = iconContainer
        end
    end

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    title.Text = config.Title or ""
    title.TextColor3 = Color3.fromRGB(247, 247, 248)
    title.TextSize = config.TitleTextSize or 25
    title.TextScaled = config.TitleTextScaled or false
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.TextWrapped = true
    title.BackgroundTransparency = 1
    title.LayoutOrder = 2
    title.Size = UDim2.new(1, -24, 0, 0)
    title.AutomaticSize = Enum.AutomaticSize.Y
    title.Parent = titleArea

    if config.Icon and iconOrder == "Bottom" then
        local iconContainer = Instance.new("Frame")
        iconContainer.Name = "IconContainer"
        iconContainer.BackgroundTransparency = 1
        iconContainer.LayoutOrder = 3
        iconContainer.Size = UDim2.new(1, 0, 0, 0)
        iconContainer.AutomaticSize = Enum.AutomaticSize.Y
        iconContainer.Parent = titleArea

        local iconPadding = Instance.new("UIPadding")
        iconPadding.Name = "IconPadding"
        iconPadding.PaddingTop = UDim.new(0, 4)
        iconPadding.PaddingBottom = UDim.new(0, 4)
        iconPadding.Parent = iconContainer

        local iconSize = config.IconSize or 30
        
        if type(iconSize) == "number" then
            iconSize = UDim2.fromOffset(iconSize, iconSize)
        end

        if string.find(config.Icon, "rbxassetid://") or string.find(config.Icon, "https://") or string.find(config.Icon, "http://") then
            local iconLabel = Instance.new("ImageLabel")
            iconLabel.Name = "Icon"
            iconLabel.BackgroundTransparency = 1
            iconLabel.Size = iconSize
            iconLabel.AnchorPoint = Vector2.new(0.5, 0)
            iconLabel.Position = UDim2.new(0.5, 0, 0, 0)
            iconLabel.Parent = iconContainer

            if string.find(config.Icon, "https://") or string.find(config.Icon, "http://") then
                local filename = "icon_" .. tick() .. ".png"
                local image = fetchImage(config.Icon, filename)
                if image then
                    iconLabel.Image = image
                end
            else
                iconLabel.Image = config.Icon
            end
        else
            local iconLabel = Instance.new("TextLabel")
            iconLabel.Name = "Icon"
            iconLabel.BackgroundTransparency = 1
            iconLabel.Size = iconSize
            iconLabel.AnchorPoint = Vector2.new(0.5, 0)
            iconLabel.Position = UDim2.new(0.5, 0, 0, 0)
            iconLabel.Text = "<font family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json' weight='Regular' style='Normal'>" .. config.Icon .. "</font>"
            iconLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
            iconLabel.TextSize = iconSize.X.Offset
            iconLabel.RichText = true
            iconLabel.Parent = iconContainer
        end
    end

    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.BackgroundColor3 = Color3.fromRGB(208, 217, 251)
    underline.BackgroundTransparency = 0.8399999737739563
    underline.BorderSizePixel = 0
    underline.LayoutOrder = 4
    underline.Size = UDim2.new(1, 0, 0, 1)
    underline.Parent = titleArea

    local titleAreaPadding = Instance.new("UIPadding")
    titleAreaPadding.Name = "TitleAreaPadding"
    titleAreaPadding.Parent = titleArea

    local middleContent = Instance.new("ImageLabel")
    middleContent.Name = "MiddleContent"
    middleContent.BackgroundTransparency = 1
    middleContent.LayoutOrder = 2
    middleContent.Size = UDim2.new(1, 0, 0, 0)
    middleContent.AutomaticSize = Enum.AutomaticSize.Y
    middleContent.Parent = alertContents

    local middleContentLayout = Instance.new("UIListLayout")
    middleContentLayout.Name = "MiddleContentLayout"
    middleContentLayout.Padding = UDim.new(0, 8)
    middleContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    middleContentLayout.Parent = middleContent

    local middleContentPadding = Instance.new("UIPadding")
    middleContentPadding.Name = "MiddleContentPadding"
    middleContentPadding.PaddingLeft = UDim.new(0, 24)
    middleContentPadding.PaddingRight = UDim.new(0, 24)
    middleContentPadding.PaddingTop = UDim.new(0, 8)
    middleContentPadding.Parent = middleContent

    local content = Instance.new("ImageLabel")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.LayoutOrder = 1
    content.Size = UDim2.new(1, 0, 0, 0)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.Parent = middleContent

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Name = "ContentLayout"
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = content

    local contentPadding = Instance.new("UIPadding")
    contentPadding.Name = "ContentPadding"
    contentPadding.Parent = content

    local bodyText = Instance.new("TextLabel")
    bodyText.Name = "BodyText"
    bodyText.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    bodyText.Text = config.Desc or config.Description or ""
    bodyText.TextColor3 = Color3.fromRGB(213, 215, 221)
    bodyText.TextSize = config.DescTextSize or 20
    bodyText.TextScaled = config.DescTextScaled or false
    bodyText.TextWrapped = true
    bodyText.BackgroundTransparency = 1
    bodyText.LayoutOrder = 1
    bodyText.Size = UDim2.new(1, 0, 0, 0)
    bodyText.AutomaticSize = Enum.AutomaticSize.Y
    bodyText.Parent = content

    if config.CheckBoxEnabled and config.Checkbox then
        local checkboxContainer = Instance.new("Frame")
        checkboxContainer.Name = "CheckboxContainer"
        checkboxContainer.BackgroundTransparency = 1
        checkboxContainer.Size = UDim2.new(1, 0, 0, 30)
        checkboxContainer.LayoutOrder = 2
        checkboxContainer.Parent = content

        local checkboxLayout = Instance.new("UIListLayout")
        checkboxLayout.Name = "CheckboxLayout"
        checkboxLayout.FillDirection = Enum.FillDirection.Horizontal
        checkboxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        checkboxLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        checkboxLayout.Padding = UDim.new(0, 8)
        checkboxLayout.SortOrder = Enum.SortOrder.LayoutOrder
        checkboxLayout.Parent = checkboxContainer

        local checkbox = Instance.new("ImageButton")
        checkbox.Name = "Checkbox"
        checkbox.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
        checkbox.Size = UDim2.fromOffset(20, 20)
        checkbox.AutoButtonColor = false
        checkbox.Parent = checkboxContainer
        
        local checkboxStroke = Instance.new("UIStroke")
        checkboxStroke.Color = Color3.fromRGB(255, 255, 255)
        checkboxStroke.Thickness = 1
        checkboxStroke.Parent = checkbox

        local checkmark = Instance.new("TextLabel")
        checkmark.Name = "Checkmark"
        checkmark.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        checkmark.Text = "✓"
        checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
        checkmark.TextSize = 14
        checkmark.BackgroundTransparency = 1
        checkmark.Size = UDim2.fromScale(1, 1)
        checkmark.Visible = false
        checkmark.Parent = checkbox

        local checkboxText = Instance.new("TextLabel")
        checkboxText.Name = "CheckboxText"
        checkboxText.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        checkboxText.Text = config.Checkbox.Text or ""
        checkboxText.TextColor3 = Color3.fromRGB(213, 215, 221)
        checkboxText.TextSize = config.Checkbox.TextSize or 16
        checkboxText.TextScaled = config.Checkbox.TextScaled or false
        checkboxText.TextXAlignment = Enum.TextXAlignment.Left
        checkboxText.BackgroundTransparency = 1
        checkboxText.Size = UDim2.new(0.8, 0, 0, 20)
        checkboxText.Parent = checkboxContainer

        local checkboxCorner = Instance.new("UICorner")
        checkboxCorner.CornerRadius = UDim.new(0, 4)
        checkboxCorner.Parent = checkbox

        local checked = false
        
        checkbox.MouseEnter:Connect(function()
            if not config.Checkbox.Disabled then
                checkbox.BackgroundColor3 = Color3.fromRGB(61, 63, 71)
            end
        end)
        
        checkbox.MouseLeave:Connect(function()
            if not config.Checkbox.Disabled then
                checkbox.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
            end
        end)
        
        checkbox.MouseButton1Click:Connect(function()
            if config.Checkbox.Disabled then return end
            
            checked = not checked
            checkmark.Visible = checked
            
            if config.Checkbox.Callback then
                config.Checkbox.Callback(checked)
            end
        end)
        
        if config.Checkbox.InitialChecked then
            checked = true
            checkmark.Visible = true
        end
        
        if config.Checkbox.Disabled then
            checkbox.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
            checkbox.Active = false
            checkboxText.TextTransparency = 0.5
        end
    end

    local footer = Instance.new("ImageLabel")
    footer.Name = "Footer"
    footer.BackgroundTransparency = 1
    footer.LayoutOrder = 3
    footer.Size = UDim2.new(1, 0, 0, 0)
    footer.AutomaticSize = Enum.AutomaticSize.Y
    footer.Parent = alertContents

    local footerLayout = Instance.new("UIListLayout")
    footerLayout.Name = "FooterLayout"
    footerLayout.Padding = UDim.new(0, 12)
    footerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    footerLayout.Parent = footer

    local footerPadding = Instance.new("UIPadding")
    footerPadding.Name = "FooterPadding"
    footerPadding.PaddingLeft = UDim.new(0, 24)
    footerPadding.PaddingRight = UDim.new(0, 24)
    footerPadding.PaddingTop = UDim.new(0, 24)
    footerPadding.PaddingBottom = UDim.new(0, 12)
    footerPadding.Parent = footer

    local buttons = Instance.new("ImageLabel")
    buttons.Name = "Buttons"
    buttons.BackgroundTransparency = 1
    buttons.LayoutOrder = 1
    buttons.Size = UDim2.new(1, 0, 0, 36)
    buttons.Parent = footer

    local buttonListLayout = Instance.new("UIListLayout")
    buttonListLayout.Name = "ButtonLayout"
    buttonListLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonListLayout.Padding = UDim.new(0, 10)
    buttonListLayout.Parent = buttons

    local function createButton(buttonConfig, buttonPosition, isSingleButton)
        local button = Instance.new("ImageButton")
        button.Name = "Button" .. buttonPosition
        
        if isSingleButton then
            button.Size = UDim2.new(0, 352, 0, 36)
        else
            button.Size = UDim2.new(0.5, -5, 0, 36)
        end
        
        if buttonConfig.Type == "White" then
            button.BackgroundTransparency = 0
            button.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
        else
            button.BackgroundTransparency = 1
        end
        
        button.AutoButtonColor = false
        button.Parent = buttons

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = button

        local frame = Instance.new("Frame")
        frame.Name = "Frame"
        
        if buttonConfig.Type == "White" then
            frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            frame.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
        end
        
        frame.BorderSizePixel = 0
        frame.Size = UDim2.fromScale(1, 1)
        frame.Parent = button
        frame.ClipsDescendants = true

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 4)
        uiCorner.Parent = frame

        if buttonConfig.Type == "GreyOutline" then
            local uiStroke = Instance.new("UIStroke")
            uiStroke.Color = Color3.fromRGB(255, 255, 255)
            uiStroke.Thickness = 1
            uiStroke.Parent = frame
        end

        local gradient = Instance.new("UIGradient")
        gradient.Name = "Gradient"
        gradient.Rotation = 0
        gradient.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        gradient.Parent = frame

        local buttonText = Instance.new("TextLabel")
        buttonText.Name = "Text"
        buttonText.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        buttonText.Text = buttonConfig.Title or ""
        buttonText.TextColor3 = buttonConfig.Type == "White" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        buttonText.TextSize = buttonConfig.TextSize or 20
        buttonText.TextScaled = buttonConfig.TextScaled or false
        buttonText.TextWrapped = true
        buttonText.BackgroundTransparency = 1
        buttonText.Size = UDim2.fromScale(1, 1)
        buttonText.ZIndex = 2
        buttonText.Parent = frame

        button.MouseEnter:Connect(function()
            if button.Active and not buttonConfig.Disabled then
                if buttonConfig.Type == "White" then
                    frame.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
                else
                    frame.BackgroundColor3 = Color3.fromRGB(61, 63, 71)
                end
            end
        end)

        button.MouseLeave:Connect(function()
            if button.Active and not buttonConfig.Disabled then
                if buttonConfig.Type == "White" then
                    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                else
                    frame.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
                end
            end
        end)

        return button, gradient, frame
    end

    local buttonCount = 0
    local buttons_list = {}

    if config.Button1 then
        buttonCount = buttonCount + 1
    end

    if config.Button2 then
        buttonCount = buttonCount + 1
    end

    local isSingleButton = (buttonCount == 1)

    if config.Button1 then
        local button, gradient, frame = createButton(config.Button1, 1, isSingleButton)
        buttons_list[1] = {button = button, gradient = gradient, frame = frame, config = config.Button1}
    end

    if config.Button2 then
        local button, gradient, frame = createButton(config.Button2, 2, isSingleButton)
        buttons_list[2] = {button = button, gradient = gradient, frame = frame, config = config.Button2}
    end

    if buttonCount == 0 then
        local closeButton = Instance.new("ImageButton")
        closeButton.Name = "CloseButton"
        closeButton.BackgroundTransparency = 1
        closeButton.Size = UDim2.new(0.5, -5, 0, 36)
        closeButton.AutoButtonColor = false
        closeButton.Parent = buttons
        
        local closeButtonCorner = Instance.new("UICorner")
        closeButtonCorner.CornerRadius = UDim.new(0, 4)
        closeButtonCorner.Parent = closeButton
        
        local closeFrame = Instance.new("Frame")
        closeFrame.Name = "Frame"
        closeFrame.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
        closeFrame.BorderSizePixel = 0
        closeFrame.Size = UDim2.fromScale(1, 1)
        closeFrame.Parent = closeButton
        closeFrame.ClipsDescendants = true
        
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = Color3.fromRGB(255, 255, 255)
        uiStroke.Thickness = 1
        uiStroke.Parent = closeFrame
        
        local closeText = Instance.new("TextLabel")
        closeText.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        closeText.Text = "Close"
        closeText.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeText.TextSize = 20
        closeText.BackgroundTransparency = 1
        closeText.Size = UDim2.fromScale(1, 1)
        closeText.Parent = closeFrame
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 4)
        uiCorner.Parent = closeFrame
        
        closeButton.MouseEnter:Connect(function()
            if closeButton.Active then
                closeFrame.BackgroundColor3 = Color3.fromRGB(61, 63, 71)
            end
        end)
        
        closeButton.MouseLeave:Connect(function()
            if closeButton.Active then
                closeFrame.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
            end
        end)
        
        closeButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
    else
        for i, buttonData in pairs(buttons_list) do
            local button = buttonData.button
            local gradient = buttonData.gradient
            local frame = buttonData.frame
            local btnConfig = buttonData.config
            
            if btnConfig.WaitTimeClick and btnConfig.WaitTimeClick > 0 then
                button.Active = false
                
                if btnConfig.Type == "White" then
                    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                else
                    frame.BackgroundColor3 = Color3.fromRGB(61, 63, 71)
                end
                
                local startTime = tick()
                local duration = btnConfig.WaitTimeClick
                
                local connection
                connection = game:GetService("RunService").Heartbeat:Connect(function()
                    local elapsed = tick() - startTime
                    local progress = math.min(elapsed / duration, 1)
                    
                    gradient.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(progress, 0),
                        NumberSequenceKeypoint.new(progress, 1),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                    
                    if progress >= 1 then
                        connection:Disconnect()
                        button.Active = true
                        gradient:Destroy()
                        
                        if btnConfig.Type == "White" then
                            frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            frame.BackgroundColor3 = Color3.fromRGB(41, 43, 51)
                        end
                    end
                end)
            else
                button.Active = true
                gradient:Destroy()
            end
            
            button.MouseButton1Click:Connect(function()
                if button.Active and not btnConfig.Disabled then screenGui:Destroy()
                    if btnConfig.Callback then
                        btnConfig.Callback()
                    end
                end
            end)
        end
    end

    local alertContentsPadding = Instance.new("UIPadding")
    alertContentsPadding.Name = "AlertContentsPadding"
    alertContentsPadding.PaddingTop = UDim.new(0, 8)
    alertContentsPadding.Parent = alertContents

    screenGui:GetPropertyChangedSignal("Parent"):Connect(function()
        if not screenGui.Parent then
            cleanupTempFolder()
        end
    end)

    screenGui.Enabled = true
    return screenGui
end
