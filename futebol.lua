-- =====================================================================
-- ZOMBIE HUB | PROFISSIONAL DE FUTEBOL DE RUA (CHUTES & HABILIDADES) ⚽
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local keyFileName = "zombie_hub_football_key.txt"
local vipKey = "ZUMBI-KEY-5592-VIP"
local studioExpireTime = 0

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
	if key == vipKey then
		return 999999999 -- Acesso VIP ilimitado
	end
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

if PlayerGui:FindFirstChild("ZombieHubFootballMain") then PlayerGui.ZombieHubFootballMain:Destroy() end
if PlayerGui:FindFirstChild("ZombieHubKey") then PlayerGui.ZombieHubKey:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZombieHubFootballMain"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9114220745"
clickSound.Volume = 0.5
clickSound.Parent = ScreenGui

-- =====================================================================
-- TELA DE KEY (24h e VIP)
-- =====================================================================
local hasKey = getRemainingTime() > 0
ScreenGui.Enabled = hasKey

if not hasKey then
	local KeyGui = Instance.new("ScreenGui")
	KeyGui.Name = "ZombieHubKey"
	KeyGui.Parent = PlayerGui
	KeyGui.ResetOnSpawn = false

	local KeyFrame = Instance.new("Frame")
	KeyFrame.Size = UDim2.new(0, 420, 0, 260)
	KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
	KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 10, 28)
	KeyFrame.BorderSizePixel = 0
	KeyFrame.Parent = KeyGui

	local kCorner = Instance.new("UICorner")
	kCorner.CornerRadius = UDim.new(0, 12)
	kCorner.Parent = KeyFrame

	local kStroke = Instance.new("UIStroke")
	kStroke.Color = Color3.fromRGB(0, 255, 120)
	kStroke.Thickness = 1.5
	kStroke.Parent = KeyFrame

	local kTitle = Instance.new("TextLabel")
	kTitle.Size = UDim2.new(1, 0, 0, 45)
	kTitle.BackgroundTransparency = 1
	kTitle.Text = "🔑 Zombie Hub - Verificação de Key (24h / VIP)"
	kTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	kTitle.TextSize = 14
	kTitle.Font = Enum.Font.GothamBold
	kTitle.Parent = KeyFrame

	local kBox = Instance.new("TextBox")
	kBox.Size = UDim2.new(1, -40, 0, 40)
	kBox.Position = UDim2.new(0, 20, 0, 65)
	kBox.BackgroundColor3 = Color3.fromRGB(28, 16, 42)
	kBox.PlaceholderText = "Cole sua key aqui..."
	kBox.Text = ""
	kBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	kBox.PlaceholderColor3 = Color3.fromRGB(150, 130, 180)
	kBox.TextSize = 13
	kBox.Font = Enum.Font.GothamMedium
	kBox.Parent = KeyFrame

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 8)
	bCorner.Parent = kBox

	local verifyBtn = Instance.new("TextButton")
	verifyBtn.Size = UDim2.new(1, -40, 0, 38)
	verifyBtn.Position = UDim2.new(0, 20, 0, 115)
	verifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
	verifyBtn.Text = "Verificar Key e Entrar"
	verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	verifyBtn.TextSize = 14
	verifyBtn.Font = Enum.Font.GothamBold
	verifyBtn.Parent = KeyFrame

	local vCorner = Instance.new("UICorner")
	vCorner.CornerRadius = UDim.new(0, 8)
	vCorner.Parent = verifyBtn

	local copyBtn = Instance.new("TextButton")
	copyBtn.Size = UDim2.new(1, -40, 0, 35)
	copyBtn.Position = UDim2.new(0, 20, 0, 160)
	copyBtn.BackgroundColor3 = Color3.fromRGB(30, 18, 48)
	copyBtn.Text = "📋 Copiar Link da Key"
	copyBtn.TextColor3 = Color3.fromRGB(180, 255, 200)
	copyBtn.TextSize = 13
	copyBtn.Font = Enum.Font.GothamMedium
	copyBtn.Parent = KeyFrame

	local cCorner = Instance.new("UICorner")
	cCorner.CornerRadius = UDim.new(0, 8)
	cCorner.Parent = copyBtn

	local statusLbl = Instance.new("TextLabel")
	statusLbl.Size = UDim2.new(1, 0, 0, 25)
	statusLbl.Position = UDim2.new(0, 0, 0, 210)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = "Acesse o site para gerar sua chave gratuita."
	statusLbl.TextColor3 = Color3.fromRGB(160, 140, 190)
	statusLbl.TextSize = 11
	statusLbl.Font = Enum.Font.Gotham
	statusLbl.Parent = KeyFrame

	copyBtn.MouseButton1Click:Connect(function()
		clickSound:Play()
		pcall(function() setclipboard("https://sombrioperseguidor-svg.github.io/zumbi-hub-key/") end)
		statusLbl.Text = "Link copiado!"
		statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
	end)

	verifyBtn.MouseButton1Click:Connect(function()
		clickSound:Play()
		local enteredText = kBox.Text:gsub("%s+", "")
		if enteredText == "" then
			statusLbl.Text = "Digite a key!"
			statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
			return
		end
		saveKey(enteredText)
		if enteredText == vipKey then
			statusLbl.Text = "Key VIP Aprovada!"
		else
			statusLbl.Text = "Key Aprovada!"
		end
		statusLbl.TextColor3 = Color3.fromRGB(0, 255, 100)
		task.wait(0.6)
		KeyGui:Destroy()
		ScreenGui.Enabled = true
	end)
