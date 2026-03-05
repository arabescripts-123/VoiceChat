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
MainFrame.Size = UDim2.new(0, 220, 0, 400)
MainFrame.ClipsDescendants = true

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
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "Voice TTS + AI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Active = true

-- Tabs Container
local TabsFrame = Instance.new("Frame")
TabsFrame.Parent = MainFrame
TabsFrame.BackgroundTransparency = 1
TabsFrame.Position = UDim2.new(0, 0, 0, 35)
TabsFrame.Size = UDim2.new(1, 0, 0, 30)

local function createTab(name, pos)
    local tab = Instance.new("TextButton")
    tab.Parent = TabsFrame
    tab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab.Position = UDim2.new(0, pos, 0, 0)
    tab.Size = UDim2.new(0, 70, 0, 28)
    tab.Font = Enum.Font.Gotham
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.TextSize = 11
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tab
    return tab
end

local tab1 = createTab("Chat", 5)
local tab2 = createTab("Chat IA", 77)
local tab3 = createTab("Música", 149)

-- Content Frames
local Content1 = Instance.new("Frame")
Content1.Parent = MainFrame
Content1.BackgroundTransparency = 1
Content1.Position = UDim2.new(0, 0, 0, 70)
Content1.Size = UDim2.new(1, 0, 1, -70)
Content1.Visible = true

local Content2 = Instance.new("Frame")
Content2.Parent = MainFrame
Content2.BackgroundTransparency = 1
Content2.Position = UDim2.new(0, 0, 0, 70)
Content2.Size = UDim2.new(1, 0, 1, -70)
Content2.Visible = false

local Content3 = Instance.new("Frame")
Content3.Parent = MainFrame
Content3.BackgroundTransparency = 1
Content3.Position = UDim2.new(0, 0, 0, 70)
Content3.Size = UDim2.new(1, 0, 1, -70)
Content3.Visible = false

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = MainFrame
rejoinBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
rejoinBtn.Position = UDim2.new(1, -35, 0, 3)
rejoinBtn.Size = UDim2.new(0, 30, 0, 28)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Text = "R"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.TextSize = 14

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 6)
rejoinCorner.Parent = rejoinBtn

