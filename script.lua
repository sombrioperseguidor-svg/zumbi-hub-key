-- =====================================================================
-- ZUMBI HUB - INTERFACE PRÓPRIA (CHAVE CORRIGIDA)
-- Criado por Zumbi3469
-- =====================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Remove interface anterior se já estiver aberta
if CoreGui:FindFirstChild("ZumbiHubCustomUI") then
    CoreGui.ZumbiHubCustomUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZumbiHubCustomUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Variáveis de controle de estado das funções
_G.AntiKillActive = false
_G.GodModeActive = false
_G.AutoLockDoors = false
_G.VoidKillerActive = false

local linkSiteOficial = "https://sombrioperseguidor-svg.github.io/zumbi-hub-key/"

-- =====================================================================
-- 1. TELA DE KEY (COM CHAVE CORRETA E BOTÃO DE COPIAR)
-- =====================================================================
local KeyScreen = Instance.new("Frame")
KeyScreen.Size = UDim2.new(0, 380, 0, 270)
KeyScreen.Position = UDim2.new(0.5, -190, 0.5, -135)
KeyScreen.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
KeyScreen.BorderSizePixel = 0
KeyScreen.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 12)
KeyCorner.Parent = KeyScreen

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "ZUMBI HUB | Acesso Restrito"
KeyTitle.TextColor3 = Color3.fromRGB(186, 85, 211)
KeyTitle.TextSize = 18
KeyTitle.Font = Enum.Font.SourceSansBold
KeyTitle.Parent = KeyScreen

local KeySub = Instance.new("TextLabel")
KeySub.Size = UDim2.new(1, 0, 0, 30)
KeySub.Position = UDim2.new(0, 0, 0, 35)
KeySub.BackgroundTransparency = 1
KeySub.Text = "Insira a chave obtida no site oficial:"
KeySub.TextColor3 = Color3.fromRGB(200, 200, 200)
KeySub.TextSize = 13
KeySub.Font = Enum.Font.SourceSans
KeySub.Parent = KeyScreen

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.85, 0, 0, 42)
KeyBox.Position = UDim2.new(0.075, 0, 0, 70)
KeyBox.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderText = "Cole sua key aqui..."
KeyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.SourceSans
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = KeyScreen

Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

-- Botão de Verificar Chave
local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 38)
SubmitBtn.Position = UDim2.new(0.075, 0, 0, 122)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Text = "Verificar Chave"
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.SourceSansBold
SubmitBtn.Parent = KeyScreen

Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

-- Botão Copiar Link do Site na Tela de Key
local CopyLinkBtn = Instance.new("TextButton")
CopyLinkBtn.Size = UDim2.new(0.85, 0, 0, 38)
CopyLinkBtn.Position = UDim2.new(0.075, 0, 0, 168)
CopyLinkBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
CopyLinkBtn.TextColor3 = Color3.fromRGB(186, 85, 211)
CopyLinkBtn.Text = "📋 Copiar Link do Site"
CopyLinkBtn.TextSize = 14
CopyLinkBtn.Font = Enum.Font.SourceSansBold
CopyLinkBtn.Parent = KeyScreen

Instance.new("UICorner", CopyLinkBtn).CornerRadius = UDim.new(0, 8)

CopyLinkBtn.MouseButton1Click:Connect(function()
    setclipboard(linkSiteOficial)
    CopyLinkBtn.Text = "✅ Link Copiado com Sucesso!"
    task.wait(2)
    CopyLinkBtn.Text = "📋 Copiar Link do Site"
end)

local LinkNote = Instance.new("TextLabel")
LinkNote.Size = UDim2.new(1, 0, 0, 25)
LinkNote.Position = UDim2.new(0, 0, 0, 215)
LinkNote.BackgroundTransparency = 1
LinkNote.Text = "Abra o navegador, cole o link e pegue sua key."
LinkNote.TextColor3 = Color3.fromRGB(130, 130, 130)
LinkNote.TextSize = 11
LinkNote.Font = Enum.Font.SourceSansItalic
LinkNote.Parent = KeyScreen

