-- =====================================================================
-- ZOMBIE HUB | REAL FUTBOL 24 (REMOTE EVENTS PRO) 💜⚽
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local keyFileName = "zombie_hub_rf24_key.txt"
local vipKey = "ZUMBI-KEY-5592-VIP"
local studioExpireTime = 0

-- Sistema de Persistência e Tempo de Key
local function getStoredData()
	if writefile and readfile and isfile then
		local success, content = pcall(readfile, keyFileName)
		if success and content then
			local sep = content:find("|")
			if sep then
				return content:sub(1, sep - 1), tonumber(content:sub(sep + 1))
			else
				return content, 0
			end
		end
	end
	return nil, 0
end

local function getRemainingTime()
	if RunService:IsStudio() then
		if studioExpireTime == 0 then studioExpireTime = os.time() + 86400 end
		local left = studioExpireTime - os.time()
		return left > 0 and left or 0
	end
	local key, exp = getStoredData()
	if key == vipKey then return 999999999 end
	if exp then
		local left = exp - os.time()
		return left > 0 and left or 0
	end
	return 0
end

local function saveKey(kText)
	if writefile then
		pcall(function()
			if kText == vipKey then
				writefile(keyFileName, kText .. "|" .. tostring(os.time() + 999999999))
			else
				writefile(keyFileName, kText .. "|" .. tostring(os.time() + 86400))
			end
		end)
	end
end

local function formatTime(seconds)
	if seconds >= 999999900 then return "VIP Permanente ∞" end
	if seconds <= 0 then return "Expirada" end
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	return string.format("%02dh %02dm %02ds", h, m, s)
end

if PlayerGui:FindFirstChild("ZombieHubRF24Main") then PlayerGui.ZombieHubRF24Main:Destroy() end
if PlayerGui:FindFirstChild("ZombieHubKey") then PlayerGui.ZombieHubKey:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZombieHubRF24Main"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9114220745"
clickSound.Volume = 0.5
clickSound.Parent = ScreenGui

local hasKey = getRemainingTime() > 0
ScreenGui.Enabled = hasKey

-- =====================================================================
-- DETECÇÃO E DISPARO AUTOMÁTICO DE EVENTOS REMOTOS
-- =====================================================================
local function fireGameRemote(actionKeyword, ...)
	local args = {...}
	pcall(function()
		for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
			if obj:IsA("RemoteEvent") then
				local name = obj.Name:lower()
				if name:find(actionKeyword:lower()) then
					obj:FireServer(unpack(args))
				end
			end
		end
	end)
end

local function getClosestBall()
	local closestBall = nil
	local shortestDist = math.huge
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return nil end

	for _, obj in ipairs(Workspace:GetDescendants()) do
		local lname = obj.Name:lower()
		if lname:find("ball") or lname:find("football") or lname:find("bola") then
			local ballPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
			if ballPart then
				local dist = (ballPart.Position - root.Position).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closestBall = ballPart
				end
			end
		end
	end
	return closestBall
end

