local GUI = {}
local UIS = game:GetService("UserInputService")

function GUI.Start()
    GUI.elements = {}
    GUI.foregroundColor = Color3.fromRGB(0, 0, 0)
    GUI.backgroundColor = Color3.fromRGB(255, 255, 255)
end
function GUI.End()
    for _, element in pairs(GUI.elements) do
        element.Parent = script.Parent
    end
end

function GUI.NewFrame()
    for _, element in pairs(GUI.elements) do
        element:Destroy()
    end
    GUI.elements = {}
end

function GUI.ForeGround(color)
    GUI.foregroundColor = color
end

function GUI.BackGround(color)
    GUI.backgroundColor = color
end

function GUI.Text(text, position)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Position = UDim2.new(0, position.X, 0, position.Y)
    label.Size = UDim2.new(0, 200, 0, 50)
    label.BackgroundTransparency = 1
    label.TextColor3 = GUI.foregroundColor
    table.insert(GUI.elements, label)
    return label
end

function GUI.Button(name, position, size, onClick)
    local button = Instance.new("TextButton")
    button.Text = name
    button.Position = UDim2.new(0, position.X, 0, position.Y)
    button.Size = UDim2.new(0, size.X, 0, size.Y)
    button.BackgroundColor3 = GUI.backgroundColor
    button.TextColor3 = GUI.foregroundColor

    button.MouseButton1Click:Connect(onClick)
    table.insert(GUI.elements, button)
    return button
end

function GUI.CheckBox(name, position, size, default, onToggle)
    local checkBox = Instance.new("TextButton")
    checkBox.Text = default and "✔" or ""
    checkBox.Position = UDim2.new(0, position.X, 0, position.Y)
    checkBox.Size = UDim2.new(0, size.X, 0, size.Y)
    checkBox.BackgroundColor3 = GUI.backgroundColor
    checkBox.TextColor3 = GUI.foregroundColor

    local checked = default
    checkBox.MouseButton1Click:Connect(function()
        checked = not checked
        checkBox.Text = checked and "✔" or ""
        if onToggle then onToggle(checked) end
    end)
    table.insert(GUI.elements, checkBox)
    return checkBox
end

function GUI.Slider(name, position, size, min, max, default, onChange)
    local slider = Instance.new("Frame")
    slider.Position = UDim2.new(0, position.X, 0, position.Y)
    slider.Size = UDim2.new(0, size.X, 0, size.Y)
    slider.BackgroundColor3 = GUI.backgroundColor

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 1, 0)
    knob.BackgroundColor3 = GUI.foregroundColor
    knob.Parent = slider

    local value = default or min
    knob.Position = UDim2.new((value - min) / (max - min), 0, 0, 0)
    
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            UIS.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UIS:GetMouseLocation().X
                    local relativePos = math.clamp((mousePos - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * relativePos
                    knob.Position = UDim2.new(relativePos, 0, 0, 0)
                    if onChange then onChange(value) end
                end
            end)
        end
    end)

    table.insert(GUI.elements, slider)
    return slider
end
function GUI.AddLine(startPos, endPos, thickness, color)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, (endPos - startPos).Magnitude, 0, thickness)
    line.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
    line.BackgroundColor3 = color
    line.Rotation = math.deg(math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X))
    table.insert(GUI.elements, line)
    return line
end

function GUI.AddRect(position, size, color)
    local rect = Instance.new("Frame")
    rect.Position = UDim2.new(0, position.X, 0, position.Y)
    rect.Size = UDim2.new(0, size.X, 0, size.Y)
    rect.BackgroundColor3 = color
    table.insert(GUI.elements, rect)
    return rect
end

function GUI.AddCircle(position, radius, color)
    local circle = Instance.new("Frame")
    circle.Position = UDim2.new(0, position.X - radius, 0, position.Y - radius)
    circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    circle.BackgroundColor3 = color
    circle.BorderSizePixel = 0
    circle.ClipsDescendants = true

    local innerCircle = Instance.new("UICorner")
    innerCircle.CornerRadius = UDim.new(1, 0)
    innerCircle.Parent = circle

    table.insert(GUI.elements, circle)
    return circle
end

return GUI
