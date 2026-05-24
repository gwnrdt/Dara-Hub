if getgenv().ButtonLib then return end
local ButtonLib = {}
local CoreGui = game:GetService("CoreGui")
local camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

getgenv().ButtonLib = ButtonLib

local DraggingSystem = {}

function DraggingSystem.GetDistance(pos1, pos2)
    return math.sqrt((pos2.X - pos1.X)^2 + (pos2.Y - pos1.Y)^2)
end

function DraggingSystem.IsMouseOverFrame(Frame, Position)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Position.X >= AbsPos.X
        and Position.X <= AbsPos.X + AbsSize.X
        and Position.Y >= AbsPos.Y
        and Position.Y <= AbsPos.Y + AbsSize.Y
end

function DraggingSystem.GetTopmostButtonAtPosition(Position, excludeFrame)
    local darahubGui = CoreGui:FindFirstChild("Darahub")
    if not darahubGui then return nil end
    
    local topmostButton = nil
    local highestZIndex = -1
    
    for _, child in ipairs(darahubGui:GetChildren()) do
        if child:IsA("Frame") and child.Visible and child ~= excludeFrame then
            if DraggingSystem.IsMouseOverFrame(child, Position) then
                if child.ZIndex > highestZIndex then
                    highestZIndex = child.ZIndex
                    topmostButton = child
                end
            end
        end
    end
    
    return topmostButton, highestZIndex
end

function DraggingSystem.IsClickInput(Input)
    return Input.UserInputState == Enum.UserInputState.Begin
        and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch)
end

function DraggingSystem.IsMoveInput(Input)
    return Input.UserInputState == Enum.UserInputState.Change
        and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
end

function DraggingSystem.MakeDraggable(MainFrame, DragFrame, CallbackTable)
    if not MainFrame or not DragFrame then
        return
    end
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragDistance = 0
    local DRAG_THRESHOLD = 5
    local originalZIndex = MainFrame.ZIndex
    local isDraggingStarted = false
    local currentTouch = nil
    
    local function updatePosition(input)
        if not dragging or not dragStart then return end
        
        local delta = input.Position - dragStart
        dragDistance = math.sqrt(delta.X^2 + delta.Y^2)
        
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        
        if CallbackTable and CallbackTable.OnDragUpdate then
            CallbackTable.OnDragUpdate(MainFrame.Position, dragDistance)
        end
    end
    
    local function resetDragState()
        dragging = false
        dragStart = nil
        startPos = nil
        dragDistance = 0
        isDraggingStarted = false
        currentTouch = nil
    end
    
    local mouseButton1Connection = nil
    local touchEndedConnection = nil
    local movementConnection = nil
    
    local function onInputEnded()
        if dragging then
            local wasDragged = dragDistance > DRAG_THRESHOLD
            
            if not wasDragged and CallbackTable and CallbackTable.OnClick then
                CallbackTable.OnClick()
            end
            
            if wasDragged and isDraggingStarted then
                MainFrame.ZIndex = originalZIndex
                if CallbackTable and CallbackTable.OnDragEnd then
                    CallbackTable.OnDragEnd(MainFrame.Position, wasDragged)
                end
            end
            
            resetDragState()
            
            if mouseButton1Connection then
                mouseButton1Connection:Disconnect()
                mouseButton1Connection = nil
            end
            
            if touchEndedConnection then
                touchEndedConnection:Disconnect()
                touchEndedConnection = nil
            end
            
            if movementConnection then
                movementConnection:Disconnect()
                movementConnection = nil
            end
        end
    end
    
    local function onInputEndedHandler(endInput)
        if dragging then
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                onInputEnded()
            elseif endInput.UserInputType == Enum.UserInputType.Touch and endInput == currentTouch then
                onInputEnded()
            end
        end
    end
    
    local function onMovement(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == currentTouch) then
            if not isDraggingStarted and dragDistance > DRAG_THRESHOLD then
                isDraggingStarted = true
                
                local maxZIndex = 0
                local darahubGui = CoreGui:FindFirstChild("Darahub")
                if darahubGui then
                    for _, child in ipairs(darahubGui:GetChildren()) do
                        if child:IsA("Frame") and child ~= MainFrame and child.Visible then
                            if child.ZIndex > maxZIndex then
                                maxZIndex = child.ZIndex
                            end
                        end
                    end
                end
                
                MainFrame.ZIndex = maxZIndex + 1
                originalZIndex = MainFrame.ZIndex
                
                if CallbackTable and CallbackTable.OnDragStart then
                    CallbackTable.OnDragStart()
                end
            end
            
            updatePosition(input)
        end
    end
    
    local function onInputBegan(input)
        if DraggingSystem.IsClickInput(input) and not dragging then
            if DraggingSystem.IsMouseOverFrame(DragFrame, input.Position) then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                dragDistance = 0
                isDraggingStarted = false
                
                if input.UserInputType == Enum.UserInputType.Touch then
                    currentTouch = input
                else
                    currentTouch = nil
                end
                
                local maxZIndex = 0
                local darahubGui = CoreGui:FindFirstChild("Darahub")
                if darahubGui then
                    for _, child in ipairs(darahubGui:GetChildren()) do
                        if child:IsA("Frame") and child ~= MainFrame and child.Visible then
                            if child.ZIndex > maxZIndex then
                                maxZIndex = child.ZIndex
                            end
                        end
                    end
                end
                
                MainFrame.ZIndex = maxZIndex + 1
                originalZIndex = MainFrame.ZIndex
                
                mouseButton1Connection = UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                        onInputEndedHandler(endInput)
                    end
                end)
                
                touchEndedConnection = UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.Touch then
                        onInputEndedHandler(endInput)
                    end
                end)
                
                movementConnection = UserInputService.InputChanged:Connect(function(moveInput)
                    if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                        onMovement(moveInput)
                    end
                end)
            end
        end
    end
    
    local inputBeganConnection = DragFrame.InputBegan:Connect(onInputBegan)
    
    local cleanupFunction = function()
        inputBeganConnection:Disconnect()
        if mouseButton1Connection then
            mouseButton1Connection:Disconnect()
        end
        if touchEndedConnection then
            touchEndedConnection:Disconnect()
        end
        if movementConnection then
            movementConnection:Disconnect()
        end
    end
    
    return cleanupFunction