local infoBtn = Instance.new("TextButton")
infoBtn.Parent = MainFrame
infoBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
infoBtn.Position = UDim2.new(1, -70, 0, 3)
infoBtn.Size = UDim2.new(0, 30, 0, 28)
infoBtn.Font = Enum.Font.GothamBold
infoBtn.Text = "!"
infoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
infoBtn.TextSize = 16

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 6)
infoCorner.Parent = infoBtn

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
local function createButton(name, parent, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
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

local function createSimpleButton(name, parent, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
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

local function createModeButton(name, parent, xPos, yPos)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
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

-- ABA 1: CHAT
local voiceInputBox = Instance.new("TextBox")
voiceInputBox.Parent = Content1
voiceInputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
voiceInputBox.Position = UDim2.new(0, 10, 0, 5)
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

local voiceSendBtn = createSimpleButton("Falar", Content1, 40)

local allChatBtn, allChatIndicator = createButton("All Chat TTS", Content1, 85)
local filaBtn, filaIndicator = createModeButton("Fila", Content1, 10, 130)
local newBtn, newIndicator = createModeButton("New", Content1, 115, 130)

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = Content1
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 10, 0, 170)
speedLabel.Size = UDim2.new(0, 200, 0, 15)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Velocidade: 1.0x"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextSize = 11
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedTrack = Instance.new("Frame")
speedTrack.Parent = Content1
speedTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedTrack.Position = UDim2.new(0, 10, 0, 190)
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

-- ABA 2: CHAT IA
local aiChatBtn, aiChatIndicator = createButton("AI Chat", Content2, 5)

local aiInputBox = Instance.new("TextBox")
aiInputBox.Parent = Content2
aiInputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aiInputBox.Position = UDim2.new(0, 10, 0, 50)
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
aiSendBtn.Parent = Content2
aiSendBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
aiSendBtn.Position = UDim2.new(0, 10, 0, 90)
aiSendBtn.Size = UDim2.new(0, 200, 0, 30)
aiSendBtn.Font = Enum.Font.GothamBold
aiSendBtn.Text = "Enviar para IA"
aiSendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aiSendBtn.TextSize = 13

local aiSendCorner = Instance.new("UICorner")
aiSendCorner.CornerRadius = UDim.new(0, 6)
aiSendCorner.Parent = aiSendBtn

local narratorBtn, narratorIndicator = createButton("Narrador Auto", Content2, 135)
local narratorNowBtn = createSimpleButton("Narrar Agora", Content2, 180)

-- Timer do Narrador Auto
local narratorTimer = Instance.new("TextLabel")
narratorTimer.Parent = Content2
narratorTimer.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
narratorTimer.Position = UDim2.new(1, -50, 0, 135)
narratorTimer.Size = UDim2.new(0, 40, 0, 35)
narratorTimer.Font = Enum.Font.GothamBold
narratorTimer.Text = ""
narratorTimer.TextColor3 = Color3.fromRGB(0, 0, 0)
narratorTimer.TextSize = 11
narratorTimer.Visible = false

local narratorTimerCorner = Instance.new("UICorner")
narratorTimerCorner.CornerRadius = UDim.new(0, 6)
narratorTimerCorner.Parent = narratorTimer

-- Spinner de Loading
local narratorSpinner = Instance.new("ImageLabel")
narratorSpinner.Parent = narratorTimer
narratorSpinner.BackgroundTransparency = 1
narratorSpinner.Position = UDim2.new(0.5, -12, 0.5, -12)
narratorSpinner.Size = UDim2.new(0, 24, 0, 24)
narratorSpinner.Image = "rbxasset://textures/ui/LoadingCircle.png"
narratorSpinner.Visible = false

-- ABA 3: MÚSICA
local musicBtn, musicIndicator = createButton("Música YouTube", Content3, 5)

local musicInputBox = Instance.new("TextBox")
musicInputBox.Parent = Content3
musicInputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
musicInputBox.Position = UDim2.new(0, 10, 0, 50)
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
musicPlayBtn.Parent = Content3
musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
musicPlayBtn.Position = UDim2.new(0, 10, 0, 90)
musicPlayBtn.Size = UDim2.new(0, 200, 0, 30)
musicPlayBtn.Font = Enum.Font.GothamBold
musicPlayBtn.Text = "Tocar"
musicPlayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
musicPlayBtn.TextSize = 13

local musicPlayCorner = Instance.new("UICorner")
musicPlayCorner.CornerRadius = UDim.new(0, 6)
musicPlayCorner.Parent = musicPlayBtn

-- Tab System Logic
tab1.MouseButton1Click:Connect(function()
    Content1.Visible = true
    Content2.Visible = false
    Content3.Visible = false
    tab1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    tab2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

tab2.MouseButton1Click:Connect(function()
    Content1.Visible = false
    Content2.Visible = true
    Content3.Visible = false
    tab1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab2.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    tab3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end)

tab3.MouseButton1Click:Connect(function()
    Content1.Visible = false
    Content2.Visible = false
    Content3.Visible = true
    tab1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab3.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

tab1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- Variables
local allChatEnabled = false
local aiChatEnabled = false
local aiProcessing = false
local narratorEnabled = false
local PROXIMITY_DISTANCE = 50
local ttsSpeed = 1.0
local musicEnabled = false
local musicPlaying = false
local musicSearching = false
local musicToggling = false

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
    
    -- Para IA anterior se estiver falando
    if aiProcessing then
        print("[AI] Interrompendo resposta anterior")
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
        task.wait(0.3)
    end
    
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
local function searchMusic(query, playerName)
    print("[MUSIC] Buscando:", query)
    
    if musicPlaying then
        print("[MUSIC] Parando música anterior...")
        musicPlaying = false
        stopMusic()
        task.wait(1.5)
    end
    
    musicSearching = true
    musicPlayBtn.Text = "Tocar"
    musicPlayBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    
    task.spawn(function()
        local success, result = pcall(function()
            return request({
                Url = SERVER_URL .. "/music/search",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({query = query, player_name = playerName})
            })
        end)
        
        if not musicSearching then
            print("[MUSIC] Busca cancelada")
            return
        end
        
        if success and result then
            print("[MUSIC] Resposta recebida:", result.StatusCode)
            local data = HttpService:JSONDecode(result.Body)
            if data.found and musicSearching then
                print("[MUSIC] Encontrada:", data.title)
                musicPlaying = true
                musicSearching = false
                musicPlayBtn.Text = "Interromper"
                musicPlayBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            else
                print("[MUSIC] Não encontrada")
                musicPlaying = false
                musicSearching = false
                musicPlayBtn.Text = "Tocar"
                musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
            end
        else
            warn("[MUSIC] Erro na requisição:", result)
            musicPlaying = false
            musicSearching = false
            musicPlayBtn.Text = "Tocar"
            musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
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

narratorBtn.MouseButton1Click:Connect(function()
    narratorEnabled = not narratorEnabled
    narratorIndicator.BackgroundColor3 = narratorEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    
    if not narratorEnabled then
        narratorTimer.Visible = false
    end
    
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/narrator",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({enabled = narratorEnabled, force = true})
            })
        end)
    end)
    
    print("[NARRADOR]", narratorEnabled and "Ativado - Narrando a cada 2 minutos (FORÇADO)" or "Desativado")
end)

