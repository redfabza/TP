local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local themeColor = Color3.fromRGB(0, 150, 255)
local selectedPlayer = nil
local selectedMode = "warp"
local walkSpeed = 50
local isWalking = false
local walkConn = nil

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WackShop_Move"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local Main = Instance.new("Frame", screenGui)
Main.Size = UDim2.fromOffset(190, 340) -- ปรับขนาดลดความยาวลงมาให้กระชับขึ้น
Main.AnchorPoint = Vector2.new(1, 0.5)
Main.Position = UDim2.new(1, -12, 0.5, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Main.ZIndex = 10
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Thickness = 1.5
mainStroke.Color = Color3.fromRGB(60, 60, 80)
local BG = Instance.new("UIGradient", Main)
BG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 14))
})
BG.Rotation = 135

-- Title Bar
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 10
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 14)
local TopLine = Instance.new("Frame", TitleBar)
TopLine.Size = UDim2.new(1, 0, 0, 1)
TopLine.Position = UDim2.new(0, 0, 1, -1)
TopLine.BackgroundColor3 = themeColor
TopLine.BackgroundTransparency = 0.5
TopLine.BorderSizePixel = 0
TopLine.ZIndex = 11
local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -45, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "WackShop Move"
TitleLabel.TextColor3 = themeColor
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 10
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.fromOffset(22, 22)
CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
CloseBtn.Position = UDim2.new(1, -8, 0.5, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.AutoButtonColor = false
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 20
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function()
    isWalking = false
    if walkConn then walkConn:Disconnect() end
    screenGui:Destroy()
end)