end

function getDPIScale()
    return camera.ViewportSize.Y / 1080
end

local floatingButtonInstance = nil

function ButtonLib:OpenButton(visible)
    if not UserInputService.KeyboardEnabled then
        local darahubGui = CoreGui:FindFirstChild("Darahub")
        if darahubGui then
            local floatingButton = darahubGui:FindFirstChild("FloatingButton_Darahub")
            if floatingButton then
                floatingButton.Visible = visible
                floatingButtonInstance = floatingButton
            end
        end
    end
end

function ButtonLib:DestroyScreengui()
    local darahubGui = CoreGui:FindFirstChild("Darahub")
    if darahubGui then
        for _, element in pairs(ButtonLib._elements or {}) do
            if type(element) == "table" then
                for _, elementData in ipairs(element) do
                    if elementData and elementData.api and elementData.api.Destroy then
                        pcall(function() elementData.api:Destroy() end)
                    end
                end
            end
        end
        ButtonLib._elements = {}
        ButtonLib._counters = {}
        darahubGui:Destroy()
    end
end

if not UserInputService.KeyboardEnabled then
    local darahubGui = CoreGui:FindFirstChild("Darahub") or Instance.new("ScreenGui", CoreGui)
    darahubGui.Name = "Darahub"
    darahubGui.DisplayOrder = 78
    darahubGui.IgnoreGuiInset = true
    darahubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local floatingButton = Instance.new("ImageButton")
    floatingButton.Name = "FloatingButton_Darahub"
    floatingButton.Parent = darahubGui
    floatingButton.Active = true
    floatingButton.BorderSizePixel = 0
    floatingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    floatingButton.Size = UDim2.new(0, 80, 0, 80)
    floatingButton.Position = UDim2.new(0.85, 0, 0.05, 0)
    floatingButton.BackgroundTransparency = 1
    floatingButton.Image = "rbxassetid://137330250139083"
    floatingButton.Visible = false
    floatingButtonInstance = floatingButton
    
    local aspectRatio = Instance.new("UIAspectRatioConstraint", floatingButton)
    aspectRatio.DominantAxis = Enum.DominantAxis.Height
    
    local sizeConstraint = Instance.new("UISizeConstraint", floatingButton)
    sizeConstraint.MinSize = Vector2.new(68, 68)
    sizeConstraint.MaxSize = Vector2.new(100, 100)
    
    local corner = Instance.new("UICorner", floatingButton)
    corner.CornerRadius = UDim.new(1, 0)
    
    local uiScale = Instance.new("UIScale", floatingButton)
    uiScale.Scale = getDPIScale()
    
    local dragData = {
        dragging = false,
        dragStart = nil,
        startPos = nil,
        dragDistance = 0,
        isDragging = false,
        currentTouch = nil
    }
    
    function updateFloatingPosition(input)
        if not dragData.dragging or not dragData.dragStart then return end
        
        local delta = input.Position - dragData.dragStart
        dragData.dragDistance = math.sqrt(delta.X^2 + delta.Y^2)
        
        floatingButton.Position = UDim2.new(
            dragData.startPos.X.Scale, 
            dragData.startPos.X.Offset + delta.X,
            dragData.startPos.Y.Scale, 
            dragData.startPos.Y.Offset + delta.Y
        )
    end
    
    function resetFloatingDrag()
        dragData.dragging = false
        dragData.dragStart = nil
        dragData.startPos = nil
        dragData.dragDistance = 0
        dragData.isDragging = false
        dragData.currentTouch = nil
    end
    
    local mouseConnection = nil
    local touchConnection = nil
    local moveConnection = nil
    
    function onFloatingInputEnded(endInput)
        if dragData.dragging then
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                local wasDragged = dragData.dragDistance > 5
                if not wasDragged then
                    if Window and Window.Open then
                        Window:Open()
                    end
                end
                resetFloatingDrag()
                
                if mouseConnection then
                    mouseConnection:Disconnect()
                    mouseConnection = nil
                end
                if moveConnection then
                    moveConnection:Disconnect()
                    moveConnection = nil
                end
            elseif endInput.UserInputType == Enum.UserInputType.Touch and endInput == dragData.currentTouch then
                local wasDragged = dragData.dragDistance > 5
                if not wasDragged then
                    if Window and Window.Open then
                        Window:Open()
                    end
                end
                resetFloatingDrag()
                
                if touchConnection then
                    touchConnection:Disconnect()
                    touchConnection = nil
                end
                if moveConnection then
                    moveConnection:Disconnect()
                    moveConnection = nil
                end
            end
        end
    end
    
    function onFloatingMovement(input)
        if dragData.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == dragData.currentTouch) then
            if not dragData.isDragging and dragData.dragDistance > 5 then
                dragData.isDragging = true
            end
            updateFloatingPosition(input)
        end
    end
    
    function onFloatingInputBegan(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and input.UserInputState == Enum.UserInputState.Begin then
            if DraggingSystem.IsMouseOverFrame(floatingButton, input.Position) then
                dragData.dragging = true
                dragData.dragStart = input.Position
                dragData.startPos = floatingButton.Position
                dragData.dragDistance = 0
                dragData.isDragging = false
                
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragData.currentTouch = input
                else
                    dragData.currentTouch = nil
                end
                
                if mouseConnection then
                    mouseConnection:Disconnect()
                end
                if touchConnection then
                    touchConnection:Disconnect()
                end
                if moveConnection then
                    moveConnection:Disconnect()
                end
                
                mouseConnection = UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                        onFloatingInputEnded(endInput)
                    end
                end)
                
                touchConnection = UserInputService.InputEnded:Connect(function(endInput)
                    if endInput.UserInputType == Enum.UserInputType.Touch then
                        onFloatingInputEnded(endInput)
                    end
                end)
                
                moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
                    if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                        onFloatingMovement(moveInput)
                    end
                end)
            end
        end
    end
    
    floatingButton.InputBegan:Connect(onFloatingInputBegan)
