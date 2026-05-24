# ButtonLib Documentation

## Overview
ButtonLib is a UI library for Roblox that allows you to create draggable buttons and toggles with support for multiple elements sharing the same flag name. All UI elements are stored in `CoreGui` and can be accessed globally across scripts.

## Installation
```lua
-- Load the library
local ButtonLib = loadstring(game:HttpGet("https://darahub.pages.dev/Module/Library/GUI/ButtonLib.lua"))()
-- Or paste the entire ButtonLib code
```

## Global Access
The library is available globally through `getgenv().ButtonLib` or simply `ButtonLib` in any script after loading.

## Global Methods

| Method | Description | Example |
|--------|-------------|---------|
| `ButtonLib:OpenButton(bool)` | Shows/hides the floating button | `ButtonLib:OpenButton(true)` |
| `ButtonLib:DestroyScreengui()` | Destroys all UI elements and the screengui | `ButtonLib:DestroyScreengui()` |

## Creating UI Elements

### Create a Button
```lua
local myButton = ButtonLib.Create:Button({
    Text = "Click Me",
    Flag = "MyButton",
    Visible = true,
    Position = UDim2.new(0.5, -125, 0.5, -45),
    ZIndex = 1,
    Callback = function()
        print("Button clicked!")
    end
})
```

### Create a Toggle
```lua
local myToggle = ButtonLib.Create:Toggle({
    Text = "Auto Farm",
    Flag = "MyToggle",
    Default = false,
    Visible = true,
    Position = UDim2.new(0.5, -125, 0.5, -45),
    ZIndex = 1,
    Callback = function(state)
        print("Toggle state:", state)
    end
})
```

## Button Methods

### Common Methods (Both Button and Toggle)

| Method | Description | Example |
|--------|-------------|---------|
| `:Destroy()` | Removes the UI element | `myButton:Destroy()` |
| `:SetVisible(bool)` | Shows/hides the element | `myButton:SetVisible(false)` |
| `:SetZIndex(number)` | Changes ZIndex | `myButton:SetZIndex(10)` |
| `:GetZIndex()` | Returns current ZIndex | `local z = myButton:GetZIndex()` |
| `:GetIndex()` | Returns position in group | `local idx = myButton:GetIndex()` |
| `:GetFlag()` | Returns the flag name | `local flag = myButton:GetFlag()` |

### Button-Specific Methods

| Method | Description | Example |
|--------|-------------|---------|
| `:SetText(string)` | Changes button text | `myButton:SetText("New Text")` |
| `:GetText()` | Returns current text | `local text = myButton:GetText()` |
| `:SetCallback(function)` | Changes the click callback | `myButton:SetCallback(function() print("New callback") end)` |

### Toggle-Specific Methods

| Method | Description | Example |
|--------|-------------|---------|
| `:Set(bool)` | Sets toggle state | `myToggle:Set(true)` |
| `:Get()` | Returns current state | `local state = myToggle:Get()` |
| `:SetText(string)` | Changes display text | `myToggle:SetText("New Label")` |
| `:GetText()` | Returns current text | `local text = myToggle:GetText()` |
| `:SetCallback(function)` | Changes the toggle callback | `myToggle:SetCallback(function(s) print("New state:", s) end)` |

## Working with Multiple Elements (Same Flag)

When you create multiple elements with the same Flag name, they are automatically grouped together.

### Creating Multiple Elements
```lua
local btn1 = ButtonLib.Create:Button({
    Text = "Main Menu",
    Flag = "MenuBtn",
    Callback = function() print("Menu 1") end
})

local btn2 = ButtonLib.Create:Button({
    Text = "Settings",
    Flag = "MenuBtn",
    Callback = function() print("Menu 2") end
})

local toggle1 = ButtonLib.Create:Toggle({
    Text = "Auto Save",
    Flag = "MenuBtn",
    Default = false,
    Callback = function(s) print("Auto save:", s) end
})
```

### Accessing Single Elements
When only one element exists with a flag, you can access it directly:
```lua
ButtonLib.MenuBtn:SetText("New Text")
ButtonLib.MenuBtn:SetVisible(false)
```

### Accessing Grouped Elements (Multiple Elements)