-- Draggable
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- Float Button W
local FloatBtn = Instance.new("TextButton", screenGui)
FloatBtn.Size = UDim2.fromOffset(52, 52)
FloatBtn.AnchorPoint = Vector2.new(0, 0.5)
FloatBtn.Position = UDim2.new(0, 10, 0.5, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
FloatBtn.Text = "W"
FloatBtn.TextColor3 = themeColor
FloatBtn.TextSize = 22
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.AutoButtonColor = false
FloatBtn.BorderSizePixel = 0
FloatBtn.ZIndex = 20
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
local floatStroke = Instance.new("UIStroke", FloatBtn)
floatStroke.Color = themeColor; floatStroke.Thickness = 2
local fd, fs, fp
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fd = true; fs = input.Position; fp = FloatBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if fd and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - fs
        FloatBtn.Position = UDim2.new(fp.X.Scale, fp.X.Offset + d.X, fp.Y.Scale, fp.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then fd = false end
end)
local mainVisible = true
FloatBtn.MouseButton1Click:Connect(function()
    mainVisible = not mainVisible
    Main.Visible = mainVisible
end)

-- Mode Label
local modeLabel = Instance.new("TextLabel", Main)
modeLabel.Size = UDim2.new(1, -16, 0, 16)
modeLabel.Position = UDim2.new(0, 8, 0, 42)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "วิธีเดินทาง"
modeLabel.TextColor3 = Color3.fromRGB(120, 130, 160)
modeLabel.Font = Enum.Font.GothamSemibold
modeLabel.TextSize = 11
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.ZIndex = 10

local modeFrame = Instance.new("Frame", Main)
modeFrame.Size = UDim2.new(1, -16, 0, 30)
modeFrame.Position = UDim2.new(0, 8, 0, 60)
modeFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
modeFrame.BorderSizePixel = 0
modeFrame.ZIndex = 10
Instance.new("UICorner", modeFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", modeFrame).Color = Color3.fromRGB(30, 30, 50)
local modeLayout = Instance.new("UIListLayout", modeFrame)
modeLayout.FillDirection = Enum.FillDirection.Horizontal
modeLayout.Padding = UDim.new(0, 2)
local modePad = Instance.new("UIPadding", modeFrame)
modePad.PaddingLeft = UDim.new(0, 3)
modePad.PaddingRight = UDim.new(0, 3)
modePad.PaddingTop = UDim.new(0, 3)

local modes = {
    {id = "warp", text = "🌀 วาป"},
    {id = "walk", text = "🚶 เดิน"},
    {id = "fly",  text = "🕊️ บิน"},
}
local modeButtons = {}

-- Speed Slider
local speedFrame = Instance.new("Frame", Main)
speedFrame.Size = UDim2.new(1, -16, 0, 40)
speedFrame.Position = UDim2.new(0, 8, 0, 96) -- ขยับขึ้นเล็กน้อย
speedFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
speedFrame.BorderSizePixel = 0
speedFrame.ZIndex = 10
Instance.new("UICorner", speedFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", speedFrame).Color = Color3.fromRGB(30, 30, 50)
local speedTitle = Instance.new("TextLabel", speedFrame)
speedTitle.Size = UDim2.new(1, -10, 0, 18)
speedTitle.Position = UDim2.new(0, 8, 0, 3)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "ความเร็วบิน : " .. walkSpeed
speedTitle.TextColor3 = Color3.fromRGB(150, 160, 200)
speedTitle.Font = Enum.Font.GothamSemibold
speedTitle.TextSize = 11
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 11
local barBG = Instance.new("Frame", speedFrame)
barBG.Size = UDim2.new(1, -16, 0, 10)
barBG.Position = UDim2.new(0, 8, 0, 26)
barBG.BackgroundColor3 = Color3.fromRGB(28, 28, 45)
barBG.BorderSizePixel = 0
barBG.ZIndex = 11
Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 6)
local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(walkSpeed / 300, 0, 1, 0)
barFill.BackgroundColor3 = themeColor
barFill.BorderSizePixel = 0
barFill.ZIndex = 12
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 6)
local sliderKnob = Instance.new("Frame", barBG)
sliderKnob.Size = UDim2.fromOffset(16, 16)
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Position = UDim2.new(walkSpeed / 300, 0, 0.5, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderKnob.BorderSizePixel = 0
sliderKnob.ZIndex = 13
Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
local sliding = false
local function updateSlider(inputX)
    local pct = math.clamp((inputX - barBG.AbsolutePosition.X) / barBG.AbsoluteSize.X, 0, 1)
    walkSpeed = math.max(1, math.floor(pct * 300))
    barFill.Size = UDim2.new(pct, 0, 1, 0)
    sliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
    speedTitle.Text = "ความเร็วบิน : " .. walkSpeed
end
barBG.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        sliding = true; updateSlider(i.Position.X)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then updateSlider(i.Position.X) end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
end)

-- Avatar Preview Box
local avatarBox = Instance.new("Frame", Main)
avatarBox.Size = UDim2.new(1, -16, 0, 46)
avatarBox.Position = UDim2.new(0, 8, 0, 142) -- ขยับขึ้นมา
avatarBox.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
avatarBox.BorderSizePixel = 0
avatarBox.ZIndex = 10
avatarBox.Visible = false
Instance.new("UICorner", avatarBox).CornerRadius = UDim.new(0, 10)
local avatarStroke = Instance.new("UIStroke", avatarBox)
avatarStroke.Color = Color3.fromRGB(0, 100, 180)
avatarStroke.Thickness = 1.2

local avatarImg = Instance.new("ImageLabel", avatarBox)
avatarImg.Size = UDim2.fromOffset(38, 38)
avatarImg.Position = UDim2.new(0, 4, 0.5, 0)
avatarImg.AnchorPoint = Vector2.new(0, 0.5)
avatarImg.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
avatarImg.BorderSizePixel = 0
avatarImg.ZIndex = 11
avatarImg.Image = ""
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 8)

local avatarName = Instance.new("TextLabel", avatarBox)
avatarName.Size = UDim2.new(1, -58, 0, 22)
avatarName.Position = UDim2.new(0, 54, 0, 8)
avatarName.BackgroundTransparency = 1
avatarName.Text = ""
avatarName.TextColor3 = Color3.fromRGB(220, 220, 255)
avatarName.Font = Enum.Font.GothamBold
avatarName.TextSize = 12
avatarName.TextXAlignment = Enum.TextXAlignment.Left
avatarName.ZIndex = 11

local avatarSub = Instance.new("TextLabel", avatarBox)
avatarSub.Size = UDim2.new(1, -58, 0, 16)
avatarSub.Position = UDim2.new(0, 54, 0, 30)
avatarSub.BackgroundTransparency = 1
avatarSub.Text = ""
avatarSub.TextColor3 = Color3.fromRGB(80, 120, 180)
avatarSub.Font = Enum.Font.Gotham
avatarSub.TextSize = 10
avatarSub.TextXAlignment = Enum.TextXAlignment.Left
avatarSub.ZIndex = 11

local function showAvatar(player)
    avatarBox.Visible = true
    avatarName.Text = player.Name
    avatarSub.Text = "UserId: " .. player.UserId
    avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=48&height=48&format=png"
end
local function hideAvatar()
    avatarBox.Visible = false
    avatarImg.Image = ""
    avatarName.Text = ""
    avatarSub.Text = ""
