-- Voice TTS + AI Chat (HTTP Version)
print("[VoiceTTS] Iniciando...")

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Habilita HttpService
local success, err = pcall(function()
    HttpService.HttpEnabled = true
end)

if not success then
    warn("[VoiceTTS] Aviso: HttpService pode estar bloqueado")
end

local SERVER_URL = "http://localhost:5000"

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
MainFrame.Size = UDim2.new(0, 220, 0, 520)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 3

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

local function createSimpleButton(name, yPos)
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
    
    return btn
end

local function createModeButton(name, xPos, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Position = UDim2.new(0, xPos, 0, yPos)
    btn.Size = UDim2.new(0, 95, 0, 30)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    indicator.Position = UDim2.new(1, -20, 0.5, -6)
    indicator.Size = UDim2.new(0, 12, 0, 12)
    indicator.BorderSizePixel = 0
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    return btn, indicator
end

-- Voice TTS Input
local voiceInputBox = Instance.new("TextBox")
voiceInputBox.Parent = MainFrame
voiceInputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
voiceInputBox.Position = UDim2.new(0, 10, 0, 50)
voiceInputBox.Size = UDim2.new(0, 200, 0, 30)
voiceInputBox.Font = Enum.Font.Gotham
voiceInputBox.PlaceholderText = "Digite para falar..."
voiceInputBox.Text = ""
voiceInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
voiceInputBox.TextSize = 12
voiceInputBox.ClearTextOnFocus = false

local voiceInputCorner = Instance.new("UICorner")
voiceInputCorner.CornerRadius = UDim.new(0, 6)
voiceInputCorner.Parent = voiceInputBox

local voiceSendBtn = createSimpleButton("Falar", 90)

local allChatBtn, allChatIndicator = createButton("All Chat TTS", 0, 135)
local filaBtn, filaIndicator = createModeButton("Fila", 10, 180)
local newBtn, newIndicator = createModeButton("New", 115, 180)
local aiChatBtn, aiChatIndicator = createButton("AI Chat", 0, 270)

-- AI Input TextBox
local aiInputBox = Instance.new("TextBox")
aiInputBox.Parent = MainFrame
aiInputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aiInputBox.Position = UDim2.new(0, 10, 0, 315)
aiInputBox.Size = UDim2.new(0, 200, 0, 30)
aiInputBox.Font = Enum.Font.Gotham
aiInputBox.PlaceholderText = "Pergunte algo..."
aiInputBox.Text = ""
aiInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
aiInputBox.TextSize = 12
aiInputBox.ClearTextOnFocus = false

local aiInputCorner = Instance.new("UICorner")
aiInputCorner.CornerRadius = UDim.new(0, 6)
aiInputCorner.Parent = aiInputBox

local aiSendBtn = Instance.new("TextButton")
aiSendBtn.Parent = MainFrame
aiSendBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
aiSendBtn.Position = UDim2.new(0, 10, 0, 355)
aiSendBtn.Size = UDim2.new(0, 200, 0, 30)
aiSendBtn.Font = Enum.Font.GothamBold
aiSendBtn.Text = "Enviar para IA"
aiSendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aiSendBtn.TextSize = 13

local aiSendCorner = Instance.new("UICorner")
aiSendCorner.CornerRadius = UDim.new(0, 6)
aiSendCorner.Parent = aiSendBtn

-- Music Controls
local musicBtn, musicIndicator = createButton("Música YouTube", 0, 395)

local musicInputBox = Instance.new("TextBox")
musicInputBox.Parent = MainFrame
musicInputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
musicInputBox.Position = UDim2.new(0, 10, 0, 440)
musicInputBox.Size = UDim2.new(0, 200, 0, 30)
musicInputBox.Font = Enum.Font.Gotham
musicInputBox.PlaceholderText = "Nome da música..."
musicInputBox.Text = ""
musicInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
musicInputBox.TextSize = 12
musicInputBox.ClearTextOnFocus = false

local musicInputCorner = Instance.new("UICorner")
musicInputCorner.CornerRadius = UDim.new(0, 6)
musicInputCorner.Parent = musicInputBox

local musicPlayBtn = Instance.new("TextButton")
musicPlayBtn.Parent = MainFrame
musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
musicPlayBtn.Position = UDim2.new(0, 10, 0, 480)
musicPlayBtn.Size = UDim2.new(0, 200, 0, 30)
musicPlayBtn.Font = Enum.Font.GothamBold
musicPlayBtn.Text = "Tocar"
musicPlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
musicPlayBtn.TextSize = 13

local musicPlayCorner = Instance.new("UICorner")
musicPlayCorner.CornerRadius = UDim.new(0, 6)
musicPlayCorner.Parent = musicPlayBtn

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = MainFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 10, 0, 215)
speedLabel.Size = UDim2.new(0, 200, 0, 15)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Velocidade: 1.0x"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedTrack = Instance.new("Frame")
speedTrack.Parent = MainFrame
speedTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedTrack.Position = UDim2.new(0, 10, 0, 235)
speedTrack.Size = UDim2.new(0, 200, 0, 6)
speedTrack.BorderSizePixel = 0

