-- Voice Chat TTS Script (File Version)
print("[VoiceTTS] Iniciando...")

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

pcall(function()
    if game.CoreGui:FindFirstChild("VoiceTTSGui") then
        game.CoreGui:FindFirstChild("VoiceTTSGui"):Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoiceTTSGui"
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
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "Voice TTS"
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

local ttsBtn = Instance.new("TextButton")
ttsBtn.Parent = MainFrame
ttsBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ttsBtn.Position = UDim2.new(0, 10, 0, 50)
ttsBtn.Size = UDim2.new(0, 200, 0, 35)
ttsBtn.Font = Enum.Font.Gotham
ttsBtn.Text = "Voice TTS"
ttsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ttsBtn.TextSize = 13

local ttsBtnCorner = Instance.new("UICorner")
ttsBtnCorner.CornerRadius = UDim.new(0, 6)
ttsBtnCorner.Parent = ttsBtn

local ttsIndicator = Instance.new("Frame")
ttsIndicator.Parent = ttsBtn
ttsIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ttsIndicator.Position = UDim2.new(1, -25, 0.5, -8)
ttsIndicator.Size = UDim2.new(0, 16, 0, 16)
ttsIndicator.BorderSizePixel = 0

local ttsIndicatorCorner = Instance.new("UICorner")
ttsIndicatorCorner.CornerRadius = UDim.new(1, 0)
ttsIndicatorCorner.Parent = ttsIndicator

local ttsEnabled = false
local toggleKey = Enum.KeyCode.Z

ttsBtn.MouseButton1Click:Connect(function()
    ttsEnabled = not ttsEnabled
    if ttsEnabled then
        ttsIndicator.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        print("[TTS] Ativado! Certifique-se que o Python está rodando.")
    else
        ttsIndicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("[TTS] Desativado")
    end
end)

rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

player.Chatted:Connect(function(message)
    if not ttsEnabled then return end
    if message:sub(1, 1) == "/" then return end
    
    print("[TTS]", message)
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

ScreenGui.Parent = game.CoreGui

print("[VoiceTTS] Carregado! Z=Menu")
print("[TTS] IMPORTANTE: Execute o Python antes de usar!")
print("[TTS] Suas mensagens serão copiadas para a área de transferência")