end

-- Player List Label + Refresh
local listLabel = Instance.new("TextLabel", Main)
listLabel.Size = UDim2.new(1, -50, 0, 14)
listLabel.Position = UDim2.new(0, 8, 0, 194) -- ขยับขึ้นมาตามความเหมาะสม
listLabel.BackgroundTransparency = 1
listLabel.Text = "รายชื่อผู้เล่น"
listLabel.TextColor3 = Color3.fromRGB(120, 130, 160)
listLabel.Font = Enum.Font.GothamSemibold
listLabel.TextSize = 11
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.ZIndex = 10

local refreshBtn = Instance.new("TextButton", Main)
refreshBtn.Size = UDim2.fromOffset(36, 22)
refreshBtn.Position = UDim2.new(1, -44, 0, 190) -- ขยับขึ้นมา
refreshBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
refreshBtn.Text = "🔄"
refreshBtn.TextSize = 14
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.AutoButtonColor = false
refreshBtn.BorderSizePixel = 0
refreshBtn.ZIndex = 11
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", refreshBtn).Color = Color3.fromRGB(40, 40, 70)

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame", Main)
scrollFrame.Size = UDim2.new(1, -16, 0, 72) -- ลดขนาดความสูงช่องรายชื่อลงเล็กน้อย (จาก 88 เหลือ 72) เพื่อความกระชับ
scrollFrame.Position = UDim2.new(0, 8, 0, 212) -- ขยับขึ้นมา
scrollFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = themeColor
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ZIndex = 10
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 8)
local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 4)
local listPad = Instance.new("UIPadding", scrollFrame)
listPad.PaddingTop = UDim.new(0, 4)
listPad.PaddingLeft = UDim.new(0, 4)
listPad.PaddingRight = UDim.new(0, 4)

-- Status Label
local statusLabel = Instance.new("TextLabel", Main)
statusLabel.Size = UDim2.new(1, -16, 0, 18)
statusLabel.Position = UDim2.new(0, 8, 0, 290) -- ขยับขึ้นมาให้อยู่เหนือปุ่มกดพอดี
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "เลือกผู้เล่นแล้วกดไป"
statusLabel.TextColor3 = Color3.fromRGB(100, 110, 140)
statusLabel.Font = Enum.Font.GothamSemibold
statusLabel.TextSize = 11
statusLabel.ZIndex = 10
local function notify(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or Color3.fromRGB(100, 110, 140)
end

-- ==========================================================
-- ปุ่ม GO และ STOP
-- ==========================================================
local btnRow = Instance.new("Frame", Main)
btnRow.Size = UDim2.new(1, -16, 0, 32)
btnRow.Position = UDim2.new(0, 8, 0, 308) -- ย้ายมาที่ตำแหน่งท้ายสุดของความสูงใหม่
btnRow.BackgroundTransparency = 1
btnRow.ZIndex = 10

local goBtn = Instance.new("TextButton", btnRow)
goBtn.Size = UDim2.new(1, 0, 1, 0)
goBtn.Position = UDim2.new(0, 0, 0, 0)
goBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 180)
goBtn.Text = "🚀 ไปเลย!"
goBtn.TextColor3 = Color3.new(1,1,1)
goBtn.Font = Enum.Font.GothamBold
goBtn.TextSize = 12
goBtn.AutoButtonColor = false
goBtn.BorderSizePixel = 0
goBtn.ZIndex = 10
Instance.new("UICorner", goBtn).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", goBtn).Color = themeColor

local stopBtn = Instance.new("TextButton", btnRow)
stopBtn.Size = UDim2.new(0, 72, 1, 0)
stopBtn.Position = UDim2.new(1, -72, 0, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
stopBtn.Text = "🛑 หยุด"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 11
stopBtn.AutoButtonColor = false
stopBtn.BorderSizePixel = 0
stopBtn.ZIndex = 10
stopBtn.Visible = false
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 7)

local function setStopVisible(show)
    stopBtn.Visible = show
    if show then
        goBtn.Size = UDim2.new(1, -76, 1, 0)
    else
        goBtn.Size = UDim2.new(1, 0, 1, 0)
    end
end

