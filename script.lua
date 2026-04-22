local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- 🔥 ULTRA OPTIMISATION (UNE SEULE PASSE, 0 FREEZE)

task.spawn(function()
	repeat task.wait() until game:IsLoaded()

	local playerChar = player.Character
	local i = 0

	for _,v in ipairs(workspace:GetDescendants()) do
		i += 1

		-- ===== BASEPART =====
		if v:IsA("BasePart") then
			if not playerChar or not v:IsDescendantOf(playerChar) then
				v.Material = Enum.Material.Plastic
				v.Reflectance = 0
			end
		end

		-- ===== PARTICLES =====
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Smoke")
		or v:IsA("Fire")
		or v:IsA("Sparkles") then
			v.Enabled = false
		end

		-- ===== LIGHTS =====
		if v:IsA("PointLight")
		or v:IsA("SpotLight")
		or v:IsA("SurfaceLight") then
			v.Brightness = 0
		end

		-- 🔥 pause tous les 50 objets (important)
		if i % 50 == 0 then
			task.wait()
		end
	end

	-- ===== LIGHTING =====
	local lighting = game:GetService("Lighting")
	for _,v in pairs(lighting:GetChildren()) do
		if v:IsA("BlurEffect")
		or v:IsA("SunRaysEffect")
		or v:IsA("BloomEffect")
		or v:IsA("DepthOfFieldEffect") then
			v.Enabled = false
		end
	end

	print("OPTIM DONE (NO FREEZE)")
end)

-- REMOVE ANIM AU START
local function removeAnims(char)
	local humanoid = char:WaitForChild("Humanoid")

	humanoid:ChangeState(Enum.HumanoidStateType.Running)

	local animate = char:FindFirstChild("Animate")
	if animate then
		animate:Destroy()
	end

	for _,track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end
end

if player.Character then
	removeAnims(player.Character)
end

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	removeAnims(char)
end)

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

local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0.5,-15)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(30,30,40)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
Instance.new("UICorner", minimize)

local mini = Instance.new("TextButton", gui)
mini.Size = UDim2.new(0,60,0,60)
mini.Position = UDim2.new(1,-70,0.5,-30)
mini.BackgroundColor3 = Color3.fromRGB(10,10,15)
mini.Visible = false
mini.Text = ""
mini.AutoButtonColor = false
Instance.new("UICorner", mini)

local zText = Instance.new("TextLabel", mini)
zText.Size = UDim2.new(1,0,1,0)
zText.BackgroundTransparency = 1
zText.Text = "Z"
zText.Font = Enum.Font.GothamBlack
zText.TextScaled = true
zText.TextColor3 = Color3.fromRGB(255,0,0)

task.spawn(function()
	while true do
		local t = tick()
		local hue = 0.02 + math.sin(t*2)*0.02
		zText.TextColor3 = Color3.fromHSV(hue, 1, 1)
		task.wait(0.05)
	end
end)

local TweenService = game:GetService("TweenService")

-- positions
local openPos = frame.Position
local closedPos = UDim2.new(1, 50, openPos.Y.Scale, openPos.Y.Offset)

-- animation
local function animate(open)

	if open then
		frame.Visible = true
		border.Visible = true

		frame.Position = closedPos
		border.Position = UDim2.new(closedPos.X.Scale, closedPos.X.Offset - 8, closedPos.Y.Scale, closedPos.Y.Offset - 8)

		TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = openPos
		}):Play()

		TweenService:Create(border, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(openPos.X.Scale, openPos.X.Offset - 8, openPos.Y.Scale, openPos.Y.Offset - 8)
		}):Play()

		mini.Visible = false

	else
		local tween1 = TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = closedPos
		})

		local tween2 = TweenService:Create(border, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(closedPos.X.Scale, closedPos.X.Offset - 8, closedPos.Y.Scale, closedPos.Y.Offset - 8)
		})

		tween1:Play()
		tween2:Play()

		tween1.Completed:Connect(function()
			frame.Visible = false
			border.Visible = false
			mini.Visible = true
		end)
	end
end

-- boutons
minimize.MouseButton1Click:Connect(function()
	animate(false)
end)

mini.MouseButton1Click:Connect(function()
	animate(true)
end)

-- UI déjà réduite au lancement
task.wait(0.1)
animate(false)

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

local function createMarker(pos, color, isRainbow, labelText)
	local p = Instance.new("Part")
	p.Size = Vector3.new(2,3,2)
	p.Position = pos + Vector3.new(0,2,0)
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.Neon
	p.Transparency = 0
	p.Color = color

	-- 💎 forme stylée (losange fake)
	local mesh = Instance.new("SpecialMesh", p)
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Scale = Vector3.new(1,1.5,1)

	p.Orientation = Vector3.new(45,45,0)

	p.Parent = workspace

	-- 🏷 TEXTE AU DESSUS
	local billboard = Instance.new("BillboardGui", p)
	billboard.Size = UDim2.new(0,100,0,40)
	billboard.StudsOffset = Vector3.new(0,3,0)
	billboard.AlwaysOnTop = true

	local text = Instance.new("TextLabel", billboard)
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.Text = labelText
	text.Font = Enum.Font.GothamBlack
	text.TextScaled = true
	text.TextColor3 = Color3.new(1,1,1)
	text.TextStrokeTransparency = 0 -- contour noir

	-- 🌈 RAINBOW (TP1)
	if isRainbow then
		task.spawn(function()
			while p.Parent do
				local hue = (tick() % 5) / 5
				p.Color = Color3.fromHSV(hue,1,1)
				task.wait(0.05)
			end
		end)
	end

	-- 🌊 ANIMATION FLOAT + ROTATION
	task.spawn(function()
		local baseY = p.Position.Y
		while p.Parent do
			local t = tick()

			-- flotte
			local yOffset = math.sin(t * 2) * 0.5

			p.Position = Vector3.new(
				p.Position.X,
				baseY + yOffset,
				p.Position.Z
			)

			-- rotation
			p.Orientation = p.Orientation + Vector3.new(0,1,0)

			task.wait()
		end
	end)

	return p
end

-- 🔥 TP1 auto au spawn
task.spawn(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	task.wait(0.2) -- sécurité

	marker1 = createMarker(
		hrp.Position,
		Color3.new(),
		true,
		"TP1"
	)
end)

-- TP1
select1.MouseButton1Click:Connect(function() selecting1 = true end)

mouse.Button1Down:Connect(function()
	if selecting1 and not marker1 then
		marker1 = createMarker(mouse.Hit.Position, Color3.new(), true, "TP1")
		selecting1 = false
	end
	if selecting2 and not marker2 then
		marker2 = createMarker(mouse.Hit.Position, Color3.fromRGB(255,255,255), false, "TP2")
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
	if input.KeyCode == Enum.KeyCode.F then
	if marker1 then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(marker1.Position + Vector3.new(0,3,0))
	end

	task.delay(0.5, function()
	player:Kick("Brainrot stole successfully ✅")
end)

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
flySpeedBox.PlaceholderText = "Fly Speed (ex: 150)"
flySpeedBox.Text = "150"
flySpeedBox.BackgroundColor3 = Color3.fromRGB(20,20,30)
flySpeedBox.TextColor3 = Color3.new(1,1,1)
flySpeedBox.Font = Enum.Font.Gotham
flySpeedBox.TextSize = 14
Instance.new("UICorner", flySpeedBox)

local flying = false
local flySpeed = 150
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
			flySpeed = math.clamp(num, 10, 10000)
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
