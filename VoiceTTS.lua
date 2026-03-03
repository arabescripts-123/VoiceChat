-- AS ChatVoice Script
print("[ChatVoice] Iniciando...")

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")

pcall(function()
    if game.CoreGui:FindFirstChild("ChatVoiceGui") then
        game.CoreGui:FindFirstChild("ChatVoiceGui"):Destroy()
    end
end)

local workspacePath = os.getenv("LOCALAPPDATA") .. "\\Solara\\workspace\\"

local function writeFile(filename, content)
    writefile(workspacePath .. filename, content)
end

local function readFile(filename)
    if isfile(workspacePath .. filename) then
        return readfile(workspacePath .. filename)
    end
    return ""
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChatVoiceGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 200)

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
Title.Text = "AS ChatVoice"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Active = true

local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Parent = MainFrame
rejoinBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
rejoinBtn.Position = UDim2.new(1, -35, 0, 5)
rejoinBtn.Size = UDim2.new(0, 30, 0, 30)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Text = "R"
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.TextSize = 14

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 6)
rejoinCorner.Parent = rejoinBtn

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

local function createButton(text, position)
    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local Indicator = Instance.new("Frame")
    local IndicatorCorner = Instance.new("UICorner")
    
    Button.Parent = MainFrame
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    Button.Position = position
    Button.Size = UDim2.new(0, 200, 0, 35)
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    Indicator.Parent = Button
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Indicator.Position = UDim2.new(1, -25, 0.5, -8)
    Indicator.Size = UDim2.new(0, 16, 0, 16)
    Indicator.BorderSizePixel = 0
    
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    return Button, Indicator
end

local voiceTTSBtn, voiceTTSIndicator = createButton("Voice TTS", UDim2.new(0, 10, 0, 50))
local allChatBtn, allChatIndicator = createButton("All Chat TTS", UDim2.new(0, 10, 0, 95))
local aiChatBtn, aiChatIndicator = createButton("AI Chat", UDim2.new(0, 10, 0, 140))

local voiceTTSEnabled = false
local allChatEnabled = false
local aiChatEnabled = false

local messageQueue = {}

local function addToQueue(message)
    table.insert(messageQueue, message)
    writeFile("tts_message.txt", message)
end

local function setupChatListener()
    local TextChannels = TextChatService:FindFirstChild("TextChannels")
    if not TextChannels then return end
    
    local RBXGeneral = TextChannels:FindFirstChild("RBXGeneral")
    if not RBXGeneral then return end
    
    RBXGeneral.MessageReceived:Connect(function(message)
        local speaker = message.TextSource
        if not speaker then return end
        
        local speakerPlayer = game.Players:GetPlayerByUserId(speaker.UserId)
        if not speakerPlayer then return end
        
        local text = message.Text
        local isOwnMessage = speakerPlayer == player
        
        if isOwnMessage and voiceTTSEnabled then
            addToQueue(text)
        elseif not isOwnMessage and aiChatEnabled and text:sub(-1) == "?" then
            if speakerPlayer.Character and player.Character then
                local distance = (speakerPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance <= 50 then
                    writeFile("ai_question.txt", speakerPlayer.Name .. ": " .. text)
                end
            end
        elseif not isOwnMessage and allChatEnabled then
            addToQueue(speakerPlayer.Name .. " disse: " .. text)
        end
    end)
end

local function setupCommandListener()
    player.Chatted:Connect(function(message)
        if message:sub(1, 5) == "/tts " then
            local ttsMessage = message:sub(6)
            if voiceTTSEnabled then
                addToQueue(ttsMessage)
            end
        end
    end)
end

voiceTTSBtn.MouseButton1Click:Connect(function()
    voiceTTSEnabled = not voiceTTSEnabled
    writeFile("tts_enabled.txt", voiceTTSEnabled and "1" or "0")
    voiceTTSIndicator.BackgroundColor3 = voiceTTSEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

allChatBtn.MouseButton1Click:Connect(function()
    allChatEnabled = not allChatEnabled
    writeFile("all_chat_enabled.txt", allChatEnabled and "1" or "0")
    allChatIndicator.BackgroundColor3 = allChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

aiChatBtn.MouseButton1Click:Connect(function()
    aiChatEnabled = not aiChatEnabled
    writeFile("ai_enabled.txt", aiChatEnabled and "1" or "0")
    aiChatIndicator.BackgroundColor3 = aiChatEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
end)

rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

local toggleKey = Enum.KeyCode.Z

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == toggleKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

ScreenGui.Parent = game.CoreGui

setupChatListener()
setupCommandListener()

print("[ChatVoice] Carregado! Z=Menu /tts=Falar")
