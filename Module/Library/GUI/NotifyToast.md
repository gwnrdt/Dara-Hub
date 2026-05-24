# NotifyToast Documentation

## Installation

Load the module using `loadstring`:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/gwnrdt/Dara-Hub/refs/heads/main/Module/Library/GUI/NotifyToast.lua"))()
```

After loading, the function is available globally via `getgenv().NotifyToast`.

## Overview

NotifyToast is a remake of Roblox's default Toast Notification library with extensive customization options. It creates modern, animated toast notifications that slide in from the top of the screen and can be dismissed by clicking, swiping up, or after a set duration.

## Basic Syntax

```lua
getgenv().NotifyToast(configurationTable)
```

## Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `string` | `""` | Main title text. Supports HTML-like color tags: `<font color='#FF0000'>text</font>` |
| `content` / `subtitle` | `string` | `""` | Secondary message text. Also supports HTML color tags and bold formatting. |
| `duration` | `number` | `2` | How many seconds the toast stays visible before auto-dismissing. |
| `callback` | `function` | `nil` | Function called when the toast is clicked or tapped. |
| `icon` | `string/number` | `nil` | Icon to display. Can be: BuilderIcons name, rbxassetid, rbxassetid string, or URL |
| `iconColor` | `string/Color3` | `nil` | Color of the icon. Accepts hex string (e.g., `"#FF0000"`) or Color3 object. |
| `iconRadius` / `iconCornerRadius` | `number/boolean` | `0` | Corner radius for the icon. `0` = square, `18+` or `true` = circle, number = custom radius |

## Icon Types

### 1. BuilderIcons Name (Text Icon)
```lua
icon = "triangle-exclamation"
icon = "shield-x"
icon = "check-circle"
```

### 2. Roblox Asset ID (Number)
```lua
icon = 1234567890
```

### 3. Roblox Asset ID (String)
```lua
icon = "rbxassetid://1234567890"
icon = "rbxasset://path/to/asset.png"
```

### 4. Image URL (Auto-downloads)
```lua
icon = "https://i.imgur.com/example.png"
```

## Features

### HTML Formatting
Both `title` and `content` support HTML-like formatting:
- `<font color='#FF0000'>Red text</font>`
- `<b>Bold text</b>`
- Combine formats: `<font color='#00FF00'><b>Bold green text</b></font>`

### Auto-Dismiss
Toast automatically disappears after `duration` seconds.

### Interactions
- **Click/Tap**: Triggers callback and dismisses toast
- **Swipe Up**: Dismisses toast (touch devices)
- **Click and Hold**: Shows visual scale-down effect

### Queue System
When `CONFIG.REMOVE_PREVIOUS = true` (default), new toasts automatically remove any existing toast.

## Examples

### Example 1: Simple Toast
```lua
getgenv().NotifyToast({
    title = "Hello!",
    content = "This is a toast notification"
})
```

### Example 2: Toast with Callback
```lua
getgenv().NotifyToast({
    title = "Click Me!",
    content = "Tap to perform an action",
    duration = 5,
    callback = function()
        print("Toast was clicked!")
        -- Perform action here
    end
})
```

### Example 3: Colored Text with HTML
```lua
getgenv().NotifyToast({
    title = "<font color='#FF5555'>WARNING!</font>",
    content = "Do not use on <b>public servers</b>"
})
```

### Example 4: Circle Icon with Color
```lua
getgenv().NotifyToast({
    title = "<font color='#FF5555'>BAN WAVE</font>",
    content = "Do not use on public servers",
    icon = "shield-x",
    iconColor = "#FF0000",
    iconRadius = true,
    duration = 8
})
```

### Example 5: Custom Image Icon from URL
```lua
getgenv().NotifyToast({
    title = "Custom Image",
    content = "Icon loaded from web",
    icon = "https://i.imgur.com/yourimage.png",
    iconRadius = 18
})
```

### Example 6: Roblox Asset Icon
```lua
getgenv().NotifyToast({
    title = "Achievement Unlocked!",
    content = "You've earned a badge",
    icon = "rbxassetid://1234567890",
    iconRadius = true
})
```

### Example 7: Colored BuilderIcon
```lua
getgenv().NotifyToast({
    title = "Success!",
    content = "Operation completed successfully",
    icon = "check-circle",
    iconColor = "#00FF00",
    iconRadius = true,
    duration = 3
})
```

### Example 8: Long Duration Warning
```lua
getgenv().NotifyToast({
    title = "<font color='#FF5555'>⚠️ MAINTENANCE ⚠️</font>",
    content = "Server will restart in 30 seconds",
    icon = "triangle-exclamation",
    iconColor = "#FFA500",
    iconRadius = true,
    duration = 10,
    callback = function()
        print("User acknowledged maintenance warning")
    end
})
```

### Example 9: No Icon, Multi-line Content
```lua
getgenv().NotifyToast({
    title = "Update Available",
    content = "Version 2.0 is ready to install.\n<font color='#888888'>Tap to download</font>",
    duration = 5
})
```

### Example 10: Color3 Icon Color
```lua
getgenv().NotifyToast({
    title = "Custom Color",
    content = "Using Color3 object",
    icon = "star",
    iconColor = Color3.fromRGB(255, 215, 0), -- Gold color
    iconRadius = 12
})
```

## Configuration Constants

The library includes configurable constants at the top:

| Constant | Value | Description |
|----------|-------|-------------|
| `SLIDE_IN_TIME` | 0.4 | Slide-in animation duration (seconds) |
| `SLIDE_OUT_TIME` | 0.05 | Slide-out animation duration |
| `SCALE_TIME` | 0.11 | Scale animation duration on click |
| `SCALE_DOWN` | 0.96 | Scale factor when clicking |
| `SHOW_Y` | 59 | Final Y position from top (pixels) |
| `DEFAULT_DURATION` | 2 | Default display time (seconds) |
| `TOAST_HEIGHT` | 77 | Height for toasts with both title and content |
| `SMALL_HEIGHT` | 55 | Height for toasts with only title |
| `SWIPE_THRESHOLD` | 40 | Minimum swipe distance to dismiss (pixels) |
| `REMOVE_PREVIOUS` | true | Whether to remove existing toasts |

## Notes

- Toast appears at the top center of the screen
- Maximum width is 400px, minimum is 24px
- Icon radius is automatically set to circle when value is `true` or `>= 18`
- URL images are automatically downloaded and cached as custom assets
- Supports both PC (mouse) and mobile (touch) interactions
- Toasts are created in `CoreGui` with DisplayOrder 9
- The function checks if it already exists globally to prevent duplicate loading

## Return Value

The function does not return a value but creates and manages the toast GUI automatically.