local speedTrackCorner = Instance.new("UICorner")
speedTrackCorner.CornerRadius = UDim.new(1, 0)
speedTrackCorner.Parent = speedTrack

local speedHandle = Instance.new("Frame")
speedHandle.Parent = speedTrack
speedHandle.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
speedHandle.Position = UDim2.new(0, 0, 0.5, -8)
speedHandle.Size = UDim2.new(0, 16, 0, 16)
speedHandle.BorderSizePixel = 0

local speedHandleCorner = Instance.new("UICorner")
speedHandleCorner.CornerRadius = UDim.new(1, 0)
speedHandleCorner.Parent = speedHandle

-- Variables
local allChatEnabled = false
local aiChatEnabled = false
local aiProcessing = false
local PROXIMITY_DISTANCE = 50
local ttsSpeed = 1.0
local musicEnabled = false
local musicPlaying = false

-- Queue System
local queueMode = true
local messageQueue = {}
local isProcessingQueue = false
local currentTTSId = 0
local isPlayingNew = false

-- Speed Slider Logic
local speedDragging = false

speedHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if speedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local trackPos = speedTrack.AbsolutePosition.X
        local trackSize = speedTrack.AbsoluteSize.X
        local relativePos = math.clamp(mousePos.X - trackPos, 0, trackSize)
        local percentage = relativePos / trackSize
        
        ttsSpeed = 1.0 + (percentage * 1.5)
        speedHandle.Position = UDim2.new(percentage, 0, 0.5, -8)
        speedLabel.Text = string.format("Velocidade: %.1fx", ttsSpeed)
        
        task.spawn(function()
            pcall(function()
                request({
                    Url = SERVER_URL .. "/speed",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({speed = ttsSpeed})
                })
            end)
        end)
    end
end)

-- HTTP Functions
local function sendTTS(text, ttsId, priority)
    print("[DEBUG] Enviando TTS:", text, "ID:", ttsId, "Prioridade:", priority)
    task.spawn(function()
        local success, result = pcall(function()
            local response = request({
                Url = SERVER_URL .. "/tts",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({text = text, priority = priority, speed = ttsSpeed})
            })
            return response
        end)
        if success then
            print("[TTS] Sucesso! ID:", ttsId)
        else
            warn("[TTS] Erro:", result)
        end
    end)
end