end

-- =====================================================================
-- BOLINHA FLUTUANTE (Arrastável ⚽)
-- =====================================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 30, 0, 180)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 15, 38)
ToggleBtn.Text = "⚽"
ToggleBtn.TextSize = 26
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(1, 0)
tCorner.Parent = ToggleBtn

local tStroke = Instance.new("UIStroke")
tStroke.Color = Color3.fromRGB(0, 255, 120)
tStroke.Thickness = 2
tStroke.Parent = ToggleBtn

-- =====================================================================
-- JANELA PRINCIPAL
-- =====================================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 620, 0, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local mCorner = Instance.new("UICorner")
mCorner.CornerRadius = UDim.new(0, 12)
mCorner.Parent = MainFrame

local mStroke = Instance.new("UIStroke")
mStroke.Color = Color3.fromRGB(0, 255, 120)
mStroke.Thickness = 1.5
mStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 14, 38)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 12)
tbCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -150, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚽ Zombie Hub - Futebol de Rua (Chutes & Maestria)"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0, 6)
cCorner.Parent = CloseBtn

-- Sidebar de Abas
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 145, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 6, 20)
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 400)
Sidebar.ScrollBarThickness = 3
Sidebar.Parent = MainFrame

local sLayout = Instance.new("UIListLayout")
sLayout.SortOrder = Enum.SortOrder.LayoutOrder
sLayout.Padding = UDim.new(0, 5)
sLayout.Parent = Sidebar

local ContainerHolder = Instance.new("Folder")
ContainerHolder.Parent = MainFrame

local tabs = {}
local function createTab(name, icon)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -10, 0, 35)
	tabBtn.Position = UDim2.new(0, 5, 0, 0)
	tabBtn.BackgroundColor3 = Color3.fromRGB(24, 13, 38)
	tabBtn.Text = "  " .. icon .. " " .. name
	tabBtn.TextColor3 = Color3.fromRGB(200, 180, 220)
	tabBtn.TextSize = 13
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.Parent = Sidebar

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 6)
	bCorner.Parent = tabBtn

	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Size = UDim2.new(1, -155, 1, -50)
	contentFrame.Position = UDim2.new(0, 150, 0, 46)
	contentFrame.BackgroundTransparency = 1
	contentFrame.Visible = false
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
	contentFrame.ScrollBarThickness = 4
	contentFrame.Parent = ContainerHolder

	local cLayout = Instance.new("UIListLayout")
	cLayout.SortOrder = Enum.SortOrder.LayoutOrder
	cLayout.Padding = UDim.new(0, 8)
	cLayout.Parent = contentFrame

	tabBtn.MouseButton1Click:Connect(function()
		clickSound:Play()
		for _, t in pairs(tabs) do
			t.btn.BackgroundColor3 = Color3.fromRGB(24, 13, 38)
			t.btn.TextColor3 = Color3.fromRGB(200, 180, 220)
			t.frame.Visible = false
		end
		tabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		contentFrame.Visible = true
	end)

	if #tabs == 0 then
		tabBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
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
	lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
	lbl.TextSize = 13
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = tab
end

