local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("HollyBlackoutVisual")
if oldGui then oldGui:Destroy() end

local oldFolder = workspace:FindFirstChild("HollyVisualDrones_" .. player.UserId)
if oldFolder then oldFolder:Destroy() end

local colors = {
	black = Color3.fromRGB(0, 0, 0),
	panel = Color3.fromRGB(8, 8, 10),
	panel2 = Color3.fromRGB(15, 15, 18),
	panel3 = Color3.fromRGB(23, 23, 27),
	white = Color3.fromRGB(238, 238, 242),
	grey = Color3.fromRGB(125, 125, 133),
	accent = Color3.fromRGB(190, 190, 202),
	line = Color3.fromRGB(48, 48, 55)
}

local connections = {}
local function track(connection)
	table.insert(connections, connection)
	return connection
end

local function make(className, properties, parent)
	local object = Instance.new(className)
	for key, value in pairs(properties or {}) do
		object[key] = value
	end
	object.Parent = parent
	return object
end

local function corner(object, radius)
	make("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, object)
end

local gui = make("ScreenGui", {
	Name = "HollyBlackoutVisual",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

local blur = Lighting:FindFirstChild("HollyBlackoutBlur")
local ownsBlur = not blur
if not blur then
	blur = Instance.new("BlurEffect")
	blur.Name = "HollyBlackoutBlur"
	blur.Size = 0
	blur.Parent = Lighting
end
TweenService:Create(blur, TweenInfo.new(0.3), {Size = 7}):Play()

local main = make("Frame", {
	Name = "Main",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(440, 580),
	BackgroundColor3 = colors.black,
	BorderSizePixel = 0,
	ClipsDescendants = true
}, gui)
corner(main, 13)

local mainStroke = make("UIStroke", {
	Color = colors.accent,
	Thickness = 1,
	Transparency = 0.3
}, main)

local mainGradient = make("UIGradient", {
	Rotation = 35,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 16, 20)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 13, 17))
	})
}, main)

local scale = make("UIScale", {Scale = 1}, main)
local function updateScale()
	local camera = workspace.CurrentCamera
	if camera then
		scale.Scale = math.clamp(math.min(camera.ViewportSize.X / 540, camera.ViewportSize.Y / 630), 0.68, 1)
	end
end
updateScale()
if workspace.CurrentCamera then
	track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale))
end

local top = make("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, 52),
	BackgroundColor3 = colors.panel,
	BorderSizePixel = 0
}, main)
corner(top, 13)

local title = make("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(17, 2),
	Size = UDim2.new(1, -76, 0, 27),
	Font = Enum.Font.GothamBold,
	Text = "HOLLY  /  BLACKOUT",
	TextColor3 = colors.white,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left
}, top)

local subtitle = make("TextLabel", {
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(18, 27),
	Size = UDim2.new(1, -80, 0, 16),
	Font = Enum.Font.Gotham,
	Text = "VISUAL COMPANION SYSTEM",
	TextColor3 = colors.grey,
	TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = make("TextButton", {
	Size = UDim2.fromOffset(34, 30),
	Position = UDim2.new(1, -43, 0, 10),
	BackgroundColor3 = colors.panel3,
	BorderSizePixel = 0,
	Text = "×",
	TextColor3 = colors.white,
	TextSize = 21,
	Font = Enum.Font.Gotham
}, top)
corner(close, 8)

local content = make("Frame", {
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(17, 67),
	Size = UDim2.new(1, -34, 1, -83)
}, main)

local function addLabel(text, y, size, color)
	return make("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, y),
		Size = UDim2.new(1, 0, 0, 21),
		Font = Enum.Font.GothamSemibold,
		Text = text,
		TextColor3 = color or colors.white,
		TextSize = size or 12,
		TextXAlignment = Enum.TextXAlignment.Left
	}, content)
end

local function addButton(text, x, y, width, height)
	local button = make("TextButton", {
		Position = UDim2.fromOffset(x, y),
		Size = UDim2.fromOffset(width, height or 32),
		BackgroundColor3 = colors.panel2,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = text,
		TextColor3 = colors.white,
		TextSize = 11,
		Font = Enum.Font.GothamMedium
	}, content)
	corner(button, 8)
	local stroke = make("UIStroke", {
		Color = colors.accent,
		Transparency = 0.78,
		Thickness = 1
	}, button)
	track(button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.13), {BackgroundColor3 = colors.panel3}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.13), {Transparency = 0.35}):Play()
	end))
	track(button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.16), {BackgroundColor3 = colors.panel2}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.16), {Transparency = 0.78}):Play()
	end))
	return button