end

ButtonLib.Create = {}

ButtonLib._elements = {}
ButtonLib._counters = {}

function buildBaseFrame(config)
    local darahubGui = CoreGui:FindFirstChild("Darahub") or Instance.new("ScreenGui", CoreGui)
    darahubGui.Name = "Darahub"
    darahubGui.IgnoreGuiInset = true
    darahubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    local flag = config.Flag or config.Text or "Element"
    
    frame.Name = flag
    frame.Parent = darahubGui
    frame.Visible = config.Visible ~= false
    frame.Active = true
    frame.Size = UDim2.new(0, 250, 0, 90)
    frame.Position = config.Position or UDim2.new(0.5, -125, 0.5, -45)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BackgroundTransparency = 0.2
    frame.ZIndex = config.ZIndex or 1
    
    local elementData = {
        instance = frame,
        flag = flag,
        index = nil,
        api = nil,
        type = config.Type or "Button"
    }
    
    if not ButtonLib._elements[flag] then
        ButtonLib._elements[flag] = {}
    end
    
    elementData.index = #ButtonLib._elements[flag] + 1
    table.insert(ButtonLib._elements[flag], elementData)
    
    local uiScale = Instance.new("UIScale", frame)
    uiScale.Scale = getDPIScale()
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)
    
    local strokeB = Instance.new("UIStroke", frame)
    strokeB.Thickness = 2
    strokeB.Color = Color3.new(0, 0, 0)
    strokeB.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local strokeW = Instance.new("UIStroke", frame)
    strokeW.Thickness = 1
    strokeW.Color = Color3.new(1, 1, 1)
    strokeW.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local grad = Instance.new("UIGradient", frame)
    grad.Rotation = 90
    grad.Color = ColorSequence.new(Color3.fromRGB(47, 47, 47), Color3.new(0, 0, 0))
    
    local textButton = Instance.new("TextButton", frame)
    textButton.Name = "Button"
    textButton.Size = UDim2.new(1, 0, 1, 0)
    textButton.Position = UDim2.new(0, 0, 0, 0)
    textButton.BackgroundTransparency = 1
    textButton.Text = ""
    textButton.AutoButtonColor = false
    textButton.ZIndex = 10
    
    local label = Instance.new("TextLabel", frame)
    label.Name = "Label"
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.FredokaOne
    label.ZIndex = 5
    label.Text = config.Text or "Button"
    
    local api = {}
    
    function api:Destroy()
        if ButtonLib._elements[flag] then
            for i, data in ipairs(ButtonLib._elements[flag]) do
                if data.instance == frame then
                    table.remove(ButtonLib._elements[flag], i)
                    for j = i, #ButtonLib._elements[flag] do
                        ButtonLib._elements[flag][j].index = j
                    end
                    break
                end
            end
            if #ButtonLib._elements[flag] == 0 then
                ButtonLib._elements[flag] = nil
            end
        end
        frame:Destroy()
        if getgenv().ButtonLib[flag] == api then
            getgenv().ButtonLib[flag] = nil
        end
    end
    
    function api:SetVisible(visible)
        frame.Visible = visible
    end
    
    function api:SetDraggable(enabled)
        warn("SetDraggable not implemented with custom dragging system")
    end
    
    function api:SetZIndex(zIndex)
        frame.ZIndex = zIndex
    end
    
    function api:GetZIndex()
        return frame.ZIndex
    end
    
    function api:GetIndex()
        return elementData.index
    end
    
    function api:GetFlag()
        return flag
    end
    
    function api:SetText(newText)
        label.Text = newText
    end
    
    function api:GetText()
        return label.Text
    end
    
    elementData.api = api
    
    return api, frame, textButton, label, flag