-- ==========================================================
-- selectMode
-- ==========================================================
local function selectMode(id)
    selectedMode = id
    for _, data in pairs(modeButtons) do
        TweenService:Create(data.btn, TweenInfo.new(0.15), {
            BackgroundColor3 = data.id == id and Color3.fromRGB(0, 100, 180) or Color3.fromRGB(20, 20, 32)
        }):Play()
        data.btn.TextColor3 = data.id == id and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,140,170)
    end
    isWalking = false
    if walkConn then walkConn:Disconnect() walkConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50; hum.PlatformStand = false end
        local root = char.PrimaryPart
        if root then
            local bv = root:FindFirstChildOfClass("BodyVelocity")
            local bg = root:FindFirstChildOfClass("BodyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    setStopVisible(id == "walk" or id == "fly")
end

for _, mode in ipairs(modes) do
    local btn = Instance.new("TextButton", modeFrame)
    btn.Size = UDim2.new(0, 56, 0, 24)
    btn.BackgroundColor3 = mode.id == "warp" and Color3.fromRGB(0,100,180) or Color3.fromRGB(20,20,32)
    btn.Text = mode.text
    btn.TextColor3 = mode.id == "warp" and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,140,170)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    table.insert(modeButtons, {id = mode.id, btn = btn})
    btn.MouseButton1Click:Connect(function() selectMode(mode.id) end)
end

-- ==========================================================
-- MOVEMENT FUNCTIONS
-- ==========================================================
local function doWarp(player)
    local myChar = LocalPlayer.Character
    local targetChar = player and player.Character
    if not myChar or not myChar.PrimaryPart then notify("❌ ตัวละครไม่พร้อม", Color3.fromRGB(255,60,60)) return end
    if not targetChar or not targetChar.PrimaryPart then notify("❌ เป้าหมายไม่พร้อม", Color3.fromRGB(255,60,60)) return end
    local cf = targetChar.PrimaryPart.CFrame
    myChar:SetPrimaryPartCFrame(cf + cf.LookVector * 3)
    notify("✅ วาปไปหา " .. player.Name, Color3.fromRGB(0,220,120))
end

local function doWalk(player)
    local myChar = LocalPlayer.Character
    local targetChar = player and player.Character
    if not myChar or not targetChar then notify("❌ ไม่พร้อม", Color3.fromRGB(255,60,60)) return end
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    isWalking = true
    hum.WalkSpeed = 32
    notify("🚶 เดินไปหา " .. player.Name, themeColor)
    if walkConn then walkConn:Disconnect() end
    walkConn = RunService.Heartbeat:Connect(function()
        if not isWalking then walkConn:Disconnect(); hum.WalkSpeed = 16; return end
        if not myChar.PrimaryPart or not targetChar.Parent then
            isWalking = false; walkConn:Disconnect(); hum.WalkSpeed = 16
            notify("✅ ถึงแล้ว!", Color3.fromRGB(0,220,120)); return
        end
        local dist = (myChar.PrimaryPart.Position - targetChar.PrimaryPart.Position).Magnitude
        if dist < 5 then
            isWalking = false; walkConn:Disconnect(); hum.WalkSpeed = 16
            notify("✅ ถึงแล้ว!", Color3.fromRGB(0,220,120)); return
        end
        hum:MoveTo(targetChar.PrimaryPart.Position)
    end)
end