end

addLabel("VISUAL DRONE DISPLAY", 0, 12)
local status = addLabel("STATUS  /  OFF", 24, 10, colors.grey)
local toggle = addButton("ENABLE DISPLAY", 53, 0, 185, 33)
local countLabel = addLabel("DRONES  /  6", 99, 11)
local minus = addButton("−", 95, 125, 38, 30)
local plus = addButton("+", 139, 125, 38, 30)
local formationLabel = addLabel("FORMATION  /  ORBIT", 151, 10, colors.grey)
local formationButton = addButton("CHANGE FORMATION", 177, 0, 185, 32)
local speedLabel = addLabel("ORBIT SPEED  /  1.0x", 221, 10, colors.grey)
local slower = addButton("− SPEED", 247, 0, 88, 31)
local faster = addButton("+ SPEED", 97, 247, 88, 31)
local styleLabel = addLabel("DRONE STYLE  /  MONO", 291, 10, colors.grey)
local styleButton = addButton("CHANGE STYLE", 247, 314, 185, 31)
local auraButton = addButton("AURA: OFF", 0, 353, 185, 30)
local trailButton = addButton("TRAIL: OFF", 195, 353, 185, 30)
local sparkleButton = addButton("SPARKLES: OFF", 0, 391, 185, 30)
local tintButton = addButton("AMBIENT TINT: OFF", 195, 391, 185, 30)
local effectLabel = addLabel("LOCAL EFFECTS  /  COSMETIC ONLY", 430, 9, colors.grey)
local resetButton = addButton("RESET VISUALS", 0, 450, 380, 30)
local footer = make("TextLabel", {
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, 0, 1, -2),
	Size = UDim2.new(1, 0, 0, 15),
	Font = Enum.Font.Gotham,
	Text = "LOCAL COSMETIC PREVIEW  •  RIGHT SHIFT TO TOGGLE",
	TextColor3 = colors.grey,
	TextSize = 8,
	TextXAlignment = Enum.TextXAlignment.Right
}, content)

local folder = make("Folder", {Name = "HollyVisualDrones_" .. player.UserId}, workspace)
local drones = {}
local enabled = false
local droneCount = 6
local formation = 1
local speed = 1
local style = 1
local renderConnection
local formations = {"ORBIT", "LINE", "HELIX", "DIAMOND"}
local styles = {"MONO", "STEALTH", "ICE"}
local styleColors = {
	{body = Color3.fromRGB(150, 150, 160), glow = Color3.fromRGB(215, 215, 225), ring = Color3.fromRGB(75, 75, 85)},
	{body = Color3.fromRGB(65, 65, 72), glow = Color3.fromRGB(145, 145, 155), ring = Color3.fromRGB(38, 38, 44)},
	{body = Color3.fromRGB(125, 140, 155), glow = Color3.fromRGB(190, 210, 230), ring = Color3.fromRGB(70, 85, 105)}
}

local function makePart(model, name, size, material, color, shape)
	local part = make("Part", {
		Name = name,
		Size = size,
		Shape = shape or Enum.PartType.Block,
		Material = material or Enum.Material.SmoothPlastic,
		Color = color,
		Anchored = true,
		CanCollide = false,
		CanTouch = false,
		CanQuery = false,
		CastShadow = false,
		Massless = true
	}, model)
	return part
end

local function makeDrone(index)
	local palette = styleColors[style]
	local model = make("Model", {Name = "VisualDrone" .. index}, folder)
	local body = makePart(model, "Body", Vector3.new(0.72, 0.22, 0.72), Enum.Material.Metal, palette.body)
	model.PrimaryPart = body
	local core = makePart(model, "Core", Vector3.new(0.24, 0.24, 0.24), Enum.Material.Neon, palette.glow, Enum.PartType.Ball)
	core.CFrame = body.CFrame
	local light = make("PointLight", {Color = palette.glow, Brightness = 0.65, Range = 6}, core)
	local ring = makePart(model, "Halo", Vector3.new(0.045, 1.05, 1.05), Enum.Material.Neon, palette.ring, Enum.PartType.Cylinder)
	local rotors = {}
	for _, x in ipairs({-1, 1}) do
		for _, z in ipairs({-1, 1}) do
			local arm = makePart(model, "Arm", Vector3.new(0.12, 0.1, 0.78), Enum.Material.Metal, palette.body)
			arm.CFrame = body.CFrame * CFrame.new(x * 0.34, 0, z * 0.34) * CFrame.Angles(0, math.rad(x * z * 35), 0)
			local rotor = makePart(model, "Rotor", Vector3.new(0.06, 0.42, 0.42), Enum.Material.Neon, palette.glow, Enum.PartType.Cylinder)
			table.insert(rotors, {part = rotor, x = x, z = z})
		end
	end
	drones[index] = {model = model, body = body, core = core, ring = ring, rotors = rotors, light = light}
