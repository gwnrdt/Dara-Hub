## RblxCallDialog Documentation

### Installation

Load the module from the provided URL using `loadstring`:

```lua
local RblxCallDialog = loadstring(game:HttpGet("https://darahub.pages.dev/Module/Library/GUI/CallDialogScreen.lua"))()
```

After loading, the function is also available globally via `getgenv().RblxCallDialog`.

### Overview

`RblxCallDialog` is a function that creates modern, customizable dialog popups. It's perfect for confirmations, alerts, forms with checkboxes, or any important message that requires user interaction. The dialog features a sleek design, support for one or two action buttons, an optional checkbox, customizable icons, and a "hold to confirm" cooldown effect on buttons.

### Basic Syntax

```lua
RblxCallDialog(configurationTable)
```

### Configuration Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | `string` | **Required** | The title text displayed at the top of the dialog. |
| `Desc` or `Description` | `string` | **Required** | The main descriptive message of the dialog. |
| `Icon` | `string` | `nil` | Icon to display in the title area. Supports BuilderIcons text names, rbxassetid:// URLs, or https:// URLs. |
| `IconSize` | `number` or `UDim2` | `30` | Size of the icon. Use a number for square dimensions, or `UDim2.fromOffset(width, height)` for custom dimensions. |
| `IconOrder` | `string` | `"Bottom"` | Position of the icon relative to the title. Options: `"Top"` or `"Bottom"`. |
| `TitleTextSize` | `number` | `25` | Font size for the title text. |
| `TitleTextScaled` | `boolean` | `false` | If `true`, title text will scale to fit its container. |
| `DescTextSize` | `number` | `20` | Font size for the description text. |
| `DescTextScaled` | `boolean` | `false` | If `true`, description text will scale to fit its container. |
| `CheckBoxEnabled` | `boolean` | `false` | If `true`, a checkbox section will be displayed. |
| `Checkbox` | `table` | `nil` | **Required if `CheckBoxEnabled` is `true`.** Configures the checkbox. |
| `Button1` | `table` | `nil` | Configuration for the first (or primary) action button. |
| `Button2` | `table` | `nil` | Configuration for a second action button. |

#### Checkbox Configuration Table

Used when `CheckBoxEnabled = true`.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Checkbox.Text` | `string` | **Required** | The label text next to the checkbox. |
| `Checkbox.TextSize` | `number` | `16` | Font size for the checkbox text. |
| `Checkbox.TextScaled` | `boolean` | `false` | If `true`, checkbox text will scale to fit its container. |
| `Checkbox.InitialChecked` | `boolean` | `false` | The starting state of the checkbox. |
| `Checkbox.Disabled` | `boolean` | `false` | If `true`, the checkbox is grayed out and cannot be toggled. |
| `Checkbox.Callback` | `function` | `nil` | A function that fires when the checkbox is toggled. Receives the new `checked` state (`true`/`false`). |

#### Button Configuration Table

Used for `Button1` and `Button2`.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Button.Title` | `string` | **Required** | The text displayed on the button. |
| `Button.TextSize` | `number` | `20` | Font size for the button text. |
| `Button.TextScaled` | `boolean` | `false` | If `true`, button text will scale to fit its container. |
| `Button.Type` | `string` | `nil` | The style of the button. Options: `"White"`, `"GreyOutline"`, or `nil` (for the default dark button). |
| `Button.WaitTimeClick` | `number` | `nil` | If set (in seconds), the button will have a cooldown period before its action can be triggered, visualized by a progress bar. |
| `Button.Disabled` | `boolean` | `false` | If `true`, the button is visible but non-interactable. |
| `Button.Callback` | `function` | `nil` | The function that executes when the button is successfully clicked (or after its cooldown). |

### Function Return Value

The function returns the `ScreenGui` object it creates. This allows for manual cleanup if needed (e.g., `dialogGui:Destroy()`).

### Dialog Layout & Behavior

- **Auto-Sizing**: All dialog elements automatically size to fit their content, ensuring nothing gets cut off.
- **Buttons**: If two buttons are provided (`Button1` and `Button2`), they share the dialog's width. If only one button is provided, it stretches to be wider. If no buttons are provided, a default gray "Close" button is added.
- **Cooldown (`WaitTimeClick`)**: When set, the button visually indicates a countdown. The button is inactive until the cooldown finishes, then the `Callback` will fire on the final click.
- **Dismissal**: The dialog automatically destroys itself when any button (including the default "Close" button) is clicked or when its cooldown action is completed.
- **Icons**: Supports three types of icons:
  - **BuilderIcons text**: Use icon names like `"speech-bubble-align-center"`, `"clock"`, etc.
  - **rbxassetid URLs**: Use Roblox asset IDs like `"rbxassetid://137330250139083"`
  - **HTTP/HTTPS URLs**: Downloads and displays images from the web (automatically cached and cleaned up)
