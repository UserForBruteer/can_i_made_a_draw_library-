-- Импорт библиотек
local Library = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Вспомогательные переменные и функции
local UIElements = {}

local function createFrame(name, size, position, parent)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.Size = UDim2.new(0, size.X, 0, size.Y)
	frame.Position = UDim2.new(0, position.X, 0, position.Y)
	frame.BackgroundTransparency = 1
	frame.Parent = parent
	return frame
end

local function isMouseInBounds(pos, size)
	local mouseX, mouseY = Mouse.X, Mouse.Y
	return mouseX >= pos.X and mouseX <= pos.X + size.X and mouseY >= pos.Y and mouseY <= pos.Y + size.Y
end

-- Основные функции
function Library:Begin(name, size, position)
	local frame = createFrame(name, size, position, game.Players.LocalPlayer:WaitForChild("PlayerGui"))
	table.insert(UIElements, frame)
	return frame
end

function Library:BeginChild(name, size, position, parent)
	local frame = createFrame(name, size, position, parent)
	table.insert(UIElements, frame)
	return frame
end

function Library:End()
	if #UIElements > 0 then
		table.remove(UIElements, #UIElements)
	end
end

function Library:EndChild()
	if #UIElements > 0 then
		table.remove(UIElements, #UIElements)
	end
end

function Library:CheckBox(name, position, parent, default)
	local frame = createFrame(name, Vector2.new(20, 20), position, parent)
	local checkbox = Instance.new("TextButton")
	checkbox.Size = UDim2.new(1, 0, 1, 0)
	checkbox.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	checkbox.Text = ""
	checkbox.Parent = frame

	local checked = default

	checkbox.MouseButton1Click:Connect(function()
		checked = not checked
		checkbox.BackgroundColor3 = checked and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	end)

	return checked
end

function Library:Button(name, position, size, parent, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, size.X, 0, size.Y)
	button.Position = UDim2.new(0, position.X, 0, position.Y)
	button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	button.Text = name
	button.Parent = parent

	button.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)
end

function Library:TextBox(name, position, size, parent, defaultText)
	local textBox = Instance.new("TextBox")
	textBox.Size = UDim2.new(0, size.X, 0, size.Y)
	textBox.Position = UDim2.new(0, position.X, 0, position.Y)
	textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	textBox.Text = defaultText or ""
	textBox.Parent = parent

	return textBox
end

function Library:Slider(name, position, size, min, max, default, parent, callback)
	local slider = Instance.new("TextButton")
	slider.Size = UDim2.new(0, size.X, 0, size.Y)
	slider.Position = UDim2.new(0, position.X, 0, position.Y)
	slider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
	slider.Text = name
	slider.Parent = parent

	local currentValue = default or min

	slider.MouseButton1Down:Connect(function()
		local moving = true
		while moving do
			wait()
			local mouseX = Mouse.X
			local newValue = math.clamp((mouseX - position.X) / size.X * (max - min) + min, min, max)
			currentValue = newValue
			if callback then callback(newValue) end
			if not Mouse.Button1Down then
				moving = false
			end
		end
	end)

	return currentValue
end

function Library:ForeGroundDrawList()
	return Instance.new("ScreenGui", LocalPlayer.PlayerGui)
end

function Library:BackGroundDrawList()
	return Instance.new("ScreenGui", LocalPlayer.PlayerGui)
end

-- Примитивы
function Library:AddLine(drawList, startPos, endPos, color, thickness)
	local line = Instance.new("Frame")
	line.Size = UDim2.new(0, (endPos - startPos).magnitude, 0, thickness)
	line.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
	line.BackgroundColor3 = color
	line.Parent = drawList
end

function Library:AddRect(drawList, position, size, color)
	local rect = Instance.new("Frame")
	rect.Size = UDim2.new(0, size.X, 0, size.Y)
	rect.Position = UDim2.new(0, position.X, 0, position.Y)
	rect.BackgroundColor3 = color
	rect.BorderSizePixel = 1
	rect.BorderColor3 = color
	rect.Parent = drawList
end

function Library:AddRectFilled(drawList, position, size, color)
	local rect = Instance.new("Frame")
	rect.Size = UDim2.new(0, size.X, 0, size.Y)
	rect.Position = UDim2.new(0, position.X, 0, position.Y)
	rect.BackgroundColor3 = color
	rect.Parent = drawList
end

function Library:AddCircle(drawList, position, radius, color)
	local circle = Instance.new("ImageLabel")
	circle.Image = "rbxassetid://5554831670"
	circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
	circle.Position = UDim2.new(0, position.X - radius, 0, position.Y - radius)
	circle.BackgroundTransparency = 1
	circle.ImageColor3 = color
	circle.Parent = drawList
end

function Library:AddCircleFilled(drawList, position, radius, color)
	local circle = Instance.new("ImageLabel")
	circle.Image = "rbxassetid://5554831670"
	circle.Size = UDim2.new(0, radius * 2, 0, radius * 2)
	circle.Position = UDim2.new(0, position.X - radius, 0, position.Y - radius)
	circle.BackgroundTransparency = 1
	circle.ImageColor3 = color
	circle.Parent = drawList
end

function Library:AddText(drawList, position, text, color)
	local textLabel = Instance.new("TextLabel")
	textLabel.Text = text
	textLabel.Size = UDim2.new(0, 200, 0, 50)
	textLabel.Position = UDim2.new(0, position.X, 0, position.Y)
	textLabel.TextColor3 = color
	textLabel.BackgroundTransparency = 1
	textLabel.Parent = drawList
end

function Library:AddCornerRect(drawList, position, size, color, radius)
	local cornerRect = Instance.new("Frame")
	cornerRect.Size = UDim2.new(0, size.X, 0, size.Y)
	cornerRect.Position = UDim2.new(0, position.X, 0, position.Y)
	cornerRect.BackgroundColor3 = color
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = cornerRect
	cornerRect.Parent = drawList
end

return Library