end

local function rebuildDrones()
	for _, drone in pairs(drones) do
		drone.model:Destroy()
	end
	table.clear(drones)
	for index = 1, droneCount do
		makeDrone(index)
	end
	countLabel.Text = "DRONES  /  " .. droneCount
end

local function getOffset(index, total, now)
	local angle = now * speed + (index - 1) * math.pi * 2 / total
	if formation == 1 then
		return Vector3.new(math.cos(angle) * 4.8, 2.7 + math.sin(now * 2 + index) * 0.3, math.sin(angle) * 4.8), angle
	elseif formation == 2 then
		return Vector3.new((index - (total + 1) / 2) * 1.65, 2.4 + math.sin(now * 2 + index) * 0.22, -5), 0
	elseif formation == 3 then
		local radius = 2.7 + (index / total) * 2.2
		return Vector3.new(math.cos(angle) * radius, 1.7 + (index - 1) * 0.42, math.sin(angle) * radius), angle
	else
		local slot = (index - 1) % 4
		local layer = math.floor((index - 1) / 4)
		local points = {
			Vector3.new(0, 0, -5),
			Vector3.new(5, 0, 0),
			Vector3.new(0, 0, 5),
			Vector3.new(-5, 0, 0)
		}
		local point = points[slot + 1]
		return Vector3.new(point.X, 2.3 + layer * 1.1, point.Z), 0
	end
end

local function updateStatus()
	status.Text = "STATUS  /  " .. (enabled and "ACTIVE" or "OFF")
	toggle.Text = enabled and "DISABLE DISPLAY" or "ENABLE DISPLAY"
end

local function setEnabled(value)
	enabled = value
	updateStatus()
	if enabled and not renderConnection then
		renderConnection = RunService.RenderStepped:Connect(function()
			local character = player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not root then return end
			local now = os.clock()
			for index, drone in ipairs(drones) do
				local offset, yaw = getOffset(index, #drones, now)
				local position = root.Position + root.CFrame:VectorToWorldSpace(offset)
				local base = CFrame.new(position) * CFrame.Angles(0, yaw, 0)
				drone.model:PivotTo(base)
				drone.ring.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90), now * speed + index, 0)
				drone.core.CFrame = CFrame.new(position + Vector3.new(0, 0.16, 0))
				for _, rotor in ipairs(drone.rotors) do
					local rotorPos = position + root.CFrame:VectorToWorldSpace(offset + Vector3.new(rotor.x * 0.42, 0.13, rotor.z * 0.42))
					rotor.part.CFrame = CFrame.new(rotorPos) * CFrame.Angles(0, now * speed * 8, math.rad(90))
				end
			end
		end)
	elseif not enabled and renderConnection then
		renderConnection:Disconnect()
		renderConnection = nil
	end
end


local effects = {
	aura = false,
	trail = false,
	sparkles = false,
	tint = false
}
local effectFolder
local auraPart
local trailObject
local sparkleEmitter
local colorEffect
local effectConnection
local effectHue = 0

local function clearEffectObjects()
	if effectFolder then
		effectFolder:Destroy()
		effectFolder = nil
	end
	if trailObject then
		local parent = trailObject.Parent
		trailObject:Destroy()
		trailObject = nil
		if parent then
			for _, name in ipairs({"HollyTrailA", "HollyTrailB"}) do
				local attachment = parent:FindFirstChild(name)
				if attachment then attachment:Destroy() end
			end
		end
	end
	if sparkleEmitter then
		local attachment = sparkleEmitter.Parent
		sparkleEmitter:Destroy()
		sparkleEmitter = nil
		if attachment then attachment:Destroy() end
	end
	if colorEffect then
		colorEffect:Destroy()
		colorEffect = nil
	end
	auraPart = nil