-- =====================================================================
-- TELA DE VERIFICAÇÃO DE KEY
-- =====================================================================
if not hasKey then
	local KeyGui = Instance.new("ScreenGui")
	KeyGui.Name = "ZombieHubKey"
	KeyGui.Parent = PlayerGui
	KeyGui.ResetOnSpawn = false

	local KeyFrame = Instance.new("Frame")
	KeyFrame.Size = UDim2.new(0, 420, 0, 270)
	KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -135)
	KeyFrame.BackgroundColor3 = Color3.fromRGB(16, 10, 26)
	KeyFrame.BorderSizePixel = 0
	KeyFrame.Parent = KeyGui

	local kCorner = Instance.new("UICorner")
	kCorner.CornerRadius = UDim.new(0, 14)
	kCorner.Parent = KeyFrame

	local kStroke = Instance.new("UIStroke")
	kStroke.Color = Color3.fromRGB(160, 32, 240)
	kStroke.Thickness = 2
	kStroke.Parent = KeyFrame

	local kTitle = Instance.new("TextLabel")
	kTitle.Size = UDim2.new(1, 0, 0, 45)
	kTitle.BackgroundTransparency = 1
	kTitle.Text = "🔑 ZOMBIE HUB — VERIFICAÇÃO DE KEY"
	kTitle.TextColor3 = Color3.fromRGB(220, 170, 255)
	kTitle.TextSize = 13
	kTitle.Font = Enum.Font.GothamBold
	kTitle.Parent = KeyFrame

	local kBox = Instance.new("TextBox")
	kBox.Size = UDim2.new(1, -40, 0, 40)
	kBox.Position = UDim2.new(0, 20, 0, 65)
	kBox.BackgroundColor3 = Color3.fromRGB(26, 16, 42)
	kBox.PlaceholderText = "Cole sua key (24h ou VIP) aqui..."
	kBox.Text = ""
	kBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	kBox.PlaceholderColor3 = Color3.fromRGB(140, 110, 180)
	kBox.TextSize = 12
	kBox.Font = Enum.Font.GothamMedium
	kBox.Parent = KeyFrame

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 8)
	bCorner.Parent = kBox

	local verifyBtn = Instance.new("TextButton")
	verifyBtn.Size = UDim2.new(1, -40, 0, 38)
	verifyBtn.Position = UDim2.new(0, 20, 0, 115)
	verifyBtn.BackgroundColor3 = Color3.fromRGB(130, 40, 220)
	verifyBtn.Text = "VERIFICAR KEY E ENTRAR"
	verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	verifyBtn.TextSize = 13
	verifyBtn.Font = Enum.Font.GothamBold
	verifyBtn.Parent = KeyFrame

	local vCorner = Instance.new("UICorner")
	vCorner.CornerRadius = UDim.new(0, 8)
	vCorner.Parent = verifyBtn

	local copyBtn = Instance.new("TextButton")
	copyBtn.Size = UDim2.new(1, -40, 0, 35)
	copyBtn.Position = UDim2.new(0, 20, 0, 160)
	copyBtn.BackgroundColor3 = Color3.fromRGB(32, 18, 52)
	copyBtn.Text = "📋 COPIAR LINK DO SITE DE KEYS"
	copyBtn.TextColor3 = Color3.fromRGB(200, 160, 255)
	copyBtn.TextSize = 12
	copyBtn.Font = Enum.Font.GothamMedium
	copyBtn.Parent = KeyFrame

	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(0, 8)
	cCorner.Parent = copyBtn

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(1, 0, 0, 25)
	statusLbl.Position = UDim2.new(0, 0, 0, 215)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = "Gere sua chave de 24h no nosso site oficial."
	statusLbl.TextColor3 = Color3.fromRGB(170, 140, 210)
	statusLbl.TextSize = 11
	statusLbl.Font = Enum.Font.Gotham
	statusLbl.Parent = KeyFrame

	copyBtn.Activated:Connect(function()
		clickSound:Play()
		pcall(function() setclipboard("https://sombrioperseguidor-svg.github.io/zumbi-hub-key/") end)
		statusLbl.Text = "Link copiado para a área de transferência!"
		statusLbl.TextColor3 = Color3.fromRGB(160, 255, 160)
	end)

	verifyBtn.Activated:Connect(function()
		clickSound:Play()
		local enteredText = kBox.Text:gsub("%s+", "")
		if enteredText == "" then
			statusLbl.Text = "Por favor, digite a key!"
			statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
			return
		end
		saveKey(enteredText)
		statusLbl.Text = "Key Aprovada! Carregando Hub..."
		statusLbl.TextColor3 = Color3.fromRGB(160, 255, 160)
		task.wait(0.6)
		KeyGui:Destroy()
		ScreenGui.Enabled = true
	end)
end

-- =====================================================================
-- BOLINHA FLUTUANTE ROXA (Touch / Arrastável ⚽)
-- =====================================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 54, 0, 54)
ToggleBtn.Position = UDim2.new(0, 30, 0, 180)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 12, 38)
ToggleBtn.Text = "⚽"
ToggleBtn.TextSize = 26
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(1, 0)
tCorner.Parent = ToggleBtn