end

local ButtonLibMetatable = {
    __index = function(t, key)
        if type(key) == "number" then
            local darahubGui = CoreGui:FindFirstChild("Darahub")
            if darahubGui then
                local children = darahubGui:GetChildren()
                if key >= 1 and key <= #children then
                    local child = children[key]
                    for flag, elements in pairs(ButtonLib._elements) do
                        for _, elementData in ipairs(elements) do
                            if elementData.instance == child then
                                return elementData.api
                            end
                        end
                    end
                end
            end
            return nil
        end
        
        if key == "OpenButton" or key == "DestroyScreengui" then
            return function(self, ...)
                return ButtonLib[key](self, ...)
            end
        end
        
        if ButtonLib._elements[key] then
            if #ButtonLib._elements[key] == 1 then
                return ButtonLib._elements[key][1].api
            else
                local flagTable = {}
                local flagMetatable = {
                    __index = function(ft, idx)
                        if type(idx) == "number" then
                            local elements = ButtonLib._elements[key]
                            if elements and idx >= 1 and idx <= #elements then
                                return elements[idx].api
                            end
                        elseif type(idx) == "string" then
                            if idx == "GetChildren" then
                                return function(self)
                                    local elements = ButtonLib._elements[key]
                                    local children = {}
                                    if elements then
                                        for i, elementData in ipairs(elements) do
                                            children[i] = elementData.api
                                        end
                                    end
                                    return children
                                end
                            elseif idx == "GetCount" then
                                return function(self)
                                    local elements = ButtonLib._elements[key]
                                    return elements and #elements or 0
                                end
                            elseif idx == "GetChild" then
                                return function(self, index)
                                    local elements = ButtonLib._elements[key]
                                    if elements and index >= 1 and index <= #elements then
                                        return elements[index].api
                                    end
                                    return nil
                                end
                            end
                        end
                        return nil
                    end,
                    __newindex = function(ft, idx, value)
                        local elements = ButtonLib._elements[key]
                        if elements and #elements > 0 then
                            local api = elements[1].api
                            if api and api[idx] then
                                api[idx] = value
                            end
                        end
                    end
                }
                setmetatable(flagTable, flagMetatable)
                
                function flagTable:GetChildren()
                    local elements = ButtonLib._elements[key]
                    local children = {}
                    if elements then
                        for i, elementData in ipairs(elements) do
                            children[i] = elementData.api
                        end
                    end
                    return children
                end
                
                function flagTable:GetChild(index)
                    local elements = ButtonLib._elements[key]
                    if elements and index >= 1 and index <= #elements then
                        return elements[index].api
                    end
                    return nil
                end
                
                function flagTable:GetCount()
                    local elements = ButtonLib._elements[key]
                    return elements and #elements or 0
                end
                
                return flagTable
            end
        end
        
        return nil
    end,
    __newindex = function(t, key, value)
        rawset(t, key, value)
    end
}