- **Icon Positioning**: Icons can appear above (`"Top"`) or below (`"Bottom"`) the title text, centered horizontally.

### Examples

#### 1. Simple Confirmation Dialog (One Button, with Cooldown)

```lua
RblxCallDialog({
    Title = "Delete File",
    Desc = "Are you sure you want to delete this file? This action cannot be undone.",
    Button1 = {
        Title = "Delete",
        Type = "White",
        WaitTimeClick = 3, -- User must hold/acknowledge for 3 seconds
        Callback = function()
            print("File deleted!")
            -- Perform deletion logic here
        end
    }
})
```

#### 2. Dialog with a Checkbox and Two Buttons

```lua
RblxCallDialog({
    Title = "Save Changes",
    Desc = "You have unsaved changes. Would you like to save them before closing?",
    CheckBoxEnabled = true,
    Checkbox = {
        Text = "Don't ask me again",
        InitialChecked = false,
        Callback = function(checked)
            print("'Don't ask again' is now:", checked)
        end
    },
    Button1 = {
        Title = "Cancel",
        Type = "GreyOutline",
        Callback = function()
            print("Cancelled, no changes saved.")
        end
    },
    Button2 = {
        Title = "Save",
        Type = "White",
        Callback = function()
            print("Changes saved!")
            -- Perform save logic here
        end
    }
})
```

#### 3. Dialog with BuilderIcons Icon

```lua
RblxCallDialog({
    Title = "Notification",
    Icon = "speech-bubble-align-center",
    IconSize = 35,
    IconOrder = "Top",
    Desc = "You have a new message from the server administrator."
})
```

#### 4. Dialog with Custom Image Icon

```lua
RblxCallDialog({
    Title = "Warning",
    Icon = "rbxassetid://137330250139083",
    IconSize = UDim2.fromOffset(60, 40),
    IconOrder = "Bottom",
    Desc = "This action requires administrator privileges."
})
```

#### 5. Dialog with Web Image Icon

```lua
RblxCallDialog({
    Title = "Update Available",
    Icon = "https://placehold.co/600x400/000000/FFFFFF/png",
    IconSize = 40,
    Desc = "A new version of the application is available. Would you like to update now?",
    Button1 = {
        Title = "Later",
        Type = "GreyOutline",
        Callback = function()
            print("Update postponed.")
        end
    },
    Button2 = {
        Title = "Update",
        Type = "White",
        Callback = function()
            print("Starting update...")
        end
    }
})
```

#### 6. Dialog with Custom Text Sizes

```lua
RblxCallDialog({
    Title = "Large Title",
    TitleTextSize = 30,
    TitleTextScaled = true,
    Desc = "This description uses a smaller font size",
    DescTextSize = 16,
    CheckBoxEnabled = true,
    Checkbox = {
        Text = "Small checkbox text",
        TextSize = 14,
        InitialChecked = true
    },
    Button1 = {
        Title = "Custom Button Text",
        TextSize = 18,
        Type = "White",
        Callback = function()
            print("Button clicked!")
        end
    }
})
```

#### 7. Informational Dialog (No Buttons - Shows "Close" Button)

```lua
RblxCallDialog({
    Title = "Information",
    Desc = "Your settings have been updated successfully."
})
```

#### 8. Warning Dialog with a Cooldown Button

```lua
RblxCallDialog({
    Title = "⚠️ Warning ⚠️",
    Desc = "You are about to purchase a very expensive item. Do you wish to proceed?",
    Button1 = {
        Title = "Cancel",
        Type = "GreyOutline",
        Callback = function()
            print("Purchase cancelled.")
        end
    },
    Button2 = {
        Title = "Purchase",
        Type = "White",
        WaitTimeClick = 5, -- Long cooldown for a critical action
        Callback = function()
            print("Purchase completed!")
            -- Complete purchase logic
        end
    }
})
```

### Notes

- The dialog is created as a child of `CoreGui`, ensuring it appears above most in-game UI.
- Dialog elements are styled to have a dark theme with rounded corners and subtle highlights.
- When using HTTP/HTTPS icons, images are temporarily stored in `.temp/img/` and automatically cleaned up when the dialog is destroyed.
- The title is always centered horizontally in the dialog.
- All text elements support `TextScaled` for responsive text sizing.