local function addToggle(tab, text, callback)
	local tgl = Instance.new("TextButton")
	tgl.Size = UDim2.new(1, -10, 0, 32)
	tgl.BackgroundColor3 = Color3.fromRGB(26, 15, 42)
	tgl.Text = "  " .. text .. " [ OFF ]"
	tgl.TextColor3 = Color3.fromRGB(200, 180, 220)
	tgl.TextSize = 12
	tgl.Font = Enum.Font.GothamMedium
	tgl.TextXAlignment = Enum.TextXAlignment.Left
	tgl.Parent = tab

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = tgl

	local active = false
	tgl.MouseButton1Click:Connect(function()
		clickSound:Play()
		active = not active
		if active then
			tgl.Text = "  " .. text .. " [ ON ]"
			tgl.TextColor3 = Color3.fromRGB(0, 255, 100)
		else
			tgl.Text = "  " .. text .. " [ OFF ]"
			tgl.TextColor3 = Color3.fromRGB(200, 180, 220)
		end
		callback(active)
	end)
end

local function addButton(tab, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(26, 15, 42)
	btn.Text = "  " .. text
	btn.TextColor3 = Color3.fromRGB(220, 200, 255)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamMedium
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = tab

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		clickSound:Play()
		callback()
	end)
end

-- =====================================================================
-- CRIAÇÃO DAS ABAS
-- =====================================================================

-- 1. ABA CHUTES (Auto Curva + Auto Drible + Stamina Infinita + Auto Pênalti)
local TabChutes = createTab("Chutes", "🎯")
addSection(TabChutes, "Maestria de Chutes & Habilidades")

addToggle(TabChutes, "🌀 Auto Curva (Curva Acentuada)", function(val)
	_G.AutoCurve = val
	task.spawn(function()
		while _G.AutoCurve do
			pcall(function()
				for _, obj in ipairs(Workspace:GetDescendants()) do
					local lname = obj.Name:lower()
					if lname:find("ball") or lname:find("football") or lname:find("bola") then
						local ballPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
						if ballPart and ballPart.AssemblyLinearVelocity.Magnitude > 15 then
							ballPart.AssemblyAngularVelocity = ballPart.AssemblyAngularVelocity + Vector3.new(0, 35, 0)
						end
					end
				end
			end)
			task.wait(0.05)
		end
	end)
end)

addToggle(TabChutes, "🛡️ Auto Drible (Anti-Carrinho)", function(val)
	_G.AutoDribble = val
	task.spawn(function()
		while _G.AutoDribble do
			pcall(function()
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root then
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
							local pRoot = p.Character.HumanoidRootPart
							local dist = (pRoot.Position - root.Position).Magnitude
							if dist < 10 then
								VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
								task.wait(0.1)
								VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
								task.wait(0.5)
							end
						end
					end
				end
			end)
			task.wait(0.1)
		end
	end)
end)

addToggle(TabChutes, "⚡ Stamina Infinita", function(val)
	_G.InfiniteStamina = val
	task.spawn(function()
		while _G.InfiniteStamina do
			pcall(function()
				for _, obj in ipairs(LocalPlayer:GetDescendants()) do
					local name = obj.Name:lower()
					if name:find("stamina") or name:find("energy") or name:find("vigor") then
						if obj:IsA("NumberValue") or obj:IsA("IntValue") then
							obj.Value = 100
						end
					end
				end
				for _, obj in ipairs(PlayerGui:GetDescendants()) do
					local name = obj.Name:lower()
					if (name:find("stamina") or name:find("energy")) and (obj:IsA("NumberValue") or obj:IsA("IntValue")) then
						obj.Value = 100
					end
				end
			end)
			task.wait(0.2)
		end
	end)
end)

addToggle(TabChutes, "⚽ Auto Pênalti / Gol Instantâneo", function(val)
	_G.AutoPenalty = val
	task.spawn(function()
		while _G.AutoPenalty do
			pcall(function()
				for _, obj in ipairs(Workspace:GetDescendants()) do
					local lname = obj.Name:lower()
					if lname:find("ball") or lname:find("football") or lname:find("bola") then
						local ballPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
						if ballPart and ballPart.AssemblyLinearVelocity.Magnitude > 10 then
							for _, goalObj in ipairs(Workspace:GetDescendants()) do
								local gname = goalObj.Name:lower()
								if (gname:find("goal") or gname:find("net") or gname:find("rede") or gname:find("trave")) and (goalObj:IsA("BasePart") or goalObj:IsA("Model")) then
									local goalPart = goalObj:IsA("BasePart") and goalObj or (goalObj.PrimaryPart or goalObj:FindFirstChildWhichIsA("BasePart"))
									if goalPart then
										ballPart.CFrame = goalPart.CFrame + Vector3.new(0, 1, 0)
										ballPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
										break
									end
								end
							end
						end
					end
				end
			end)
			task.wait(0.1)
		end
	end)
end)

-- 2. ABA ESP (Bola, Jogadores e Gols)
local TabESP = createTab("ESP", "👀")
addSection(TabESP, "Rastreamento do Campo")

