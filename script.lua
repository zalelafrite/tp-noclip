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
title.Text = "Dark-Zakito-Script"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,60,60)

-- DRAG
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

local function createBtn(text, x, y)
	local b = Instance.new("TextButton")
	b.Parent = frame
	b.Size = UDim2.new(0.5,-15,0,40)
	b.Position = UDim2.new(x,10,y,0)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(25,25,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	Instance.new("UICorner", b)
	return b
end

-- TP1
local select1 = createBtn("[C] Select",0,0)
select1.Position = UDim2.new(0,10,0,60)

local delete1 = createBtn("[T] Delete",0,0)
delete1.Position = UDim2.new(0,10,0,110)

local tp1 = createBtn("[F] TP",0,0)
tp1.Position = UDim2.new(0,10,0,160)

-- TP2
local select2 = createBtn("[V] Select",0.5,0)
select2.Position = UDim2.new(0.5,5,0,60)

local delete2 = createBtn("[Y] Delete",0.5,0)
delete2.Position = UDim2.new(0.5,5,0,110)

local tp2 = createBtn("[G] TP",0.5,0)
tp2.Position = UDim2.new(0.5,5,0,160)

-- Noclip
local noclipBtn = Instance.new("TextButton")
noclipBtn.Parent = frame
noclipBtn.Size = UDim2.new(1,-20,0,40)
noclipBtn.Position = UDim2.new(0,10,0,215)
noclipBtn.Text = "[R] Noclip : OFF"
noclipBtn.BackgroundColor3 = Color3.fromRGB(25,25,40)
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 16
Instance.new("UICorner", noclipBtn)

-- ================= TP =================

local selecting1, selecting2 = false, false
local marker1, marker2 = nil, nil

local function createMarker(pos, color)
	local p = Instance.new("Part")
	p.Size = Vector3.new(2,2,2)
	p.Position = pos + Vector3.new(0,2,0)
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.Glass
	p.Color = color
	p.Transparency = 0.3
	p.Parent = workspace
	return p
end

-- TP1
select1.MouseButton1Click:Connect(function() selecting1 = true end)

mouse.Button1Down:Connect(function()
	if selecting1 and not marker1 then
		marker1 = createMarker(mouse.Hit.Position, Color3.fromRGB(255,0,0))
		selecting1 = false
	end
	if selecting2 and not marker2 then
		marker2 = createMarker(mouse.Hit.Position, Color3.fromRGB(0,170,255))
		selecting2 = false
	end
end)

delete1.MouseButton1Click:Connect(function()
	if marker1 then marker1:Destroy() marker1 = nil end
end)

tp1.MouseButton1Click:Connect(function()
	if marker1 and player.Character then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(marker1.Position + Vector3.new(0,3,0))
	end
end)

-- TP2
select2.MouseButton1Click:Connect(function() selecting2 = true end)

delete2.MouseButton1Click:Connect(function()
	if marker2 then marker2:Destroy() marker2 = nil end
end)

tp2.MouseButton1Click:Connect(function()
	if marker2 and player.Character then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(marker2.Position + Vector3.new(0,3,0))
	end
end)

-- ================= NOCLIP =================

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

noclipBtn.MouseButton1Click:Connect(function()
	setNoclip(not noclipEnabled)
	updateText()
end)

updateText()

-- ================= KEYBINDS =================

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.C then selecting1 = true end
	if input.KeyCode == Enum.KeyCode.T then if marker1 then marker1:Destroy() marker1=nil end end
	if input.KeyCode == Enum.KeyCode.F then if marker1 then player.Character.HumanoidRootPart.CFrame = CFrame.new(marker1.Position + Vector3.new(0,3,0)) end end

	if input.KeyCode == Enum.KeyCode.V then selecting2 = true end
	if input.KeyCode == Enum.KeyCode.Y then if marker2 then marker2:Destroy() marker2=nil end end
	if input.KeyCode == Enum.KeyCode.G then if marker2 then player.Character.HumanoidRootPart.CFrame = CFrame.new(marker2.Position + Vector3.new(0,3,0)) end end

	if input.KeyCode == Enum.KeyCode.R then
		setNoclip(not noclipEnabled)
		updateText()
	end
end)
-- ================= FLY =================

-- 🔧 agrandir le cadre pour accueillir le fly
frame.Size = UDim2.new(0, 300, 0, 370)
border.Size = UDim2.new(0, 316, 0, 390)

-- bouton fly
local flyBtn = Instance.new("TextButton")
flyBtn.Parent = frame
flyBtn.Size = UDim2.new(1,-20,0,40)
flyBtn.Position = UDim2.new(0,10,0,265)
flyBtn.Text = "[B] Fly : OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(25,25,40)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 16
Instance.new("UICorner", flyBtn)

-- input vitesse
local flySpeedBox = Instance.new("TextBox")
flySpeedBox.Parent = frame
flySpeedBox.Size = UDim2.new(1,-20,0,30)
flySpeedBox.Position = UDim2.new(0,10,0,310)
flySpeedBox.PlaceholderText = "Fly Speed (ex: 60)"
flySpeedBox.Text = "60"
flySpeedBox.BackgroundColor3 = Color3.fromRGB(20,20,30)
flySpeedBox.TextColor3 = Color3.new(1,1,1)
flySpeedBox.Font = Enum.Font.Gotham
flySpeedBox.TextSize = 14
Instance.new("UICorner", flySpeedBox)

local flying = false
local flySpeed = 60
local bv, bg

local function startFly()
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.Parent = hrp
end

local function stopFly()
	if bv then bv:Destroy() bv = nil end
	if bg then bg:Destroy() bg = nil end
end

RunService.RenderStepped:Connect(function()
	if not flying or not bv then return end

	local cam = workspace.CurrentCamera
	local moveDir = Vector3.new()

	if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
	if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end

	bv.Velocity = moveDir * flySpeed
	bg.CFrame = cam.CFrame
end)

-- vitesse
flySpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local num = tonumber(flySpeedBox.Text)
		if num then
			flySpeed = math.clamp(num, 10, 500)
			flySpeedBox.Text = tostring(flySpeed)
		else
			flySpeedBox.Text = tostring(flySpeed)
		end
	end
end)

-- toggle
local function updateFly()
	if flying then
		flyBtn.Text = "[B] Fly : ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(60,150,60)
	else
		flyBtn.Text = "[B] Fly : OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(25,25,40)
	end
end

local function switchFly()
	flying = not flying

	if flying then
		startFly()
	else
		stopFly()
	end

	updateFly()
end

flyBtn.MouseButton1Click:Connect(switchFly)

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end

	if input.KeyCode == Enum.KeyCode.B then
		switchFly()
	end
end)

updateFly()