local tStroke = Instance.new("UIStroke")
tStroke.Color = Color3.fromRGB(160, 32, 240)
tStroke.Thickness = 2
tStroke.Parent = ToggleBtn

-- =====================================================================
-- JANELA PRINCIPAL DO HUB
-- =====================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 8, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 14)
mCorner.Parent = MainFrame

local mStroke = Instance.new("UIStroke")
mStroke.Color = Color3.fromRGB(160, 32, 240)
mStroke.Thickness = 2
mStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(24, 12, 38)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 280, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚽ ZOMBIE HUB — REMOTE EVENTS"
TitleLabel.TextColor3 = Color3.fromRGB(210, 150, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0, 180, 1, 0)
TimerLabel.Position = UDim2.new(1, -220, 0, 0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "Key: Calculando..."
TimerLabel.TextColor3 = Color3.fromRGB(180, 130, 240)
TimerLabel.TextSize = 11
TimerLabel.Font = Enum.Font.GothamMedium
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right
TimerLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 145, 1, -48)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 5, 18)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 400)
Sidebar.ScrollBarThickness = 3
Sidebar.Parent = MainFrame

local sLayout = Instance.new("UIListLayout")
sLayout.SortOrder = Enum.SortOrder.LayoutOrder
sLayout.Padding = UDim.new(0, 6)
sLayout.Parent = Sidebar

local ContainerHolder = Instance.new("Folder")
ContainerHolder.Parent = MainFrame

local tabs = {}
local function createTab(name, icon)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -10, 0, 36)
	tabBtn.Position = UDim2.new(0, 5, 0, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(22, 12, 36)
	tabBtn.Text = "  " .. icon .. " " .. name
	tabBtn.TextColor3 = Color3.fromRGB(190, 160, 220)
	tabBtn.TextSize = 12
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.Parent = Sidebar

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 8)
	bCorner.Parent = tabBtn

	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Size = UDim2.new(1, -155, 1, -52)
	contentFrame.Position = UDim2.new(0, 150, 0, 48)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Visible = false
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 950)
	contentFrame.ScrollBarThickness = 4
	contentFrame.Parent = ContainerHolder

	local cLayout = Instance.new("UIListLayout")
	cLayout.SortOrder = Enum.SortOrder.LayoutOrder
	cLayout.Padding = UDim.new(0, 8)
	cLayout.Parent = contentFrame

	tabBtn.Activated:Connect(function()
		clickSound:Play()
		for _, t in pairs(tabs) do
			t.btn.BackgroundColor3 = Color3.fromRGB(22, 12, 36)
			t.btn.TextColor3 = Color3.fromRGB(190, 160, 220)
			t.frame.Visible = false
		end
		tabBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 220)
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		contentFrame.Visible = true
	end)

	if #tabs == 0 then
		tabBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 220)
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		contentFrame.Visible = true
	end

	table.insert(tabs, {btn = tabBtn, frame = contentFrame})
	return contentFrame
end

local function addSection(tab, text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -10, 0, 25)
	lbl.BackgroundTransparency = 1
	lbl.Text = "  " .. text
	lbl.TextColor3 = Color3.fromRGB(200, 130, 255)
	lbl.TextSize = 12
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = tab
end

