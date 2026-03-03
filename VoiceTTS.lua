-- AS ChatVoice Script
print("[AS ChatVoice] Iniciando...")

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

pcall(function()
    if game.CoreGui:FindFirstChild("ASChatVoiceGui") then
        game.CoreGui:FindFirstChild("ASChatVoiceGui"):Destroy()
    end
end)

task.wait(1)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ASChatVoiceGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 100)

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
Title.Size = UDim2.new(1, -80, 0, 40)
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
rejoinBtn.Position = UDim2.new(1, -70, 0, 5)
rejoinBtn.Size = UDim2.new(0, 35, 0, 30)
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

local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Parent = MainFrame
SettingsBtn.BackgroundTransparency = 1
SettingsBtn.Position = UDim2.new(1, -35, 0, 5)
SettingsBtn.Size = UDim2.new(0, 30, 0, 30)
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.Text = "⚙"
SettingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsBtn.TextSize = 20

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Parent = ScreenGui
SettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SettingsFrame.Position = UDim2.new(0.02, 230, 0.3, 0)
SettingsFrame.Size = UDim2.new(0, 180, 0, 100)
SettingsFrame.Visible = false

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 8)
SettingsCorner.Parent = SettingsFrame

local SettingsStroke = Instance.new("UIStroke")
SettingsStroke.Parent = SettingsFrame
SettingsStroke.Color = Color3.fromRGB(0, 0, 0)
SettingsStroke.Thickness = 3

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Parent = SettingsFrame
KeyLabel.BackgroundTransparency = 1
KeyLabel.Position = UDim2.new(0, 10, 0, 10)
KeyLabel.Size = UDim2.new(1, -20, 0, 25)
KeyLabel.Font = Enum.Font.Gotham
KeyLabel.Text = "Tecla Menu:"
KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.TextSize = 12
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left

local KeyBox = Instance.new("TextBox")
KeyBox.Parent = SettingsFrame
KeyBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
KeyBox.Position = UDim2.new(0, 10, 0, 45)
KeyBox.Size = UDim2.new(1, -20, 0, 35)
KeyBox.Font = Enum.Font.Gotham
KeyBox.Text = "Z"
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 14

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = KeyBox

local toggleKey = Enum.KeyCode.Z
local comando1Enabled = false

SettingsBtn.MouseButton1Click:Connect(function()
    SettingsFrame.Visible = not SettingsFrame.Visible
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

local comando1Btn, comando1Indicator = createButton("Chat to Voice", UDim2.new(0, 10, 0, 50))

local function sendToTTS(playerName, message)
    local HttpService = game:GetService("HttpService")
    local url = "http://127.0.0.1:5000/tts"
    local data = HttpService:JSONEncode({player = playerName, text = message})
    
    pcall(function()
        local response = request({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = data
        })
    end)
end

local function setupChatListener()
    local TextChatService = game:GetService("TextChatService")
    local Players = game:GetService("Players")
    
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.MessageReceived:Connect(function(message)
            if comando1Enabled and message.TextSource then
                local playerName = message.TextSource.Name
                local text = message.Text
                sendToTTS(playerName, text)
            end
        end)
    else
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local DefaultChatSystemChatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 5)
        if DefaultChatSystemChatEvents then
            local OnMessageDoneFiltering = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering", 5)
            if OnMessageDoneFiltering then
                OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
                    if comando1Enabled and data then
                        local playerName = data.FromSpeaker or "Unknown"
                        local text = data.Message or ""
                        sendToTTS(playerName, text)
                    end
                end)
            end
        end
    end
end

setupChatListener()

comando1Btn.MouseButton1Click:Connect(function()
    comando1Enabled = not comando1Enabled
    if comando1Enabled then
        comando1Indicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
    else
        comando1Indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

KeyBox.FocusLost:Connect(function()
    local text = KeyBox.Text:upper()
    local success, key = pcall(function() return Enum.KeyCode[text] end)
    if success and key then
        toggleKey = key
        KeyBox.Text = text
    else
        KeyBox.Text = "Z"
        toggleKey = Enum.KeyCode.Z
    end
end)

rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == toggleKey then
        MainFrame.Visible = not MainFrame.Visible
        SettingsFrame.Visible = false
    end
end)

ScreenGui.Parent = game.CoreGui

print("[AS ChatVoice] Carregado! Z=Menu")
