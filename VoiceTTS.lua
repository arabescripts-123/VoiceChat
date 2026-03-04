-- Voice TTS + AI Chat (HTTP Version)
print("[VoiceTTS] Iniciando...")

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local SERVER_URL = "http://localhost:5000"

pcall(function()
    if game.CoreGui:FindFirstChild("VoiceTTSGui") then
        game.CoreGui:FindFirstChild("VoiceTTSGui"):Destroy()
    end
end)

-- GUI (mesmo código anterior)
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

local ttsBtn, ttsIndicator = createButton("Voice TTS", 0, 50)
local allChatBtn, allChatIndicator = createButton("All Chat TTS", 0, 95)
local aiChatBtn, aiChatIndicator = createButton("AI Chat", 0, 140)

-- Variables
local ttsEnabled = false
local allChatEnabled = false
local aiChatEnabled = false
local aiProcessing = false
local PROXIMITY_DISTANCE = 50

-- HTTP Functions
local function sendTTS(text)
    spawn(function()
        local success, result = pcall(function()
            return HttpService:PostAsync(
                SERVER_URL .. "/tts",
                HttpService:JSONEncode({text = text}),
                Enum.HttpContentType.ApplicationJson
            )
        end)
        if not success then
            warn("[TTS] Erro:", result)
        end
    end)
end

local function sendAI(question, playerName)
    if aiProcessing then return end
    aiProcessing = true
    
    spawn(function()
        local success, result = pcall(function()
            return HttpService:PostAsync(
                SERVER_URL .. "/ai",
                HttpService:JSONEncode({question = question, player = playerName}),
                Enum.HttpContentType.ApplicationJson
            )
        end)
        
        wait(2)
        aiProcessing = false
        
        if not success then
            warn("[AI] Erro:", result)
        else
            print("[AI] Resposta enviada")
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

-- Button Events
ttsBtn.MouseButton1Click:Connect(function()
    ttsEnabled = not ttsEnabled
    ttsIndicator.BackgroundColor3 = ttsEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    if ttsEnabled then
        sendTTS("Oi Xexelento")
    end
    print("[TTS]", ttsEnabled and "Ativado" or "Desativado")
end)

allChatBtn.MouseButton1Click:Connect(function()
    allChatEnabled = not allChatEnabled
    allChatIndicator.BackgroundColor3 = allChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    print("[All Chat]", allChatEnabled and "Ativado" or "Desativado")
end)

aiChatBtn.MouseButton1Click:Connect(function()
    aiChatEnabled = not aiChatEnabled
    aiChatIndicator.BackgroundColor3 = aiChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    print("[AI]", aiChatEnabled and "Ativado" or "Desativado")
end)

rejoinBtn.MouseButton1Click:Connect(function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

-- Chat Events
player.Chatted:Connect(function(message)
    if message:sub(1, 5) == "/tts " then
        if ttsEnabled then
            local text = message:sub(6)
            sendTTS(text)
        end
        return
    end
    
    if not ttsEnabled then return end
    if message:sub(1, 1) == "/" then return end
    sendTTS(message)
end)

local function setupPlayerChat(plr)
    if plr == player then return end
    
    plr.Chatted:Connect(function(message)
        local isNearby = isPlayerNearby(plr)
        local isQuestion = message:sub(-1) == "?"
        
        if aiChatEnabled and isNearby and isQuestion then
            sendAI(message, plr.DisplayName)
            return
        end
        
        if allChatEnabled and not aiProcessing then
            sendTTS(plr.DisplayName .. " disse: " .. message)
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