local function addButton(tab, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(40, 20, 70)
	btn.Text = "  " .. text
	btn.TextColor3 = Color3.fromRGB(230, 200, 255)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = tab

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	btn.Activated:Connect(function()
		clickSound:Play()
		callback()
	end)
end

local function addToggle(tab, text, callback)
	local tgl = Instance.new("TextButton")
	tgl.Size = UDim2.new(1, -10, 0, 34)
	tgl.BackgroundColor3 = Color3.fromRGB(24, 14, 40)
	tgl.Text = "  " .. text .. " [ OFF ]"
	tgl.TextColor3 = Color3.fromRGB(190, 170, 210)
	tgl.TextSize = 11
	tgl.Font = Enum.Font.GothamMedium
	tgl.TextXAlignment = Enum.TextXAlignment.Left
	tgl.Parent = tab

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = tgl

	local active = false
	tgl.Activated:Connect(function()
		clickSound:Play()
		active = not active
		tgl.Text = "  " .. text .. (active and " [ ON ]" or " [ OFF ]")
		tgl.TextColor3 = active and Color3.fromRGB(170, 255, 170) or Color3.fromRGB(190, 170, 210)
		tgl.BackgroundColor3 = active and Color3.fromRGB(60, 20, 100) or Color3.fromRGB(24, 14, 40)
		callback(active)
	end)
end

local function addTextBox(tab, placeholder, callback)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -10, 0, 34)
	box.BackgroundColor3 = Color3.fromRGB(24, 14, 40)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderColor3 = Color3.fromRGB(140, 120, 170)
	box.TextSize = 11
	box.Font = Enum.Font.GothamMedium
	box.Parent = tab

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = box

	box.FocusLost:Connect(function(enter)
		if enter then
			clickSound:Play()
			local num = tonumber(box.Text)
			if num then callback(num) end
		end
	end)
end