-- =====================================================================
-- 2. JANELA PRINCIPAL DO HUB
-- =====================================================================
local MainWindow = Instance.new("Frame")
MainWindow.Size = UDim2.new(0, 520, 0, 360)
MainWindow.Position = UDim2.new(0.5, -260, 0.5, -180)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 12, 22)
MainWindow.BorderSizePixel = 0
MainWindow.Visible = false
MainWindow.Parent = ScreenGui

Instance.new("UICorner", MainWindow).CornerRadius = UDim.new(0, 14)

-- Permitir arrastar a janela pela tela
local dragging, dragStart, startPos
MainWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainWindow.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- TopBar (Barra Superior)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainWindow

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(0.7, 0, 1, 0)
HubTitle.Position = UDim2.new(0.03, 0, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "Zumbi Hub 🔮 | Casa Sozinha"
HubTitle.TextColor3 = Color3.fromRGB(186, 85, 211)
HubTitle.TextSize = 16
HubTitle.Font = Enum.Font.SourceSansBold
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.93, 0, 0.15, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 55)
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Text = "X"
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = TopBar

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Menu Lateral (Abas)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundTransparency = 1
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 250)
Sidebar.ScrollBarThickness = 3
Sidebar.Parent = MainWindow

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -140, 1, -55)
ContentContainer.Position = UDim2.new(0, 135, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainWindow

local tabs = {}

local function createTabButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Text = name
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.LayoutOrder = order
    btn.Parent = Sidebar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 400)
    page.ScrollBarThickness = 4
    page.Parent = ContentContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = page

    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.page.Visible = false
            t.btn.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
            t.btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    table.insert(tabs, {btn = btn, page = page})
    if #tabs == 1 then
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    return page
end

local function createToggle(page, title, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.95, 0, 0, 38)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
    toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    toggleBtn.Text = title .. " [DESLIGADO]"
    toggleBtn.TextSize = 13
    toggleBtn.Font = Enum.Font.SourceSansBold
    toggleBtn.Parent = page

    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleBtn.Text = title .. " [LIGADO]"
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(10, 8, 15)
            toggleBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            toggleBtn.Text = title .. " [DESLIGADO]"
        end
        callback(active)
    end)
end

local function createButton(page, title, callback)
    local actionBtn = Instance.new("TextButton")
    actionBtn.Size = UDim2.new(0.95, 0, 0, 38)
    actionBtn.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
    actionBtn.TextColor3 = Color3.fromRGB(186, 85, 211)
    actionBtn.Text = title
    actionBtn.TextSize = 13
    actionBtn.Font = Enum.Font.SourceSansBold
    actionBtn.Parent = page

    Instance.new("UICorner", actionBtn).CornerRadius = UDim.new(0, 6)

    actionBtn.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- =====================================================================
-- ABAS DO HUB
-- =====================================================================

-- 1. ABA COMBATE & DEFESA
local CombatPage = createTabButton("⚔️ Combate", 1)
createToggle(CombatPage, "Plataforma Infinita (Anti-Kill)", function(state)
    local char = LocalPlayer.Character
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    if state then
        if rootPart and not workspace:FindFirstChild("AntiKillPlatform") then
            local platform = Instance.new("Part")
            platform.Name = "AntiKillPlatform"
            platform.Size = Vector3.new(25, 1, 25)
            platform.Position = rootPart.Position + Vector3.new(0, 180, 0)
            platform.Anchored = true
            platform.Transparency = 0.5
            platform.BrickColor = BrickColor.new("Dark stone grey")
            platform.Parent = workspace
            rootPart.CFrame = platform.CFrame + Vector3.new(0, 3, 0)
        end
    else
        local platform = workspace:FindFirstChild("AntiKillPlatform")
        if platform then platform:Destroy() end
    end
end)