end

local function createAura(root)
	if auraPart and auraPart.Parent then return end
	effectFolder = make("Folder", {Name = "HollyLocalEffects"}, workspace)
	auraPart = make("Part", {
		Name = "CosmeticAura",
		Shape = Enum.PartType.Cylinder,
		Size = Vector3.new(0.08, 5.4, 5.4),
		Material = Enum.Material.Neon,
		Color = Color3.fromRGB(180, 180, 195),
		Transparency = 0.35,
		Anchored = true,
		CanCollide = false,
		CanTouch = false,
		CanQuery = false,
		CastShadow = false
	}, effectFolder)
	local glow = make("PointLight", {Color = auraPart.Color, Brightness = 0.45, Range = 9}, auraPart)
	return glow
end

local function createTrail(character)
	if trailObject and trailObject.Parent then return end
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local a0 = make("Attachment", {Name = "HollyTrailA", Position = Vector3.new(0, 0.65, 0.25)}, root)
	local a1 = make("Attachment", {Name = "HollyTrailB", Position = Vector3.new(0, -0.65, 0.25)}, root)
	trailObject = make("Trail", {
		Name = "HollyCosmeticTrail",
		Attachment0 = a0,
		Attachment1 = a1,
		Lifetime = 0.42,
		MinLength = 0.08,
		FaceCamera = true,
		LightEmission = 0.8,
		Color = ColorSequence.new(Color3.fromRGB(100, 100, 115), Color3.fromRGB(230, 230, 240)),
		Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.12), NumberSequenceKeypoint.new(1, 1)}),
		WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 0)})
	}, root)
end

local function createSparkles(root)
	if sparkleEmitter and sparkleEmitter.Parent then return end
	local attachment = make("Attachment", {Name = "HollySparkleAttachment", Position = Vector3.new(0, 0.8, 0)}, root)
	sparkleEmitter = make("ParticleEmitter", {
		Name = "HollyCosmeticSparkles",
		Texture = "rbxasset://textures/particles/sparkles_main.dds",
		Rate = 8,
		Lifetime = NumberRange.new(0.45, 0.9),
		Speed = NumberRange.new(0.2, 0.8),
		SpreadAngle = Vector2.new(180, 180),
		LightEmission = 0.8,
		Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.12), NumberSequenceKeypoint.new(0.5, 0.2), NumberSequenceKeypoint.new(1, 0)}),
		Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)}),
		Color = ColorSequence.new(Color3.fromRGB(180, 180, 195), Color3.fromRGB(245, 245, 255))
	}, attachment)
end

local function applyEffectState()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if effects.aura and root then
		createAura(root)
	elseif auraPart then
		auraPart:Destroy()
		auraPart = nil
	end
	if effects.trail and character then
		createTrail(character)
	elseif trailObject then
		local parent = trailObject.Parent
		trailObject:Destroy()
		trailObject = nil
		if parent then
			for _, name in ipairs({"HollyTrailA", "HollyTrailB"}) do
				local attachment = parent:FindFirstChild(name)
				if attachment then attachment:Destroy() end
			end
		end
	end
	if effects.sparkles and root then
		createSparkles(root)
	elseif sparkleEmitter then
		local attachment = sparkleEmitter.Parent
		sparkleEmitter:Destroy()
		sparkleEmitter = nil
		if attachment then attachment:Destroy() end
	end
	if effects.tint and not colorEffect then
		colorEffect = make("ColorCorrectionEffect", {
			Name = "HollyLocalTint",
			Brightness = 0.015,
			Contrast = 0.08,
			Saturation = -0.12,
			TintColor = Color3.fromRGB(220, 220, 235)
		}, Lighting)
	elseif not effects.tint and colorEffect then
		colorEffect:Destroy()
		colorEffect = nil
	end
	local function updateButton(button, label, on)
		button.Text = label .. ": " .. (on and "ON" or "OFF")
		button.BackgroundColor3 = on and colors.panel3 or colors.panel2
	end
	updateButton(auraButton, "AURA", effects.aura)
	updateButton(trailButton, "TRAIL", effects.trail)
	updateButton(sparkleButton, "SPARKLES", effects.sparkles)
	updateButton(tintButton, "AMBIENT TINT", effects.tint)
end