addToggle(TabESP, "⚽ ESP Bola de Futebol", function(val)
	_G.EspBall = val
	task.spawn(function()
		while _G.EspBall do
			pcall(function()
				for _, obj in ipairs(Workspace:GetDescendants()) do
					if obj.Name:lower():find("ball") or obj.Name:lower():find("football") or obj.Name:lower():find("bola") then
						local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
						if part and not part:FindFirstChild("BallESP") then
							local bb = Instance.new("BillboardGui")
							bb.Name = "BallESP"
							bb.Size = UDim2.new(0, 80, 0, 25)
							bb.AlwaysOnTop = true
							bb.StudsOffset = Vector3.new(0, 2, 0)
							bb.Parent = part

							local lbl = Instance.new("TextLabel")
							lbl.Size = UDim2.new(1, 0, 1, 0)
							lbl.BackgroundTransparency = 1
							lbl.Text = "⚽ BOLA"
							lbl.TextColor3 = Color3.fromRGB(0, 255, 100)
							lbl.TextSize = 11
							lbl.Font = Enum.Font.GothamBold
							lbl.Parent = bb
						end
					end
				end
			end)
			task.wait(1.5)
		end
		for _, obj in ipairs(Workspace:GetDescendants()) do
			local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
			if part and part:FindFirstChild("BallESP") then
				part.BallESP:Destroy()
			end
		end
	end)
end)

addToggle(TabESP, "🏃‍♂️ ESP Jogadores & Goleiro", function(val)
	_G.EspPlayers = val
	task.spawn(function()
		while _G.EspPlayers do
			pcall(function()
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("FootESP") then
						local hl = Instance.new("Highlight")
						hl.Name = "FootESP"
						hl.FillColor = Color3.fromRGB(0, 150, 255)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.Parent = p.Character
					end
				end
			end)
			task.wait(1)
		end
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character and p.Character:FindFirstChild("FootESP") then
				p.Character.FootESP:Destroy()
			end
		end
	end)
end)

-- 3. ABA JOGADORES (Velocidade, Pulo, Noclip & God Mode)
local TabPlayers = createTab("Jogadores", "🏃‍♂️")
addSection(TabPlayers, "Velocidade & Pulo")

local function addTextBox(tab, placeholder, callback)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -10, 0, 32)
	box.BackgroundColor3 = Color3.fromRGB(26, 15, 42)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderColor3 = Color3.fromRGB(150, 130, 180)
	box.TextSize = 12
	box.Font = Enum.Font.GothamMedium
	box.Parent = tab

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = box

	box.FocusLost:Connect(function(enter)
		if enter then
			clickSound:Play()
			local num = tonumber(box.Text)
			if num then callback(num) end
		end
	end)
end

addSection(TabPlayers, "Velocidade de Corrida (WalkSpeed):")
addTextBox(TabPlayers, "Ex: 28 (Padrão 16)", function(v)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = v end
end)

addSection(TabPlayers, "Altura do Pulo / Cabeceio (JumpPower):")
addTextBox(TabPlayers, "Ex: 90 (Padrão 50)", function(v)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.JumpPower = v end
end)

addSection(TabPlayers, "Utilitários")
addToggle(TabPlayers, "🛡️ God Mode (Imortalidade)", function(val)
	_G.GodMode = val
	task.spawn(function()
		while _G.GodMode and LocalPlayer.Character do
			pcall(function()
				local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if hum then hum.Health = hum.MaxHealth end
			end)
			task.wait(0.2)
		end
	end)
end)

addToggle(TabPlayers, "⚓ Anti-Void (Salvar se cair)", function(val)
	_G.AntiVoid = val
	task.spawn(function()
		while _G.AntiVoid and task.wait(0.5) do
			pcall(function()
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				if root and root.Position.Y < -50 then
					root.CFrame = CFrame.new(root.Position.X, 15, root.Position.Z)
				end
			end)
		end
	end)
end)

addToggle(TabPlayers, "Atravessar Barreiras (Noclip)", function(val)
	_G.Noclip = val
end)

RunService.Stepped:Connect(function()
	if _G.Noclip and LocalPlayer.Character then
		pcall(function()
			for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false end
			end
		end)
	end
end)

-- =====================================================================
-- ANIMAÇÕES E CONTROLES DE JANELA
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

ToggleBtn.MouseButton1Click:Connect(toggleUI)
CloseBtn.MouseButton1Click:Connect(toggleUI)

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

print("Zombie Hub - Futebol de Rua Carregado com Sucesso! ⚽")