createToggle(CombatPage, "God Mode (Vida Cheia)", function(state)
    _G.GodModeActive = state
    task.spawn(function()
        while _G.GodModeActive do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = hum.MaxHealth end
            task.wait(0.1)
        end
    end)
end)

-- 2. ABA PORTAS
local DoorsPage = createTabButton("🚪 Portas", 2)
createToggle(DoorsPage, "Auto Trancar Portas", function(state)
    _G.AutoLockDoors = state
    task.spawn(function()
        while _G.AutoLockDoors do
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and (string.lower(obj.ActionText):find("lock") or string.lower(obj.ActionText):find("trancar") or string.lower(obj.ObjectText):find("door") or string.lower(obj.Name):find("door")) then
                    pcall(function() fireproximityprompt(obj) end)
                end
            end
            task.wait(0.4)
        end
    end)
end)

-- 3. ABA ANTI-ASSASSINO (COM RADAR)
local AntiKillerPage = createTabButton("👻 Anti-Assassino", 3)
createToggle(AntiKillerPage, "Impedir Assassino (Void + Congelar)", function(state)
    _G.VoidKillerActive = state
    task.spawn(function()
        while _G.VoidKillerActive do
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                    local humanoid = v:FindFirstChildOfClass("Humanoid")
                    local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso")
                    if humanoid then pcall(function() humanoid.WalkSpeed = 0 end) end
                    if root then pcall(function() root.CFrame = CFrame.new(0, -9999, 0) end) end
                end
            end
            task.wait(0.3)
        end
    end)
end)

createButton(AntiKillerPage, "📡 Radar: Checar Assassino Atual", function()
    local detectedThreats = {}
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
            table.insert(detectedThreats, v.Name)
        end
    end
    local msg = #detectedThreats > 0 and ("Ameaça ativa: " .. table.concat(detectedThreats, ", ")) or "Nenhuma ameaça no mapa."
    
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0.1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    notif.TextColor3 = Color3.fromRGB(186, 85, 211)
    notif.Text = msg
    notif.TextSize = 13
    notif.Font = Enum.Font.SourceSansBold
    notif.Parent = ScreenGui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    task.delay(4, function() notif:Destroy() end)
end)

-- 4. ABA CRÉDITOS (COM SEU PERSONAGEM)
local CreditsPage = createTabButton("✨ Créditos", 4)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 80, 0, 80)
AvatarImage.Position = UDim2.new(0.5, -40, 0, 10)
AvatarImage.BackgroundColor3 = Color3.fromRGB(25, 20, 38)
AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
AvatarImage.Parent = CreditsPage
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

local CreditText = Instance.new("TextLabel")
CreditText.Size = UDim2.new(0.9, 0, 0, 80)
CreditText.Position = UDim2.new(0.05, 0, 0, 100)
CreditText.BackgroundTransparency = 1
CreditText.TextColor3 = Color3.fromRGB(220, 220, 220)
CreditText.Text = "Zumbi Hub - Versão Oficial\nCriador: Zumbi3469\nInterface Exclusiva Roxa e Preta"
CreditText.TextSize = 14
CreditText.Font = Enum.Font.SourceSansBold
CreditText.TextWrapped = true
CreditText.Parent = CreditsPage

createButton(CreditsPage, "📋 Copiar Link do Site", function()
    setclipboard(linkSiteOficial)
end)

-- =====================================================================
-- VERIFICAÇÃO DA KEY (AGORA USANDO A CHAVE ZUMBI-KEY-5592-VIP)
-- =====================================================================
SubmitBtn.MouseButton1Click:Connect(function()
    local senhaCorreta = "ZUMBI-KEY-5592-VIP"
    if KeyBox.Text == senhaCorreta then
        KeyScreen.Visible = false
        MainWindow.Visible = true
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "Chave incorreta! Tente novamente."
        KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
    end
end)
