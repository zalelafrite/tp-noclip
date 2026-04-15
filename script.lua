local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ================= GUI =================

local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- 🔴 BORDER
local border = Instance.new("Frame")
border.Parent = gui
border.Size = UDim2.new(0, 316, 0, 290)
border.Position = UDim2.new(1, -328, 0.3, -8)
border.BackgroundColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", border).CornerRadius = UDim.new(0,18)

local borderGrad = Instance.new("UIGradient", border)
borderGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(120,0,0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,180,180)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(120,0,0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
}

task.spawn(function()
	while true do
		TweenService:Create(borderGrad, TweenInfo.new(2), {
			Rotation = borderGrad.Rotation + 180
		}):Play()
		task.wait(2)
	end
end)

-- FRAME
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 270)
frame.Position = UDim2.new(1, -320, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(10,10,15)
frame.Active = true
Instance.new("UICorner", frame)

-- TOP BAR
local top = Instance.new("Frame", frame)
top.Size = UDim2.new(1,0,0,45)
top.BackgroundColor3 = Color3.fromRGB(15,15,25)
Instance.new("UICorner", top)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "TP + NOCLIP"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,60,60)

-- ================= DRAG =================

local dragging, dragStart, startPos

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

		border.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X - 8,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y - 8
		)
	end
end)

-- ================= BUTTONS =================

local function createBtn(text, y)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.new(1,-20,0,40)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(25,25,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	Instance.new("UICorner", b)
	return b
end

local selectBtn = createBtn("[C] Select",60)
local deleteBtn = createBtn("[T] Delete",110)
local tpBtn = createBtn("[F] Teleport",160)
local noclipBtn = createBtn("[R] Noclip : OFF",210)

-- ================= TP =================

local selecting = false
local marker = nil

local function createMarker(pos)
	if marker then return end

	marker = Instance.new("Part")
	marker.Size = Vector3.new(2,2,2)
	marker.Position = pos + Vector3.new(0,2,0)
	marker.Anchored = true
	marker.CanCollide = false
	marker.Color = Color3.fromRGB(255,0,0)
	marker.Material = Enum.Material.Neon
	marker.Parent = workspace
end

selectBtn.MouseButton1Click:Connect(function()
	selecting = true
end)

mouse.Button1Down:Connect(function()
	if selecting and not marker then
		createMarker(mouse.Hit.Position)
		selecting = false
	end
end)

deleteBtn.MouseButton1Click:Connect(function()
	if marker then
		marker:Destroy()
		marker = nil
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if marker and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(marker.Position + Vector3.new(0,3,0))
	end
end)

-- ================= TON NOCIP (INCHANGÉ) =================

local noclipEnabled = false
local connection

local function setNoclip(state)
	noclipEnabled = state

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if state then
		connection = RunService.Stepped:Connect(function()
			local char = player.Character
			if char then
				for _,v in pairs(char:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide then
						v.CanCollide = false
					end
				end
			end
		end)
	end
end

local function updateText()
	if noclipEnabled then
		noclipBtn.Text = "[R] Noclip : ON"
		noclipBtn.BackgroundColor3 = Color3.fromRGB(60,150,60)
	else
		noclipBtn.Text = "[R] Noclip : OFF"
		noclipBtn.BackgroundColor3 = Color3.fromRGB(25,25,40)
	end
end

updateText()

noclipBtn.MouseButton1Click:Connect(function()
	setNoclip(not noclipEnabled)
	updateText()
end)
-- ================= KEYBINDS =================

UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- évite le chat

	-- Noclip (R)
	if input.KeyCode == Enum.KeyCode.R then
		setNoclip(not noclipEnabled)
		updateText()
	end

	-- Select (C)
	if input.KeyCode == Enum.KeyCode.C then
		selecting = true
	end

	-- Delete (T)
	if input.KeyCode == Enum.KeyCode.T then
		if marker then
			marker:Destroy()
			marker = nil
		end
	end

	-- Teleport (F)
	if input.KeyCode == Enum.KeyCode.F then
		if marker and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(marker.Position + Vector3.new(0,3,0))
		end
	end
end)