narratorNowBtn.MouseButton1Click:Connect(function()
    print("[NARRADOR] Forçando narração imediata...")
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/narrator/now",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({force = true})
            })
        end)
    end)
end)

-- Sistema de Timer do Narrador
task.spawn(function()
    local spinnerRotation = 0
    while true do
        task.wait(0.05)
        if narratorEnabled then
            task.spawn(function()
                local success, response = pcall(function()
                    return request({
                        Url = SERVER_URL .. "/narrator/status",
                        Method = "GET",
                        Headers = {["Content-Type"] = "application/json"}
                    })
                end)
                
                if success and response then
                    local data = HttpService:JSONDecode(response.Body)
                    if data.loading then
                        narratorTimer.Visible = true
                        narratorTimer.Text = ""
                        narratorSpinner.Visible = true
                        spinnerRotation = (spinnerRotation + 10) % 360
                        narratorSpinner.Rotation = spinnerRotation
                    elseif data.time_remaining and data.time_remaining > 0 then
                        narratorTimer.Visible = true
                        narratorSpinner.Visible = false
                        local minutes = math.floor(data.time_remaining / 60)
                        local seconds = math.floor(data.time_remaining % 60)
                        narratorTimer.Text = string.format("%d:%02d", minutes, seconds)
                    else
                        narratorTimer.Visible = false
                        narratorSpinner.Visible = false
                    end
                end
            end)
        end
    end
end)

rejoinBtn.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

infoBtn.MouseButton1Click:Connect(function()
    print("[INFO] Solicitando informações de uso das APIs...")
    task.spawn(function()
        pcall(function()
            request({
                Url = SERVER_URL .. "/api/usage",
                Method = "GET",
                Headers = {["Content-Type"] = "application/json"}
            })
        end)
    end)
end)

-- Music Button Events
musicBtn.MouseButton1Click:Connect(function()
    if musicToggling then
        print("[MUSIC] Aguarde...")
        return
    end
    
    musicToggling = true
    
    -- Muda visual imediatamente para feedback instantâneo
    musicEnabled = not musicEnabled
    musicIndicator.BackgroundColor3 = musicEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    print("[MUSIC]", musicEnabled and "ATIVANDO..." or "DESATIVANDO...")
    
    -- Envia para servidor em background
    task.spawn(function()
        local success, response = pcall(function()
            return request({
                Url = SERVER_URL .. "/music/toggle",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({})
            })
        end)
        
        if success and response then
            local data = HttpService:JSONDecode(response.Body)
            musicEnabled = data.enabled
            musicIndicator.BackgroundColor3 = musicEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
            print("[MUSIC]", musicEnabled and "ATIVADO!" or "DESATIVADO!")
        else
            warn("[MUSIC] Erro ao alternar estado")
            -- Reverte em caso de erro
            musicEnabled = not musicEnabled
            musicIndicator.BackgroundColor3 = musicEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        end
        
        task.wait(0.2)
        musicToggling = false
    end)
end)

musicPlayBtn.MouseButton1Click:Connect(function()
    if not musicEnabled then
        print("[MUSIC] Sistema desativado - Ative o botão 'Música YouTube' primeiro (deixe verde)")
        return
    end
    
    -- Se está buscando, cancela a busca
    if musicSearching then
        print("[MUSIC] Cancelando busca")
        musicSearching = false
        musicPlaying = false
        musicPlayBtn.Text = "Tocar"
        musicPlayBtn.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
        stopMusic()
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
        
        searchMusic(query, nil)
    end
end)

local function setupPlayerChat(plr)
    if plr == player then return end
    
    plr.Chatted:Connect(function(message)
        print("[DEBUG] Player", plr.DisplayName, "falou:", message)
        
        -- Detecta comando "tocar" (case insensitive)
        local lowerMsg = string.lower(message)
        if musicEnabled and string.sub(lowerMsg, 1, 5) == "tocar" then
            local songName = string.sub(message, 7)  -- Pega do caractere 7 em diante (após "tocar ")
            if #songName > 0 then
                print("[MUSIC] Comando detectado de", plr.DisplayName, ":", songName)
                musicInputBox.Text = plr.DisplayName .. " tocou: " .. songName
                searchMusic(songName, plr.DisplayName)
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