setmetatable(getgenv().ButtonLib, ButtonLibMetatable)

function ButtonLib.Create:Button(config)
    config.Type = "Button"
    local api, frame, textButton, label, flag = buildBaseFrame(config)
    local callback = config.Callback or config[1] or function() end
    
    local originalOnClick = callback
    
    function api:SetCallback(newCallback)
        originalOnClick = newCallback
    end
    
    DraggingSystem.MakeDraggable(frame, textButton, {
        OnClick = function()
            pcall(originalOnClick)
        end
    })
    
    getgenv().ButtonLib[flag] = api
    
    return api
end

function ButtonLib.Create:Toggle(config)
    config.Type = "Toggle"
    local api, frame, textButton, label, flag = buildBaseFrame(config)
    local callback = config.Callback or config[1] or function() end
    local baseText = config.Text or "Toggle"
    local state = config.Default or config.Deafult or false
    
    local function updateUI()
        if state then
            label.Text = baseText .. " : ON"
        else
            label.Text = baseText .. " : OFF"
        end
    end
    
    updateUI()
    
    function api:Set(val)
        state = val
        updateUI()
        pcall(callback, state)
    end
    
    function api:Get()
        return state
    end
    
    function api:SetText(newText)
        baseText = newText
        updateUI()
    end
    
    function api:GetText()
        return baseText
    end
    
    function api:SetCallback(newCallback)
        callback = newCallback
    end
    
    DraggingSystem.MakeDraggable(frame, textButton, {
        OnClick = function()
            api:Set(not state)
        end
    })
    
    getgenv().ButtonLib[flag] = api
    
    return api
end

return ButtonLib