local function doFly(player)
    local myChar = LocalPlayer.Character
    local targetChar = player and player.Character
    if not myChar or not targetChar then notify("❌ ไม่พร้อม", Color3.fromRGB(255,60,60)) return end
    local rootPart = myChar.PrimaryPart
    if not rootPart then return end
    local hum = myChar:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 0; hum.JumpPower = 0; hum.PlatformStand = true end

    local bv = Instance.new("BodyVelocity", rootPart)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5); bv.Velocity = Vector3.zero
    local bg = Instance.new("BodyGyro", rootPart)
    bg.MaxTorque = Vector3.new(1e4,1e4,1e4); bg.P = 3000; bg.D = 200; bg.CFrame = rootPart.CFrame

    local noclipConn
    noclipConn = RunService.Stepped:Connect(function()
        if myChar then
            for _, part in ipairs(myChar:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)

    local function stopFly()
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        if myChar then
            for _, part in ipairs(myChar:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        pcall(function() bv:Destroy() end)
        pcall(function() bg:Destroy() end)
        task.defer(function()
            if hum then
                hum.WalkSpeed = 16
                hum.JumpPower = 50
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end

    isWalking = true
    notify("🕊️ บินไปหา " .. player.Name, themeColor)
    if walkConn then walkConn:Disconnect() end
    walkConn = RunService.Heartbeat:Connect(function()
        if not isWalking then walkConn:Disconnect(); stopFly(); return end
        if not rootPart or not rootPart.Parent or not targetChar.Parent or not targetChar.PrimaryPart then
            isWalking = false; walkConn:Disconnect(); stopFly(); return
        end
        local targetRoot = targetChar.PrimaryPart
        local myPos = rootPart.Position
        local targetPos = targetRoot.Position
        local dist = (myPos - targetPos).Magnitude
        if dist < 1.5 then
            isWalking = false; walkConn:Disconnect()
            bv.Velocity = Vector3.zero; rootPart.CFrame = targetRoot.CFrame
            stopFly()
            notify("👻 สิงเข้าตัว " .. player.Name .. " แล้ว!", Color3.fromRGB(180,0,255))
            return
        end
        local dir = (targetPos - myPos).Unit
        bv.Velocity = dir * math.min(walkSpeed, dist * 6)
        local lookTarget = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
        if (lookTarget - myPos).Magnitude > 0.5 then
            bg.CFrame = CFrame.lookAt(myPos, lookTarget)
        end
    end)
end

-- GO Button
goBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then notify("⚠️ เลือกผู้เล่นก่อน!", Color3.fromRGB(255,180,0)); return end
    isWalking = false
    if walkConn then walkConn:Disconnect(); walkConn = nil end
    if selectedMode == "warp" then
        doWarp(selectedPlayer)
    elseif selectedMode == "walk" then
        doWalk(selectedPlayer)
    elseif selectedMode == "fly" then
        doFly(selectedPlayer)
    end
end)

-- STOP Button
stopBtn.MouseButton1Click:Connect(function()
    isWalking = false
    if walkConn then walkConn:Disconnect(); walkConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50; hum.PlatformStand = false end
        local root = char.PrimaryPart
        if root then
            local bv = root:FindFirstChildOfClass("BodyVelocity")
            local bg = root:FindFirstChildOfClass("BodyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    notify("🛑 หยุดแล้ว", Color3.fromRGB(255,100,100))
end)

-- ==========================================================
-- BUILD PLAYER LIST
-- ==========================================================
local function buildList()
    for _, v in ipairs(scrollFrame:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    selectedPlayer = nil
    hideAvatar()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton", scrollFrame)
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.BackgroundColor3 = Color3.fromRGB(18,18,30)
            btn.Text = "👤  " .. player.Name
            btn.TextColor3 = Color3.fromRGB(200,200,220)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.AutoButtonColor = false
            btn.BorderSizePixel = 0
            btn.ZIndex = 11
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
            local bPad = Instance.new("UIPadding", btn)
            bPad.PaddingLeft = UDim.new(0, 8)
            local bStroke = Instance.new("UIStroke", btn)
            bStroke.Color = Color3.fromRGB(30,30,50)
            bStroke.Thickness = 1

            btn.MouseButton1Click:Connect(function()
                for _, v in ipairs(scrollFrame:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.BackgroundColor3 = Color3.fromRGB(18,18,30)
                        local s = v:FindFirstChildOfClass("UIStroke")
                        if s then s.Color = Color3.fromRGB(30,30,50) end
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(0,80,140)
                bStroke.Color = themeColor
                selectedPlayer = player
                showAvatar(player)
                notify("เลือก : " .. player.Name, themeColor)
            end)
            btn.MouseEnter:Connect(function()
                if selectedPlayer ~= player then btn.BackgroundColor3 = Color3.fromRGB(24,24,38) end
            end)
            btn.MouseLeave:Connect(function()
                if selectedPlayer ~= player then btn.BackgroundColor3 = Color3.fromRGB(18,18,30) end
            end)
        end
    end
    if #Players:GetPlayers() <= 1 then
        notify("ไม่มีผู้เล่นในเซิร์ฟ", Color3.fromRGB(180,80,80))
    end
end

refreshBtn.MouseButton1Click:Connect(function()
    buildList()
    notify("🔄 รีเฟรชแล้ว", Color3.fromRGB(100,200,255))
end)

task.defer(buildList)
Players.PlayerAdded:Connect(buildList)
Players.PlayerRemoving:Connect(function() task.wait(0.5); buildList() end)

local Credit = Instance.new("TextLabel", Main)
Credit.Position = UDim2.new(0, 0, 1, -16)
Credit.Size = UDim2.new(1, 0, 0, 16)
Credit.BackgroundTransparency = 1
Credit.Text = "WackShop — ภาษาไทย"
Credit.TextColor3 = Color3.fromRGB(40,40,60)
Credit.Font = Enum.Font.Gotham
Credit.TextSize = 10

print("WackShop Move Loaded!")