| Method | Description | Example |
|--------|-------------|---------|
| `ButtonLib.FlagName:GetChildren()` | Returns array of all elements | `local all = ButtonLib.MenuBtn:GetChildren()` |
| `ButtonLib.FlagName:GetChild(index)` | Get specific element | `local el = ButtonLib.MenuBtn:GetChild(1)` |
| `ButtonLib.FlagName:GetCount()` | Returns number of elements | `local count = ButtonLib.MenuBtn:GetCount()` |
| `ButtonLib.FlagName:GetChildren()[index]` | Direct array access | `ButtonLib.MenuBtn:GetChildren()[2]:SetVisible(false)` |

### Examples with Grouped Elements

```lua
local menus = ButtonLib.MenuBtn:GetChildren()

for i, element in ipairs(menus) do
    print("Element", i, "text:", element:GetText())
end

ButtonLib.MenuBtn:GetChild(2):SetText("Updated Settings")

local allElements = ButtonLib.MenuBtn:GetChildren()
for i, element in ipairs(allElements) do
    if element.Set then
        element:Set(true)
    end
end

if ButtonLib.MenuBtn:GetCount() > 0 then
    ButtonLib.MenuBtn:GetChild(1):SetVisible(true)
end

local elements = ButtonLib.MenuBtn:GetChildren()
for i, element in ipairs(elements) do
    element:Destroy()
end
```

## Global Access Methods

### Direct Numeric Indexing
Access elements by their order in CoreGui's Darahub:
```lua
local firstElement = ButtonLib[1]
if firstElement then
    firstElement:SetVisible(true)
end

for i = 1, 10 do
    local element = ButtonLib[i]
    if element then
        print("Element", i, "exists")
    else
        break
    end
end
```

### Direct CoreGui Access
```lua
local darahubGui = game:GetService("CoreGui"):FindFirstChild("Darahub")
if darahubGui then
    local allFrames = darahubGui:GetChildren()
    for i, frame in ipairs(allFrames) do
        print("Frame", i, "name:", frame.Name)
        local api = ButtonLib[i]
        if api then
            api:SetVisible(true)
        end
    end
end
```

## Positioning

### Set Position During Creation
```lua
local button = ButtonLib.Create:Button({
    Text = "Click Me",
    Flag = "Test",
    Position = UDim2.new(0.5, -125, 0.5, -45)
})
```

### Change Position After Creation
```lua
button.Position = UDim2.new(0.5, -125, 0.5, -45)
```

### Position Format
`UDim2.new(scaleX, offsetX, scaleY, offsetY)`
- `scaleX` and `scaleY`: 0 to 1 (percentage of screen)
- `offsetX` and `offsetY`: Pixel offset from scale position

Examples:
```lua
Position = UDim2.new(0, 10, 0, 10)
Position = UDim2.new(0.5, -125, 0.5, -45)
Position = UDim2.new(1, -260, 1, -100)
Position = UDim2.new(0.25, 0, 0.75, 0)
```

## Dragging System
All UI elements are draggable by default. Click and drag anywhere on the element to move it.

## Floating Button
The library includes a floating button that can be shown/hidden using:
```lua
ButtonLib:OpenButton(true)   -- Show floating button
ButtonLib:OpenButton(false)  -- Hide floating button
```

## Complete Working Example

```lua
local menuBtn = ButtonLib.Create:Button({
    Text = "Main Menu",
    Flag = "GameUI",
    Position = UDim2.new(0.5, -125, 0.2, 0),
    Callback = function()
        print("Main menu opened")
    end
})

local settingsBtn = ButtonLib.Create:Button({
    Text = "Settings",
    Flag = "GameUI",
    Position = UDim2.new(0.5, -125, 0.35, 0),
    Callback = function()
        print("Settings opened")
    end
})

local autoFarm = ButtonLib.Create:Toggle({
    Text = "Auto Farm",
    Flag = "GameUI",
    Default = false,
    Position = UDim2.new(0.5, -125, 0.5, 0),
    Callback = function(state)
        print("Auto farm is now:", state)
    end
})

menuBtn:SetText("Main Menu v2")
settingsBtn:SetVisible(false)

local allUI = ButtonLib.GameUI:GetChildren()
print("Total UI elements:", #allUI)

autoFarm:Set(true)

task.wait(5)
settingsBtn:SetVisible(true)

local firstElement = ButtonLib[1]
if firstElement then
    print("First element text:", firstElement:GetText())
end

print("GameUI count:", ButtonLib.GameUI:GetCount())

autoFarm:Destroy()
print("Remaining GameUI elements:", ButtonLib.GameUI:GetCount())

ButtonLib:OpenButton(false)
task.wait(2)
ButtonLib:DestroyScreengui()
```
