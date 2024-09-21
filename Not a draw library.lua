local ImGui = {}

local windows = {}
local drawLists = {}

function ImGui.Begin(windowName)
    if not windows[windowName] then
        local scrngui = Instance.new("ScreenGui")
        scrngui.Parent = game.Players.LocalPlayer.:WaitForChild("PlayerGui")
        local window = Instance.new("Frame")
        window.Name = windowName
        window.Size = UDim2.new(0, 300, 0, 300)
        window.Position = UDim2.new(0, 100, 0, 100)
        window.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        window.Parent = game.Players.LocalPlayer.:WaitForChild("PlayerGui").ScreenGui

        windows[windowName] = {
            frame = window,
            children = {}
        }
    end
    return windows[windowName]
end
function ImGui.End()
end

function ImGui.Button(windowName, buttonText, onClick)
    local parentWindow = windows[windowName]
    if parentWindow then
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 50)
        button.Position = UDim2.new(0, 10, 0, 50 * #parentWindow.children + 10)
        button.Text = buttonText
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        button.Parent = parentWindow.frame

        table.insert(parentWindow.children, button)

        button.MouseButton1Click:Connect(onClick)
    end
end
function ImGui.CheckBox(windowName, labelText, value, onChange)
    local parentWindow = windows[windowName]
    if parentWindow then
        local checkBoxFrame = Instance.new("Frame")
        checkBoxFrame.Size = UDim2.new(0, 100, 0, 50)
        checkBoxFrame.Position = UDim2.new(0, 10, 0, 50 * #parentWindow.children + 10)
        checkBoxFrame.BackgroundTransparency = 1
        checkBoxFrame.Parent = parentWindow.frame

        local checkBox = Instance.new("TextButton")
        checkBox.Size = UDim2.new(0, 30, 0, 30)
        checkBox.Position = UDim2.new(0, 0, 0, 0)
        checkBox.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        checkBox.Parent = checkBoxFrame

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 60, 0, 30)
        label.Position = UDim2.new(0, 35, 0, 0)
        label.Text = labelText
        label.BackgroundTransparency = 1
        label.Parent = checkBoxFrame

        table.insert(parentWindow.children, checkBoxFrame)

        checkBox.MouseButton1Click:Connect(function()
            value = not value
            checkBox.BackgroundColor3 = value and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            if onChange then
                onChange(value)
            end
        end)
    end
end

function ImGui.TextBox(windowName, defaultText, onTextChange)
    local parentWindow = windows[windowName]
    if parentWindow then
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0, 200, 0, 50)
        textBox.Position = UDim2.new(0, 10, 0, 50 * #parentWindow.children + 10)
        textBox.Text = defaultText
        textBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        textBox.Parent = parentWindow.frame

        table.insert(parentWindow.children, textBox)

        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and onTextChange then
                onTextChange(textBox.Text)
            end
        end)
    end
end

function ImGui.Slider(windowName, labelText, min, max, currentValue, onValueChange)
    local parentWindow = windows[windowName]
    if parentWindow then
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0, 200, 0, 50)
        sliderFrame.Position = UDim2.new(0, 10, 0, 50 * #parentWindow.children + 10)
        sliderFrame.BackgroundTransparency = 1
        sliderFrame.Parent = parentWindow.frame

        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(0, 50, 0, 30)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.Text = labelText
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Parent = sliderFrame

        local slider = Instance.new("TextButton")
        slider.Size = UDim2.new(0, 100, 0, 30)
        slider.Position = UDim2.new(0, 60, 0, 0)
        slider.Text = tostring(currentValue)
        slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        slider.Parent = sliderFrame

        table.insert(parentWindow.children, sliderFrame)

        slider.MouseButton1Click:Connect(function()
            currentValue = math.clamp(currentValue + 1, min, max)
            slider.Text = tostring(currentValue)
            if onValueChange then
                onValueChange(currentValue)
            end
        end)
    end
end
function ImGui.AddRectWithCorners(drawList, position, size, color, cornerRadius)
    local rect = Instance.new("Frame")
    rect.Size = UDim2.new(0, size.X, 0, size.Y)
    rect.Position = UDim2.new(0, position.X, 0, position.Y)
    rect.BackgroundColor3 = color
    rect.Parent = drawList

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = rect
end
function ImGui.AddText(drawList, text, position, size, font, shadowEnabled, outlineEnabled, textColor, shadowColor, outlineColor)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, size.X, 0, size.Y)
    label.Position = UDim2.new(0, position.X, 0, position.Y)
    label.Text = text
    label.TextColor3 = textColor
    label.Font = font
    label.TextSize = size.Y
    label.BackgroundTransparency = 1
    label.Parent = drawList
    if shadowEnabled then
        local shadow = Instance.new("TextLabel")
        shadow.Size = label.Size
        shadow.Position = label.Position + UDim2.new(0, 2, 0, 2)
        shadow.Text = text
        shadow.TextColor3 = shadowColor
        shadow.Font = font
        shadow.TextSize = size.Y
        shadow.BackgroundTransparency = 1
        shadow.Parent = drawList
    end

    if outlineEnabled then
        local function createOutline(offsetX, offsetY)
            local outline = Instance.new("TextLabel")
            outline.Size = label.Size
            outline.Position = label.Position + UDim2.new(0, offsetX, 0, offsetY)
            outline.Text = text
            outline.TextColor3 = outlineColor
            outline.Font = font
            outline.TextSize = size.Y
            outline.BackgroundTransparency = 1
            outline.Parent = drawList
        end
        createOutline(1, 0)
        createOutline(-1, 0)
        createOutline(0, 1)
        createOutline(0, -1)
    end
end

function ImGui.ForeGroundDrawList()
    local drawList = Instance.new("Folder")
    drawList.Name = "ForegroundDrawList"
    drawList.Parent = game.Players.LocalPlayer.PlayerGui.ScreenGui
    table.insert(drawLists, drawList)
    return drawList
end

function ImGui.AddLine(drawList, pointA, pointB, color, thickness)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, (pointB - pointA).Magnitude, 0, thickness)
    line.Position = UDim2.new(0, pointA.X, 0, pointA.Y)
    line.BackgroundColor3 = color
    line.Parent = drawList
end

function ImGui.AddRect(drawList, position, size, color)
    local rect = Instance.new("Frame")
    rect.Size = UDim2.new(0, size.X, 0, size.Y)
    rect.Position = UDim2.new(0, position.X, 0, position.Y)
    rect.BackgroundColor3 = color
    rect.Parent = drawList
end

function ImGui.AddCircle(drawList, position, radius, color)
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    circle.Position = UDim2.new(0, position.X - radius, 0, position.Y - radius)
    circle.BackgroundColor3 = color
    circle.Parent = drawList
end


return ImGui
