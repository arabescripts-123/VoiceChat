-- Voice TTS + AI Chat
print("[VoiceTTS] Iniciando...")

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

pcall(function()
    if game.CoreGui:FindFirstChild("VoiceTTSGui") then
        game.CoreGui:FindFirstChild("VoiceTTSGui"):Destroy()
    end
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoiceTTSGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 230)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 3

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Voice TTS + AI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Active = true

-- Rejoin Button
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = MainFrame
rejoinBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
rejoinBtn.Position = UDim2.new(1, -40, 0, 5)
rejoinBtn.Size = UDim2.new(0, 35, 0, 30)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Text = "R"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.TextSize = 14

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 6)
rejoinCorner.Parent = rejoinBtn

-- Dragging
local dragging, dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Buttons
local function createButton(name, position, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    indicator.Position = UDim2.new(1, -25, 0.5, -8)
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.BorderSizePixel = 0
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    return btn, indicator
end

local ttsBtn, ttsIndicator = createButton("Voice TTS", 0, 50)
local allChatBtn, allChatIndicator = createButton("All Chat TTS", 0, 95)
local aiChatBtn, aiChatIndicator = createButton("AI Chat", 0, 140)

-- Variables
local ttsEnabled = false
local allChatEnabled = false
local aiChatEnabled = false
local aiProcessing = false
local messageQueue = {}
local spokenMessages = {}
local PROXIMITY_DISTANCE = 50

local function addToQueue(text)
    if spokenMessages[text] then return end
    table.insert(messageQueue, text)
    pcall(function()
        writefile("tts_message.txt", table.concat(messageQueue, "\n"))
    end)
end

local function clearQueue()
    messageQueue = {}
    spokenMessages = {}
    pcall(function()
        writefile("tts_message.txt", "")
    end)
end

local function isPlayerNearby(plr)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    return distance <= PROXIMITY_DISTANCE
end

local function askAI(question, playerName)
    if aiProcessing then return end
    aiProcessing = true
    
    print("[AI] Pergunta de", playerName, ":", question)
    
    pcall(function()
        writefile("ai_question.txt", playerName .. " perguntou: " .. question)
    end)
    
    spawn(function()
        wait(5)
        aiProcessing = false
    end)
end

-- Button Events
ttsBtn.MouseButton1Click:Connect(function()
    ttsEnabled = not ttsEnabled
    ttsIndicator.BackgroundColor3 = ttsEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    pcall(function()
        writefile("tts_enabled.txt", ttsEnabled and "1" or "0")
    end)
    if ttsEnabled then
        clearQueue()
        addToQueue("Oi Xexelento")
    else
        clearQueue()
    end
    print("[TTS]", ttsEnabled and "Ativado" or "Desativado")
end)

allChatBtn.MouseButton1Click:Connect(function()
    allChatEnabled = not allChatEnabled
    allChatIndicator.BackgroundColor3 = allChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    pcall(function()
        writefile("all_chat_enabled.txt", allChatEnabled and "1" or "0")
    end)
    clearQueue()
    print("[All Chat]", allChatEnabled and "Ativado" or "Desativado")
end)

aiChatBtn.MouseButton1Click:Connect(function()
    aiChatEnabled = not aiChatEnabled
    aiChatIndicator.BackgroundColor3 = aiChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    pcall(function()
        writefile("ai_enabled.txt", aiChatEnabled and "1" or "0")
    end)
    clearQueue()
    print("[AI]", aiChatEnabled and "Ativado" or "Desativado")
end)

rejoinBtn.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

-- Chat Events
player.Chatted:Connect(function(message)
    -- Prefixo /tts para falar sem aparecer no chat
    if message:sub(1, 5) == "/tts " then
        if ttsEnabled then
            local text = message:sub(6)
            print("[TTS] Você (privado):", text)
            clearQueue()
            addToQueue(text)
        end
        return
    end
    
    -- Voice TTS normal (aparece no chat)
    if not ttsEnabled then return end
    if message:sub(1, 1) == "/" then return end
    print("[TTS] Você:", message)
    clearQueue()
    addToQueue(message)
end)

local function setupPlayerChat(plr)
    if plr == player then return end
    
    plr.Chatted:Connect(function(message)
        -- Voice TTS tem prioridade (ignora All Chat)
        if ttsEnabled then
            print("[DEBUG] Ignorando All Chat - Voice TTS ativo")
            return
        end
        
        local isNearby = isPlayerNearby(plr)
        local isQuestion = message:sub(-1) == "?"
        
        -- AI Chat tem prioridade sobre All Chat
        if aiChatEnabled and isNearby and isQuestion then
            print("[AI] Detectou pergunta próxima!")
            clearQueue()
            askAI(message, plr.DisplayName)
            return
        end
        
        -- All Chat normal (só se não tiver Voice TTS ou AI processando)
        if allChatEnabled and not aiProcessing then
            addToQueue(plr.DisplayName .. " disse: " .. message)
        end
    end)
end

for _, plr in pairs(game.Players:GetPlayers()) do
    setupPlayerChat(plr)
end

game.Players.PlayerAdded:Connect(setupPlayerChat)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("[VoiceTTS + AI] Carregado! Z=Menu")