local function resetVisuals()
	effects.aura = false
	effects.trail = false
	effects.sparkles = false
	effects.tint = false
	setEnabled(false)
	clearEffectObjects()
	applyEffectState()
	if droneCount ~= 6 then
		droneCount = 6
		rebuildDrones()
	end
	formation = 1
	style = 1
	speed = 1
	formationLabel.Text = "FORMATION  /  " .. formations[formation]
	styleLabel.Text = "DRONE STYLE  /  " .. styles[style]
	speedLabel.Text = "ORBIT SPEED  /  1.0x"
	effectLabel.Text = "LOCAL EFFECTS  /  RESET COMPLETE"
end

track(auraButton.MouseButton1Click:Connect(function()
	effects.aura = not effects.aura
	applyEffectState()
end))
track(trailButton.MouseButton1Click:Connect(function()
	effects.trail = not effects.trail
	applyEffectState()
end))
track(sparkleButton.MouseButton1Click:Connect(function()
	effects.sparkles = not effects.sparkles
	applyEffectState()
end))
track(tintButton.MouseButton1Click:Connect(function()
	effects.tint = not effects.tint
	applyEffectState()
end))
track(resetButton.MouseButton1Click:Connect(resetVisuals))
track(player.CharacterAdded:Connect(function()
	task.wait(0.6)
	clearEffectObjects()
	applyEffectState()
end))

effectConnection = RunService.RenderStepped:Connect(function(dt)
	effectHue = (effectHue + dt * 0.08) % 1
	if effects.aura and auraPart then
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root then
			auraPart.CFrame = CFrame.new(root.Position - Vector3.new(0, 2.7, 0)) * CFrame.Angles(0, 0, math.rad(90))
			auraPart.Color = Color3.fromHSV(effectHue, 0.22, 0.88)
			auraPart.Transparency = 0.28 + math.sin(os.clock() * 2.2) * 0.08
		end
	end
end)

local function cycleFormation()
	formation = formation % #formations + 1
	formationLabel.Text = "FORMATION  /  " .. formations[formation]
end

local function cycleStyle()
	style = style % #styles + 1
	styleLabel.Text = "DRONE STYLE  /  " .. styles[style]
	rebuildDrones()
end

track(toggle.MouseButton1Click:Connect(function()
	setEnabled(not enabled)
end))
track(minus.MouseButton1Click:Connect(function()
	droneCount = math.max(1, droneCount - 1)
	rebuildDrones()
end))
track(plus.MouseButton1Click:Connect(function()
	droneCount = math.min(12, droneCount + 1)
	rebuildDrones()
end))
track(formationButton.MouseButton1Click:Connect(cycleFormation))
track(slower.MouseButton1Click:Connect(function()
	speed = math.max(0.2, math.floor((speed - 0.2) * 10 + 0.5) / 10)
	speedLabel.Text = string.format("ORBIT SPEED  /  %.1fx", speed)
end))
track(faster.MouseButton1Click:Connect(function()
	speed = math.min(2.5, math.floor((speed + 0.2) * 10 + 0.5) / 10)
	speedLabel.Text = string.format("ORBIT SPEED  /  %.1fx", speed)
end))
track(styleButton.MouseButton1Click:Connect(cycleStyle))
track(close.MouseButton1Click:Connect(function()
	gui.Enabled = false
end))

local dragging = false
local dragStart
local startPosition
track(top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPosition = main.Position
	end
end))
track(UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
end))
track(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end))

local pulse = TweenService:Create(mainStroke, TweenInfo.new(1.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.08})
pulse:Play()
local gradientTween = TweenService:Create(mainGradient, TweenInfo.new(9, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 395})
gradientTween:Play()

rebuildDrones()
setEnabled(false)

local cleaned = false
local function cleanup()
	if cleaned then return end
	cleaned = true
	setEnabled(false)
	pulse:Cancel()
	gradientTween:Cancel()
	for _, connection in ipairs(connections) do
		pcall(function() connection:Disconnect() end)
	end
	if folder and folder.Parent then folder:Destroy() end
	if effectConnection then effectConnection:Disconnect() effectConnection = nil end
	clearEffectObjects()
	if blur and blur.Parent then
		TweenService:Create(blur, TweenInfo.new(0.2), {Size = 0}):Play()
		if ownsBlur then
			task.delay(0.25, function()
				if blur and blur.Parent then blur:Destroy() end
			end)
		end
	end
end

track(gui.Destroying:Connect(cleanup))
track(UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightShift then
		gui.Enabled = not gui.Enabled
	end
end))