local function addSelector(tab, options, callback)
	local currentIdx = 1
	local selBtn = Instance.new("TextButton")
	selBtn.Size = UDim2.new(1, -10, 0, 34)
	selBtn.BackgroundColor3 = Color3.fromRGB(28, 16, 46)
	selBtn.Text = "  Modo de Curva: " .. options[currentIdx]
	selBtn.TextColor3 = Color3.fromRGB(210, 160, 255)
	selBtn.TextSize = 11
	selBtn.Font = Enum.Font.GothamMedium
	selBtn.TextXAlignment = Enum.TextXAlignment.Left
	selBtn.Parent = tab

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = selBtn

	selBtn.Activated:Connect(function()
		clickSound:Play()
		currentIdx = (currentIdx % #options) + 1
		selBtn.Text = "  Modo de Curva: " .. options[currentIdx]
		callback(options[currentIdx])
	end)
end

-- =====================================================================
-- ABAS DO HUB
-- =====================================================================
_G.CurveMode = "Direita"

local TabChutes = createTab("Chutes", "🎯")
addSection(TabChutes, "Ações Rápidas (Clique Único)")

-- Botões Rápidos
addButton(TabChutes, "🧲 Puxar Bola Mais Próxima para o Pé", function()
	local ball = getClosestBall()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if ball and root then
		ball.CFrame = root.CFrame + (root.CFrame.LookVector * 2) - Vector3.new(0, 2, 0)
		ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		fireGameRemote("dribble")
	end
end)

addButton(TabChutes, "📌 Puxar Bola Mais Próxima para a Cabeça", function()
	local ball = getClosestBall()
	local char = LocalPlayer.Character
	local head = char and char:FindFirstChild("Head")
	if ball and head then
		ball.CFrame = head.CFrame + Vector3.new(0, 3.5, 0)
		ball.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	end
end)

addSection(TabChutes, "Direção de Curva do Chute:")
addSelector(TabChutes, {"Direita", "Esquerda", "Reto"}, function(selected)
	_G.CurveMode = selected
end)

addToggle(TabChutes, "🌀 Ativar Curva nos Chutes (Eventos + Física)", function(val)
	_G.AutoCurve = val
	task.spawn(function()
		while _G.AutoCurve do
			pcall(function()
				local ball = getClosestBall()
				if ball and ball.AssemblyLinearVelocity.Magnitude > 8 then
					fireGameRemote("curve", _G.CurveMode)
					local currentVel = ball.AssemblyLinearVelocity
					if _G.CurveMode == "Direita" then
						ball.AssemblyLinearVelocity = currentVel + (Workspace.CurrentCamera.CFrame.RightVector * 4)
					elseif _G.CurveMode == "Esquerda" then
						ball.AssemblyLinearVelocity = currentVel - (Workspace.CurrentCamera.CFrame.RightVector * 4)
					elseif _G.CurveMode == "Reto" then
						local forward = Vector3.new(currentVel.X, 0, currentVel.Z).Unit
						ball.AssemblyLinearVelocity = (forward * currentVel.Magnitude) + Vector3.new(0, currentVel.Y, 0)
					end
				end
			end)
			task.wait(0.03)
		end
	end)
end)

addToggle(TabChutes, "⚡ Stamina Infinita (Profissional)", function(val)
	_G.InfiniteStamina = val
	task.spawn(function()
		while _G.InfiniteStamina do
			pcall(function()
				fireGameRemote("stamina", 100)
				for _, obj in ipairs(LocalPlayer:GetDescendants()) do
					local name = obj.Name:lower()
					if name:find("stamina") or name:find("energy") or name:find("vigor") then
						if obj:IsA("NumberValue") or obj:IsA("IntValue") then
							obj.Value = 100
						end
					end
				end
			end)
			task.wait(0.2)
		end
	end)
end)

local TabGoleiro = createTab("Goleiro", "🧤")
addSection(TabGoleiro, "Defesa Inviolável")

addToggle(TabGoleiro, "🧤 Auto Rebatida de Chutes", function(val)
	_G.AutoKeeper = val
	task.spawn(function()
		while _G.AutoKeeper do
			pcall(function()
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local ball = getClosestBall()
				if root and ball then
					local dist = (ball.Position - root.Position).Magnitude
					if dist < 25 then
						fireGameRemote("save")
						fireGameRemote("catch")
						ball.AssemblyLinearVelocity = (ball.Position - root.Position).Unit * 140 + Vector3.new(0, 45, 0)
						task.wait(0.2)
					end
				end
			end)
			task.wait(0.02)
		end
	end)
end)

local TabESP = createTab("ESP", "👀")
addSection(TabESP, "Rastreamento do Campo")

addToggle(TabESP, "⚽ ESP Bola de Futebol", function(val)
	_G.EspBall = val
	task.spawn(function()
		while _G.EspBall do
			pcall(function()
				local ball = getClosestBall()
				if ball and not ball:FindFirstChild("BallESP") then
					local bb = Instance.new("BillboardGui")
					bb.Name = "BallESP"
					bb.Size = UDim2.new(0, 80, 0, 25)
					bb.AlwaysOnTop = true
					bb.StudsOffset = Vector3.new(0, 2, 0)
					bb.Parent = ball

					local lbl = Instance.new("TextLabel")
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 1
					lbl.Text = "⚽ BOLA"
					lbl.TextColor3 = Color3.fromRGB(200, 120, 255)
					lbl.TextSize = 11
					lbl.Font = Enum.Font.GothamBold
					lbl.Parent = bb
				end
			end)
			task.wait(1.5)
		end
		local ball = getClosestBall()
		if ball and ball:FindFirstChild("BallESP") then ball.BallESP:Destroy() end
	end)
end)

local TabPlayers = createTab("Jogadores", "🏃‍♂️")
addSection(TabPlayers, "Atributos Físicos")

addSection(TabPlayers, "Velocidade de Corrida:")
addTextBox(TabPlayers, "Ex: 26 (Padrão 16)", function(v)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = v end
end)

addSection(TabPlayers, "Altura do Pulo:")
addTextBox(TabPlayers, "Ex: 85 (Padrão 50)", function(v)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.JumpPower = v end
end)

task.spawn(function()
	while true do
		local left = getRemainingTime()
		TimerLabel.Text = "Key: " .. formatTime(left)
		task.wait(1)
	end
end)

-- =====================================================================
-- CONTROLE E ANIMAÇÕES
-- =====================================================================
local isOpen = false
local function toggleUI()
	clickSound:Play()
	isOpen = not isOpen
	if isOpen then
		MainFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
			Size = UDim2.new(0, 620, 0, 420),
			Position = UDim2.new(0.5, -310, 0.5, -210)
		}):Play()
	else
		local tw = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tw:Play()
		tw.Completed:Connect(function() if not isOpen then MainFrame.Visible = false end end)
	end
end

ToggleBtn.Activated:Connect(toggleUI)
CloseBtn.Activated:Connect(toggleUI)

-- Arrastar bolinha flutuante
local dragging, dragStart, startPos
ToggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = ToggleBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

print("Zombie Hub Remote Events Edition Loaded! ⚽💜")