local function processNewMode()
    if isPlayingNew then return end
    isPlayingNew = true
    
    task.spawn(function()
        while #messageQueue > 0 and allChatEnabled and not queueMode and not aiProcessing do
            local msg = messageQueue[#messageQueue]
            messageQueue = {}
            
            sendTTS(msg.text, msg.id, "low")
            
            local textLength = #msg.text
            local waitTime = math.max(5, textLength * 0.08)
            print("[NEW] Aguardando", waitTime, "segundos")
            task.wait(waitTime)
            
            while aiProcessing do
                print("[NEW] Pausada - IA falando")
                task.wait(1)
            end
        end
        isPlayingNew = false
    end)
end

local function processQueue()
    if isProcessingQueue then return end
    isProcessingQueue = true
    
    task.spawn(function()
        while #messageQueue > 0 and allChatEnabled and queueMode and not aiProcessing do
            local msg = table.remove(messageQueue, 1)
            sendTTS(msg.text, msg.id, "low")
            
            local textLength = #msg.text
            local waitTime = math.max(5, textLength * 0.08)
            print("[FILA] Aguardando", waitTime, "segundos")
            task.wait(waitTime)
            
            while aiProcessing do
                print("[FILA] Pausada - IA falando")
                task.wait(1)
            end
        end
        isProcessingQueue = false
    end)
end

local function handleTTS(text, priority)
    currentTTSId = currentTTSId + 1
    local ttsId = currentTTSId
    
    if priority == "high" then
        print("[VOICE TTS] Prioridade alta - limpando fila antiga")
        messageQueue = {}
        isProcessingQueue = false
        isPlayingNew = false
        sendTTS(text, ttsId, "high")
        
        task.spawn(function()
            task.wait(5)
            if allChatEnabled then
                if queueMode then
                    print("[FILA] Iniciando nova fila do zero")
                    processQueue()
                else
                    print("[NEW] Reiniciando modo New")
                    processNewMode()
                end
            end
        end)
    elseif queueMode then
        table.insert(messageQueue, {text = text, id = ttsId})
        print("[FILA] Adicionado:", text, "| Total:", #messageQueue)
        processQueue()
    else
        messageQueue = {{text = text, id = ttsId}}
        print("[NEW] Substituindo por:", text)
        processNewMode()
    end
end

local function sendAI(question, playerName)
    if not aiChatEnabled then
        print("[AI] Chat desativado")
        return
    end
    
    if aiProcessing then return end
    aiProcessing = true
    
    print("[AI] Limpando fila antiga do All Chat TTS")
    messageQueue = {}
    isProcessingQueue = false
    isPlayingNew = false
    
    task.spawn(function()
        local success, result = pcall(function()
            local response = request({
                Url = SERVER_URL .. "/ai",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({question = question, player = playerName, ai_enabled = aiChatEnabled})
            })
            return response
        end)
        
        task.wait(2)
        aiProcessing = false
        print("[AI] Iniciando nova fila do All Chat TTS")
        
        if not success then
            warn("[AI] Erro:", result)
        else
            print("[AI] Resposta enviada")
            if allChatEnabled then
                if queueMode then
                    processQueue()
                else
                    processNewMode()
                end
            end
        end
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

-- Music Functions
local function searchMusic(query)
    task.spawn(function()
        local success, result = pcall(function()
            return request({
                Url = SERVER_URL .. "/music/search",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({query = query})
            })
        end)
        
        if success and result then
            local data = HttpService:JSONDecode(result.Body)
            if data.found then
                print("[MUSIC] Encontrada:", data.title)
            else
                print("[MUSIC] Não encontrada")
            end
        end
    end)
end

local function stopMusic()
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/music/stop",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({})
            })
        end)
    end)
end

-- Button Events
voiceSendBtn.MouseButton1Click:Connect(function()
    local text = voiceInputBox.Text
    if text == "" or #text < 1 then
        print("[Voice TTS] Texto vazio")
        return
    end
    
    print("[Voice TTS] Enviando:", text)
    voiceInputBox.Text = ""
    
    -- Pausa All Chat TTS
    messageQueue = {}
    isProcessingQueue = false
    isPlayingNew = false
    
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/stop",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({action = "stop"})
            })
        end)
        task.wait(0.3)
        handleTTS(text, "high")
    end)
end)

filaBtn.MouseButton1Click:Connect(function()
    if not queueMode then
        queueMode = true
        filaIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("[MODO] Fila ativado")
    end
end)

newBtn.MouseButton1Click:Connect(function()
    if queueMode then
        queueMode = false
        messageQueue = {}
        isProcessingQueue = false
        isPlayingNew = false
        filaIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        print("[MODO] New ativado")
    end
end)

allChatBtn.MouseButton1Click:Connect(function()
    allChatEnabled = not allChatEnabled
    allChatIndicator.BackgroundColor3 = allChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    if allChatEnabled then
        queueMode = true
        filaIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("[All Chat] Ativado - Iniciando fila nova")
    else
        messageQueue = {}
        isProcessingQueue = false
        isPlayingNew = false
        filaIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        newIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("[All Chat] Desativado - Parando voz instantaneamente")
        
        task.spawn(function()
            pcall(function()
                request({
                    Url = SERVER_URL .. "/stop",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({action = "stop"})
                })
            end)
        end)
    end
    
    print("[All Chat]", allChatEnabled and "Ativado" or "Desativado")
end)

aiChatBtn.MouseButton1Click:Connect(function()
    aiChatEnabled = not aiChatEnabled
    aiChatIndicator.BackgroundColor3 = aiChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    -- Se desativar AI Chat, para a IA imediatamente
    if not aiChatEnabled and aiProcessing then
        aiProcessing = false
        task.spawn(function()
            pcall(function()
                request({
                    Url = SERVER_URL .. "/stop",
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode({action = "stop"})
                })
            end)
        end)
        print("[AI] Desativado - Interrompendo fala")
    end
    
    print("[AI]", aiChatEnabled and "Ativado" or "Desativado")
end)

aiSendBtn.MouseButton1Click:Connect(function()
    if not aiChatEnabled then
        print("[AI] Chat desativado - Ative primeiro")
        return
    end
    
    local question = aiInputBox.Text
    if question == "" or #question < 2 then
        print("[AI] Pergunta muito curta")
        return
    end
    
    print("[AI] Enviando pergunta direta:", question)
    aiInputBox.Text = ""
    sendAI(question, player.DisplayName)
end)

rejoinBtn.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

-- Music Button Events
musicBtn.MouseButton1Click:Connect(function()
    musicEnabled = not musicEnabled
    musicIndicator.BackgroundColor3 = musicEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/music/toggle",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({})
            })
        end)
    end)
    
    print("[MUSIC]", musicEnabled and "Ativado" or "Desativado")
end)

musicPlayBtn.MouseButton1Click:Connect(function()
    if not musicEnabled then
        print("[MUSIC] Sistema desativado")
        return
    end
    
    if musicPlaying then
        -- Interromper
        musicPlaying = false
        musicPlayBtn.Text = "Tocar"
        musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
        stopMusic()
        print("[MUSIC] Parado")
    else
        -- Tocar
        local query = musicInputBox.Text
        if query == "" or #query < 2 then
            print("[MUSIC] Nome muito curto")
            return
        end
        
        musicPlaying = true
        musicPlayBtn.Text = "Interromper"
        musicPlayBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        searchMusic(query)
        print("[MUSIC] Buscando:", query)
    end
end)

local function setupPlayerChat(plr)
    if plr == player then return end
    
    plr.Chatted:Connect(function(message)
        print("[DEBUG] Player", plr.DisplayName, "falou:", message)
        
        -- Detecta comando "tocar"
        local lowerMsg = message:lower()
        if musicEnabled and lowerMsg:sub(1, 5) == "tocar" then
            local songName = message:sub(7)
            if #songName > 0 then
                print("[MUSIC] Comando detectado:", songName)
                searchMusic(songName)
                return
            end
        end
        
        local isNearby = isPlayerNearby(plr)
        local isQuestion = message:sub(-1) == "?"
        
        if aiChatEnabled and isNearby and isQuestion then
            print("[DEBUG] Enviando para IA")
            sendAI(message, plr.DisplayName)
            return
        end
        
        if allChatEnabled and not aiProcessing then
            local textToSpeak = plr.DisplayName .. " falou " .. message
            print("[DEBUG] Falando:", textToSpeak)
            handleTTS(textToSpeak, "low")
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

print("[VoiceTTS + AI] Carregado! Z=Menu | Server:", SERVER_URL)
