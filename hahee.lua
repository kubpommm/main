local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local UIS = game:GetService("UserInputService")

local TweenService = game:GetService("TweenService")

local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")



------------------------------------------------------------------

-- GUI creation

------------------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

------------------------------------------------------------------
-- GUI creation
------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BorderSizePixel = 0
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 26) -- สีพื้นหลังเทาดำหรูหรา
frame.Active = true
frame.Draggable = true 
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)


local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(50, 50, 55)
frameStroke.Thickness = 1
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "nahee"
title.TextColor3 = Color3.fromRGB(240, 240, 245) 
title.Font = Enum.Font.GothamBold
title.TextScaled = true

------------------------------------------------------------------

------------------------------------------------------------------
local toggleUiButton = Instance.new("TextButton", frame)
toggleUiButton.Size = UDim2.new(0, 16, 0, 16)
toggleUiButton.Position = UDim2.new(1, -22, 0, 12)
toggleUiButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60) 
toggleUiButton.Text = ""
toggleUiButton.AutoButtonColor = false
Instance.new("UICorner", toggleUiButton).CornerRadius = UDim.new(1, 0) 

local toggleStroke = Instance.new("UIStroke", toggleUiButton)
toggleStroke.Color = Color3.fromRGB(200, 40, 40)
toggleStroke.Thickness = 1

local uiVisible = true
toggleUiButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    
    for _, child in ipairs(frame:GetChildren()) do
        if child ~= title and child ~= toggleUiButton and child ~= frameStroke then
            if child:IsA("GuiObject") then
                child.Visible = uiVisible
            end
        end
    end
    
    if uiVisible then
        updateFrameHeight()
    else
        frame.Size = UDim2.new(0, 400, 0, 40)
    end
end)

------------------------------------------------------------------

------------------------------------------------------------------
local function setButtonState(btn, text, isActive)
    btn.Text = text
    if isActive then
       
        btn.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
        btn.TextColor3 = Color3.fromRGB(20, 20, 22)
    else
       
        btn.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
        btn.TextColor3 = Color3.fromRGB(220, 220, 225)
    end
end

local function createButton(text, x, y, width)
    local btn = Instance.new("TextButton", frame)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.Size = UDim2.new(0, width, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(55, 55, 60)
    btnStroke.Thickness = 1
    
    setButtonState(btn, text, false)
    return btn
end

------------------------------------------------------------------
-- UI: สร้างปุ่มทั้งหมดและการจัดวางตำแหน่ง
------------------------------------------------------------------
local teleportButton = createButton("Teleport", 15, 85, 180)
local espButton = createButton("ESP: OFF", 205, 85, 180)
local loopTeleportButton = createButton("Loop Teleport", 15, 125, 180)
local flingButton = createButton("Fling", 205, 125, 180)
local viewButton = createButton("View Player", 15, 165, 180)
local noclipButton = createButton("NoClip: OFF", 205, 165, 180)

-- แถวที่ 4 (Y = 205)
local flyButton = createButton("Fly", 15, 205, 90)
local flySpeedDownButton = createButton("-", 105, 205, 42)
local flySpeedUpButton = createButton("+", 152, 205, 43)

local speedButton = createButton("Speed: OFF", 205, 205, 110) 
local speedUpButton = createButton("▲", 320, 205, 30)
local speedDownButton = createButton("▼", 355, 205, 30)

------------------------------------------------------------------
-- ตารางระดับความเร็ว
------------------------------------------------------------------
local speedLevels = {16, 25, 35, 50, 75, 100, 150, 200}
local currentLevelIndex = 4 
local speedSystemActive = false

local function updateSpeedUI()
    local targetSpeed = speedLevels[currentLevelIndex]
    
    if speedSystemActive then
        setButtonState(speedButton, "Speed: " .. tostring(targetSpeed), true)
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char:FindFirstChildOfClass("Humanoid").WalkSpeed = targetSpeed
            end
        end)
    else
        setButtonState(speedButton, "Speed: OFF", false)
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
                if humanoid then humanoid.WalkSpeed = 16 end
            end
        end)
    end
end

speedButton.MouseButton1Click:Connect(function()
    speedSystemActive = not speedSystemActive
    updateSpeedUI()
end)

speedUpButton.MouseButton1Click:Connect(function()
    if currentLevelIndex < #speedLevels then
        currentLevelIndex = currentLevelIndex + 1
        setButtonState(speedUpButton, "▲", true)
        task.wait(0.08)
        setButtonState(speedUpButton, "▲", false)
        updateSpeedUI()
    end
end)

speedDownButton.MouseButton1Click:Connect(function()
    if currentLevelIndex > 1 then
        currentLevelIndex = currentLevelIndex - 1
        setButtonState(speedDownButton, "▼", true)
        task.wait(0.08)
        setButtonState(speedDownButton, "▼", false)
        updateSpeedUI()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if speedSystemActive then updateSpeedUI() end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char.HumanoidRootPart
    local targetSpeed = speedLevels[currentLevelIndex]
    
    if speedSystemActive and humanoid.MoveDirection.Magnitude > 0 then
        pcall(function()
            if targetSpeed > 16 then
                local pushFactor = (targetSpeed - 16) * 0.0125
                hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * pushFactor)
            end
            if humanoid.SeatPart and (flying == nil or flying == false) then
                humanoid.SeatPart.Velocity = humanoid.MoveDirection * (targetSpeed * 1.5)
            end
        end)
    end
end)

------------------------------------------------------------------
-- Player dropdown
------------------------------------------------------------------

local selectedPlayer, isDropdownOpen = nil, false
local dropdown = Instance.new("TextButton", frame)
dropdown.Position = UDim2.new(0, 15, 0, 45)
dropdown.Size = UDim2.new(1, -30, 0, 30)
dropdown.Text = "Select Player"
dropdown.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 18
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

local dropdownStroke = Instance.new("UIStroke", dropdown)
dropdownStroke.Color = Color3.fromRGB(50, 50, 55)
dropdownStroke.Thickness = 1

local dropdownMenu = Instance.new("Frame", frame)
dropdownMenu.Position = UDim2.new(0, 15, 0, 75)
dropdownMenu.Size = UDim2.new(1, -30, 0, 0)
dropdownMenu.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
dropdownMenu.BorderSizePixel = 0
dropdownMenu.Visible = false
dropdownMenu.ClipsDescendants = true
Instance.new("UICorner", dropdownMenu).CornerRadius = UDim.new(0, 8)

local menuStroke = Instance.new("UIStroke", dropdownMenu)
menuStroke.Color = Color3.fromRGB(45, 45, 50)
menuStroke.Thickness = 1

local searchBar = Instance.new("TextBox", dropdownMenu)
searchBar.Size = UDim2.new(1, -8, 0, 28)
searchBar.Position = UDim2.new(0, 4, 0, 4)
searchBar.PlaceholderText = "Search players..."
searchBar.Text = ""
searchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBar.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
searchBar.Font = Enum.Font.Gotham
searchBar.TextSize = 16
searchBar.ClearTextOnFocus = true
Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 6)

local searchStroke = Instance.new("UIStroke", searchBar)
searchStroke.Color = Color3.fromRGB(55, 55, 60)
searchStroke.Thickness = 1

local playerListFrame = Instance.new("ScrollingFrame", dropdownMenu)
playerListFrame.Position = UDim2.new(0, 4, 0, 36)
playerListFrame.Size = UDim2.new(1, -8, 1, -40)
playerListFrame.BackgroundTransparency = 1
playerListFrame.ScrollBarThickness = 6
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)

local listLayout = Instance.new("UIListLayout", playerListFrame)
listLayout.Padding = UDim.new(0, 4)


local function refreshPlayers(filter)
    for _, c in pairs(playerListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (not filter or string.find(p.DisplayName:lower(), filter:lower())) then
            count = count + 1
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -4, 0, 28)
            b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.Gotham
            b.TextSize = 16
            b.Text = p.DisplayName
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            b.Parent = playerListFrame
            
            b.MouseButton1Click:Connect(function()
                selectedPlayer = p
                dropdown.Text = p.DisplayName
                TweenService:Create(dropdownMenu, TweenInfo.new(0.3), {Size = UDim2.new(1, -30, 0, 0)}):Play()
                task.wait(0.3)
                dropdownMenu.Visible = false
                isDropdownOpen = false
                updateFrameHeight()
            end)
        end
    end
    
    
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 32)
end

searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    refreshPlayers(searchBar.Text)
    
    if isDropdownOpen then
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and (searchBar.Text == "" or string.find(p.DisplayName:lower(), searchBar.Text:lower())) then
                count = count + 1
            end
        end
        
        local h = math.min(450, 40 + (count * 32))
        TweenService:Create(dropdownMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, h)}):Play()
        updateFrameHeight()
    end
end)

dropdown.MouseButton1Click:Connect(function()
    isDropdownOpen = not isDropdownOpen
    if isDropdownOpen then
        refreshPlayers()
        dropdownMenu.Visible = true
        
        
        local totalPlayers = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then totalPlayers = totalPlayers + 1 end
        end
        
        local h = math.min(450, 40 + (totalPlayers * 32))
        TweenService:Create(dropdownMenu, TweenInfo.new(0.3), {Size = UDim2.new(1, -30, 0, h)}):Play()
    else
        TweenService:Create(dropdownMenu, TweenInfo.new(0.3), {Size = UDim2.new(1, -30, 0, 0)}):Play()
        task.wait(0.3)
        dropdownMenu.Visible = false
    end
    updateFrameHeight()
end)

------------------------------------------------------------------
-- Dynamic frame height
------------------------------------------------------------------
function updateFrameHeight()
    if not uiVisible then return end
    local padding = 10
    local dropdownBottom = dropdownMenu.Position.Y.Offset + dropdownMenu.Size.Y.Offset
    local lastButtonBottom = speedButton.Position.Y.Offset + speedButton.Size.Y.Offset
    local totalHeight = math.max(dropdownBottom, lastButtonBottom) + padding
    frame.Size = UDim2.new(0, 400, 0, totalHeight)
end

updateFrameHeight()

------------------------------------------------------------------
-- Teleport
------------------------------------------------------------------
teleportButton.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = myChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                hrp.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            end)
        end
    end
end)

------------------------------------------------------------------
-- Loop Teleport
------------------------------------------------------------------
local loopTeleporting = false
local loopConnection
loopTeleportButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    loopTeleporting = not loopTeleporting
    setButtonState(loopTeleportButton, loopTeleporting and "Stop Loop TP" or "Loop Teleport", loopTeleporting)
    if loopTeleporting then
        loopConnection = RunService.Heartbeat:Connect(function()
            if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                    end)
                end
            end
        end)
    else
        if loopConnection then loopConnection:Disconnect() loopConnection = nil end
    end
end)

------------------------------------------------------------------
-- ESP
------------------------------------------------------------------
local espObjects, espCharConns = {}, {}
local espEnabled = false

local function removeESPForPlayer(p)
    if espObjects[p] then
        for _, o in ipairs(espObjects[p]) do
            if o and o.Parent then o:Destroy() end
        end
    end
    espObjects[p] = nil
    if espCharConns[p] then espCharConns[p]:Disconnect() espCharConns[p] = nil end
end

local function applyESPToCharacter(p, char)
    if not espEnabled or not p or not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    removeESPForPlayer(p)

    local highlight = Instance.new("Highlight", char)
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(0,191,255)
    highlight.OutlineTransparency = 0

    local billboard = Instance.new("BillboardGui", char)
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = hrp
    billboard.MaxDistance = math.huge

    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Text = p.DisplayName
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center

    espObjects[p] = {highlight, billboard}
end

local function addESPForPlayer(p)
    if p == LocalPlayer then return end
    if espCharConns[p] then espCharConns[p]:Disconnect() end
    if p.Character then applyESPToCharacter(p, p.Character) end
    espCharConns[p] = p.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if espEnabled then applyESPToCharacter(p, c) end
    end)
end

local function refreshAllESP()
    for _, p in ipairs(Players:GetPlayers()) do removeESPForPlayer(p) end
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then addESPForPlayer(p) end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    setButtonState(espButton, "ESP: " .. (espEnabled and "ON" or "OFF"), espEnabled)
    refreshAllESP()
end)

Players.PlayerAdded:Connect(function(p) if espEnabled then addESPForPlayer(p) end end)
Players.PlayerRemoving:Connect(function(p) removeESPForPlayer(p) end)
LocalPlayer.CharacterAdded:Connect(function() if espEnabled then task.wait(0.5) refreshAllESP() end end)

------------------------------------------------------------------
-- View Player
------------------------------------------------------------------
local viewActive = false

viewButton.MouseButton1Click:Connect(function()

    viewActive = not viewActive

    if viewActive then

        setButtonState(viewButton, "View Player", true)

        

    else

        setButtonState(viewButton, "View Player", false)

    end

end)

------------------------------------------------------------------
-- Fly
------------------------------------------------------------------

------------------------------------------------------------------
-- NoClip
------------------------------------------------------------------
local noclipEnabled, noclipConn = false, nil
local function setNoClip(state)
    noclipEnabled = state
    setButtonState(noclipButton, "NoClip: " .. (state and "ON" or "OFF"), state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end
noclipButton.MouseButton1Click:Connect(function() setNoClip(not noclipEnabled) end)
LocalPlayer.CharacterAdded:Connect(function() if noclipEnabled then task.wait(0.5) setNoClip(true) end end)

------------------------------------------------------------------
-- Fling
------------------------------------------------------------------
local teleporting = false
local teleportCoroutine = nil
local SAFE_SPAWN_POSITION = Vector3.new(202, 224, 593)

flingButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    teleporting = not teleporting

    local myChar = LocalPlayer.Character
    local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if teleporting then
        setButtonState(flingButton, "Fling", true)
        teleportCoroutine = task.spawn(function()
            while teleporting do
                myChar = LocalPlayer.Character
                hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

                local targetChar = selectedPlayer.Character
                local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetRoot then
                    local currentPos = targetRoot.Position
                    local velocity = targetRoot.Velocity
                    
                    local predictX = velocity.X * 0.7
                    local predictZ = velocity.Z * 0.7
                    
                    local finalX = currentPos.X + predictX
                    local finalY = currentPos.Y - 0.5
                    local finalZ = currentPos.Z + predictZ
                    
                    if finalY < 100 or finalY > 1000 then
                        teleporting = false
                        setButtonState(flingButton, "Fling", false)
                        if hrp then hrp.CFrame = CFrame.new(SAFE_SPAWN_POSITION) end
                        break
                    else
                        hrp.CFrame = CFrame.new(finalX, finalY, finalZ)
                    end
                end
                task.wait(0.04)
            end
            if teleportCoroutine then
                task.cancel(teleportCoroutine)
                teleportCoroutine = nil
            end
        end)
    else
        teleporting = false
        setButtonState(flingButton, "Fling", false)
        if teleportCoroutine then 
            task.cancel(teleportCoroutine) 
            teleportCoroutine = nil 
        end

        myChar = LocalPlayer.Character
        hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(SAFE_SPAWN_POSITION)
        end
    end
end)



------------------------------------------------------------------

-- Hitbox Extender

------------------------------------------------------------------





------------------------------------------------------------------

-- Teleport

------------------------------------------------------------------

teleportButton.MouseButton1Click:Connect(function()

    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then

        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

        local hrp = myChar:FindFirstChild("HumanoidRootPart")

        if hrp then

            pcall(function()

                hrp.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)

            end)

        end

    end

end)



------------------------------------------------------------------

-- Loop Teleport

------------------------------------------------------------------

local loopTeleporting = false

local loopConnection

loopTeleportButton.MouseButton1Click:Connect(function()

    if not selectedPlayer then return end

    loopTeleporting = not loopTeleporting

    loopTeleportButton.Text = loopTeleporting and "Stop Loop Teleport" or "Loop Teleport"

    if loopTeleporting then

        loopConnection = RunService.Heartbeat:Connect(function()

            if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then

                local myChar = LocalPlayer.Character

                local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

                if hrp then

                    pcall(function()

                        hrp.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)

                    end)

                end

            end

        end)

    else

        if loopConnection then loopConnection:Disconnect() loopConnection = nil end

    end

end)



------------------------------------------------------------------

-- ESP (Optimized: No distance cap, auto-update)

------------------------------------------------------------------

local espObjects, espCharConns = {}, {}

local espEnabled = false



local function removeESPForPlayer(p)

    if espObjects[p] then

        for _, o in ipairs(espObjects[p]) do

            if o and o.Parent then o:Destroy() end

        end

    end

    espObjects[p] = nil

    if espCharConns[p] then espCharConns[p]:Disconnect() espCharConns[p] = nil end

end



local function applyESPToCharacter(p, char)

    if not espEnabled or not p or not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")

    if not hrp then return end

    removeESPForPlayer(p)



    local highlight = Instance.new("Highlight", char)

    highlight.FillTransparency = 1

    highlight.OutlineColor = Color3.fromRGB(0,191,255)

    highlight.OutlineTransparency = 0



    local billboard = Instance.new("BillboardGui", char)

    billboard.Size = UDim2.new(0, 100, 0, 20)

    billboard.AlwaysOnTop = true

    billboard.StudsOffset = Vector3.new(0, 3, 0)

    billboard.Adornee = hrp

    billboard.MaxDistance = math.huge



    local nameLabel = Instance.new("TextLabel", billboard)

    nameLabel.Size = UDim2.new(1, 0, 1, 0)

    nameLabel.BackgroundTransparency = 1

    nameLabel.TextColor3 = Color3.fromRGB(0, 191, 255)

    nameLabel.Font = Enum.Font.GothamBold

    nameLabel.TextSize = 14

    nameLabel.Text = p.DisplayName

    nameLabel.TextStrokeTransparency = 0.5

    nameLabel.TextXAlignment = Enum.TextXAlignment.Center

    nameLabel.TextYAlignment = Enum.TextYAlignment.Center



    espObjects[p] = {highlight, billboard}

end



local function addESPForPlayer(p)

    if p == LocalPlayer then return end

    if espCharConns[p] then espCharConns[p]:Disconnect() end

    if p.Character then applyESPToCharacter(p, p.Character) end

    espCharConns[p] = p.CharacterAdded:Connect(function(c)

        task.wait(0.5)

        if espEnabled then applyESPToCharacter(p, c) end

    end)

end



local function refreshAllESP()

    for _, p in ipairs(Players:GetPlayers()) do removeESPForPlayer(p) end

    if espEnabled then

        for _, p in ipairs(Players:GetPlayers()) do

            if p ~= LocalPlayer then addESPForPlayer(p) end

        end

    end

end



espButton.MouseButton1Click:Connect(function()

    espEnabled = not espEnabled

    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")

    refreshAllESP()

end)



Players.PlayerAdded:Connect(function(p) if espEnabled then addESPForPlayer(p) end end)

Players.PlayerRemoving:Connect(function(p) removeESPForPlayer(p) end)

LocalPlayer.CharacterAdded:Connect(function() if espEnabled then task.wait(0.5) refreshAllESP() end end)



------------------------------------------------------------------

-- View Player

------------------------------------------------------------------
local viewing, savedCameraSubject = false, nil
local viewLoop = nil

viewButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    local camera = Workspace.CurrentCamera
    viewing = not viewing
    
    if viewing then
        setButtonState(viewButton, "Stop Viewing", true)
        savedCameraSubject = camera.CameraSubject
        
        
        if viewLoop then task.cancel(viewLoop) end
        viewLoop = task.spawn(function()
            while viewing do
                pcall(function()
                    if selectedPlayer and selectedPlayer.Character then
                        local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if hum and camera.CameraSubject ~= hum then
                            camera.CameraSubject = hum
                        end
                    end
                end)
                task.wait(1) -- เช็คทุกๆ 1 วินาที
            end
        end)
    else
        setButtonState(viewButton, "View Player", false)
        
        
        viewing = false
        if viewLoop then
            task.cancel(viewLoop)
            viewLoop = nil
        end
        
        
        pcall(function()
            if savedCameraSubject then
                camera.CameraSubject = savedCameraSubject
            else
                local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if myHum then camera.CameraSubject = myHum end
            end
        end)
    end
end)



------------------------------------------------------------------

-- Fly

------------------------------------------------------------------


------------------------------------------------------------------
local flying, flyBodyVelocity, flyGyro, flyConnection = false, nil, nil, nil
local flySpeed = 60 -- ค

local function updateFlySpeedText()
    if flying then
        setButtonState(flyButton, "Fly: " .. flySpeed, true)
    else
        setButtonState(flyButton, "Fly: " .. flySpeed, false)
    end
   
    setButtonState(flySpeedDownButton, "-", false)
    setButtonState(flySpeedUpButton, "+", false)
end
updateFlySpeedText()

flySpeedUpButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(300, flySpeed + 25)
    updateFlySpeedText()
    setButtonState(flySpeedUpButton, "+", true)
    task.wait(0.1)
    setButtonState(flySpeedUpButton, "+", false)
end)

flySpeedDownButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(10, flySpeed - 25)
    updateFlySpeedText()
    setButtonState(flySpeedDownButton, "-", true)
    task.wait(0.1)
    setButtonState(flySpeedDownButton, "-", false)
end)

local function toggleFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    flying = not flying
    
    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local camera = Workspace.CurrentCamera
    
    if flying then
        setButtonState(flyButton, "Fly: " .. flySpeed, true)
        humanoid.AutoRotate = false
        camera.CameraType = Enum.CameraType.Custom

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp

        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(0, 1e5, 0) 
        flyGyro.CFrame = hrp.CFrame
        flyGyro.Parent = hrp

        flyConnection = RunService.Heartbeat:Connect(function()
            local dir = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0, 1, 0) end
            if dir.Magnitude > 0 then dir = dir.Unit end

            if flyBodyVelocity then flyBodyVelocity.Velocity = dir * flySpeed end
            if flyGyro then 
                flyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)) 
            end
        end)
    else
        setButtonState(flyButton, "Fly: " .. flySpeed, false)
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyGyro then flyGyro:Destroy() flyGyro = nil end
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if humanoid then humanoid.AutoRotate = true end
        camera.CameraType = Enum.CameraType.Custom
    end
end

-- กดปุ่ม F 
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

flyButton.MouseButton1Click:Connect(function()
    toggleFly()
end)


------------------------------------------------------------------

-- NoClip

------------------------------------------------------------------

local noclipEnabled, noclipConn = false, nil

local function setNoClip(state)

    noclipEnabled = state

    noclipButton.Text = "NoClip: " .. (state and "ON" or "OFF")

    noclipButton.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,128,128)

    if state then

        noclipConn = RunService.Stepped:Connect(function()

            local char = LocalPlayer.Character

            if char then

                for _, part in ipairs(char:GetDescendants()) do

                    if part:IsA("BasePart") then

                        part.CanCollide = false

                    end

                end

            end

        end)

    else

        if noclipConn then noclipConn:Disconnect() noclipConn = nil end

    end

end

noclipButton.MouseButton1Click:Connect(function() setNoClip(not noclipEnabled) end)

LocalPlayer.CharacterAdded:Connect(function() if noclipEnabled then task.wait(0.5) setNoClip(true) end end)



------------------------------------------------------------------

-- Fling

------------------------------------------------------------------

local teleporting = false
local teleportCoroutine = nil


local SAFE_SPAWN_POSITION = Vector3.new(202, 224, 593)

flingButton.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    teleporting = not teleporting

    local myChar = LocalPlayer.Character
    local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

    if teleporting then
        
        setButtonState(flingButton, "Fling", true)

        teleportCoroutine = task.spawn(function()
            while teleporting do
                myChar = LocalPlayer.Character
                hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

                local targetChar = selectedPlayer.Character
                local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                
                if hrp and targetRoot then
                    local currentPos = targetRoot.Position
                    local velocity = targetRoot.Velocity
                    
                    
                    local predictX = velocity.X * 0.7
                    local predictZ = velocity.Z * 0.7
                    
                    local finalX = currentPos.X + predictX
                    local finalY = currentPos.Y - 0.5
                    local finalZ = currentPos.Z + predictZ
                    
                    
                    if finalY < 100 or finalY > 1000 then
                        teleporting = false
                        setButtonState(flingButton, "Fling", false)
                        
                        if hrp then
                            hrp.CFrame = CFrame.new(SAFE_SPAWN_POSITION)
                        end
                        break
                    else
                        
                        hrp.CFrame = CFrame.new(finalX, finalY, finalZ)
                    end
                end
                
                task.wait(0.04)
            end
            
            
            if teleportCoroutine then
                task.cancel(teleportCoroutine)
                teleportCoroutine = nil
            end
        end)
    else
        teleporting = false
        
        setButtonState(flingButton, "Fling", false)
        
        if teleportCoroutine then 
            task.cancel(teleportCoroutine) 
            teleportCoroutine = nil 
        end

        
        myChar = LocalPlayer.Character
        hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(SAFE_SPAWN_POSITION)
        end
    end
end)
------------------------------------------------------------------



-- Touch fling gui

-- Gui to Lua (VIP VERSION)
-- Version: 6.9

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
print("sub to DuplexScripts")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 110)

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 25)

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.112792775, 0, -0.0151660154, 0)
TextLabel.Size = UDim2.new(0, 121, 0, 26)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "Touch Fling"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 25.000

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.113924049, 0, 0.418181807, 0)
TextButton.Size = UDim2.new(0, 121, 0, 37)
TextButton.Font = Enum.Font.SourceSansItalic
TextButton.Text = "OFF"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 20.000

-- Scripts:

local function IIMAWH_fake_script()
	local script = Instance.new('LocalScript', TextButton)

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	
	local toggleButton = script.Parent
	local hiddenfling = false
	local flingThread 
	if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		local detection = Instance.new("Decal")
		detection.Name = "juisdfj0i32i0eidsuf0iok"
		detection.Parent = ReplicatedStorage
	end
	
	local function fling()
		local lp = Players.LocalPlayer
		local c, hrp, vel, movel = nil, nil, nil, 0.1
	
		while hiddenfling do
			RunService.Heartbeat:Wait()
			c = lp.Character
			hrp = c and c:FindFirstChild("HumanoidRootPart")
	
			if hrp then
				vel = hrp.Velocity
				hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
				RunService.RenderStepped:Wait()
				hrp.Velocity = vel
				RunService.Stepped:Wait()
				hrp.Velocity = vel + Vector3.new(0, movel, 0)
				movel = -movel
			end
		end
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		hiddenfling = not hiddenfling
		toggleButton.Text = hiddenfling and "ON" or "OFF"
	
		if hiddenfling then
			flingThread = coroutine.create(fling)
			coroutine.resume(flingThread)
		else
			hiddenfling = false
		end
	end)
	
end
coroutine.wrap(IIMAWH_fake_script)()
local function QCJQJL_fake_script() 
	local script = Instance.new('LocalScript', Frame)

	script.Parent.Active = true
	script.Parent.Draggable = true
end
coroutine.wrap(QCJQJL_fake_script)()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer


local TARGET_NAME = "Swing" 

local function createESP(obj)
    if not obj:FindFirstChild("SwingESP") then
        local box = Instance.new("Highlight")
        box.Name = "SwingESP"
        box.Adornee = obj
        box.FillColor = Color3.fromRGB(255, 0, 255) -- สีชมพู
        box.OutlineColor = Color3.fromRGB(255, 255, 255)
        box.Parent = obj
    end
end


task.spawn(function()
    while task.wait(2) do 
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") and string.find(obj.Name, TARGET_NAME) then
                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        createESP(part)
                    end
                end
            end
        end
    end
end)

print("nahee GUI v3 - Fully Loaded!") 


















local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViewPlayerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", screenGui)
frame.Position = UDim2.new(1, -370, 0, 100)
frame.Size = UDim2.new(0, 350, 0, 130)
frame.BorderSizePixel = 0
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(50, 50, 55)
frameStroke.Thickness = 1
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- ปุ่มยกเลิกการเลือกทั้งหมด (Unselect All) 'X'
local unselectAllButton = Instance.new("TextButton", frame)
unselectAllButton.Size = UDim2.new(0, 24, 0, 24)
unselectAllButton.Position = UDim2.new(0, 8, 0, 8)
unselectAllButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
unselectAllButton.TextColor3 = Color3.fromRGB(220, 220, 225)
unselectAllButton.Text = "X"
unselectAllButton.Font = Enum.Font.GothamBold
unselectAllButton.TextSize = 14
Instance.new("UICorner", unselectAllButton).CornerRadius = UDim.new(0, 6)

local unselectStroke = Instance.new("UIStroke", unselectAllButton)
unselectStroke.Color = Color3.fromRGB(60, 60, 65)
unselectStroke.Thickness = 1


local selectAllButton = Instance.new("TextButton", frame)
selectAllButton.Size = UDim2.new(0, 24, 0, 24)
selectAllButton.Position = UDim2.new(0, 36, 0, 8)
selectAllButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
selectAllButton.TextColor3 = Color3.fromRGB(220, 220, 225)
selectAllButton.Text = "A"
selectAllButton.Font = Enum.Font.GothamBold
selectAllButton.TextSize = 14
Instance.new("UICorner", selectAllButton).CornerRadius = UDim.new(0, 6)

local selectAllStroke = Instance.new("UIStroke", selectAllButton)
selectAllStroke.Color = Color3.fromRGB(60, 60, 65)
selectAllStroke.Thickness = 1

local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 24, 0, 24)
minimizeButton.Position = UDim2.new(1, -30, 0, 8)
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
minimizeButton.TextColor3 = Color3.fromRGB(220, 220, 225)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

local minStroke = Instance.new("UIStroke", minimizeButton)
minStroke.Color = Color3.fromRGB(60, 60, 65)
minStroke.Thickness = 1

local floatButton = Instance.new("TextButton", screenGui)
floatButton.Size = UDim2.new(0, 40, 0, 40)
floatButton.Position = UDim2.new(1, -60, 0, 100)
floatButton.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
floatButton.TextColor3 = Color3.fromRGB(240, 240, 245)
floatButton.Text = "+"
floatButton.Font = Enum.Font.GothamBold
floatButton.TextSize = 20
floatButton.Visible = false
Instance.new("UICorner", floatButton).CornerRadius = UDim.new(0, 10)

local floatStroke = Instance.new("UIStroke", floatButton)
floatStroke.Color = Color3.fromRGB(50, 50, 55)
floatStroke.Thickness = 1

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -95, 0, 30)
title.Position = UDim2.new(0, 65, 0, 5)
title.BackgroundTransparency = 1
title.Text = "nahee"
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local selectedPlayers = {}
local isDropdownOpen = false
local viewing = false
local viewConnection = nil
local savedTargetPositions = {}

local dropdown = Instance.new("TextButton", frame)
dropdown.Position = UDim2.new(0, 15, 0, 42)
dropdown.Size = UDim2.new(1, -30, 0, 32)
dropdown.Text = "Select Players (0 selected)"
dropdown.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 16
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

local dropdownStroke = Instance.new("UIStroke", dropdown)
dropdownStroke.Color = Color3.fromRGB(50, 50, 55)
dropdownStroke.Thickness = 1

local dropdownMenu = Instance.new("Frame", frame)
dropdownMenu.Position = UDim2.new(0, 15, 0, 78)
dropdownMenu.Size = UDim2.new(1, -30, 0, 0)
dropdownMenu.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
dropdownMenu.BorderSizePixel = 0
dropdownMenu.Visible = false
dropdownMenu.ClipsDescendants = true
Instance.new("UICorner", dropdownMenu).CornerRadius = UDim.new(0, 8)

local menuStroke = Instance.new("UIStroke", dropdownMenu)
menuStroke.Color = Color3.fromRGB(45, 45, 50)
menuStroke.Thickness = 1

local searchBar = Instance.new("TextBox", dropdownMenu)
searchBar.Size = UDim2.new(1, -8, 0, 28)
searchBar.Position = UDim2.new(0, 4, 0, 4)
searchBar.PlaceholderText = "Search players..."
searchBar.Text = ""
searchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 44)
searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBar.PlaceholderColor3 = Color3.fromRGB(120, 120, 125)
searchBar.Font = Enum.Font.Gotham
searchBar.TextSize = 14
searchBar.ClearTextOnFocus = true
Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 6)

local playerListFrame = Instance.new("ScrollingFrame", dropdownMenu)
playerListFrame.Position = UDim2.new(0, 4, 0, 36)
playerListFrame.Size = UDim2.new(1, -8, 1, -40)
playerListFrame.BackgroundTransparency = 1
playerListFrame.ScrollBarThickness = 6
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
local listLayout = Instance.new("UIListLayout", playerListFrame)
listLayout.Padding = UDim.new(0, 4)

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

local function updateDropdownText()
    local count = 0
    for _, _ in pairs(selectedPlayers) do count += 1 end
    if count == 0 then
        dropdown.Text = "Select Players (0 selected)"
    else
        dropdown.Text = "Selected: " .. count .. " players"
    end
end

-- ฟังก์ชันซ่อน/แสดงตัวละคร
local function hideCharacterCompletely(character, hide)
    if not character then return end
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then
            if part.Name == "HumanoidRootPart" then
                part.Transparency = 1
            else
                part.Transparency = hide and 1 or 0
            end
        elseif part:IsA("Decal") then
            part.Transparency = hide and 1 or 0
        elseif part:IsA("Accessory") then
            for _, subPart in ipairs(part:GetDescendants()) do
                if subPart:IsA("BasePart") or subPart:IsA("MeshPart") then
                    subPart.Transparency = hide and 1 or 0
                elseif subPart:IsA("Decal") then
                    subPart.Transparency = hide and 1 or 0
                end
            end
        elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
            part.Enabled = not hide
        end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = hide and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    end
end

local function refreshPlayers(filter)
    for _, c in pairs(playerListFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (not filter or string.find(p.DisplayName:lower(), filter:lower())) then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1,-4,0,28)
            
            local isSelected = selectedPlayers[p] ~= nil
            b.BackgroundColor3 = isSelected and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(70, 70, 70)
            b.TextColor3 = Color3.new(1,1,1)
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.Text = (isSelected and "✓ " or "  ") .. p.DisplayName
            
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
            b.Parent = playerListFrame
            
            b.MouseButton1Click:Connect(function()
                if selectedPlayers[p] then
                    if viewing and savedTargetPositions[p] then
                        pcall(function()
                            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                p.Character.HumanoidRootPart.CFrame = savedTargetPositions[p]
                                p.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                                p.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                                hideCharacterCompletely(p.Character, false)
                            end
                        end)
                        savedTargetPositions[p] = nil
                    end
                    selectedPlayers[p] = nil
                else
                    selectedPlayers[p] = p
                    if viewing and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        savedTargetPositions[p] = p.Character.HumanoidRootPart.CFrame
                        hideCharacterCompletely(p.Character, true)
                    end
                end
                updateDropdownText()
                refreshPlayers(searchBar.Text)
            end)
        end
    end
end

searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    refreshPlayers(searchBar.Text)
end)


unselectAllButton.MouseButton1Click:Connect(function()
    for p, pos in pairs(savedTargetPositions) do
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                p.Character.HumanoidRootPart.CFrame = pos
                p.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                p.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                hideCharacterCompletely(p.Character, false)
            end)
        end
    end
    
    for p, _ in pairs(selectedPlayers) do
        if p and p.Character then
            hideCharacterCompletely(p.Character, false)
        end
    end
    
    selectedPlayers = {}
    savedTargetPositions = {}
    updateDropdownText()
    refreshPlayers(searchBar.Text)
end)


selectAllButton.MouseButton1Click:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (searchBar.Text == "" or string.find(p.DisplayName:lower(), searchBar.Text:lower())) then
            if not selectedPlayers[p] then
                selectedPlayers[p] = p
                if viewing and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if not savedTargetPositions[p] then
                        savedTargetPositions[p] = p.Character.HumanoidRootPart.CFrame
                    end
                    hideCharacterCompletely(p.Character, true)
                end
            end
        end
    end
    updateDropdownText()
    refreshPlayers(searchBar.Text)
end)

local viewButton = Instance.new("TextButton", frame)
viewButton.Position = UDim2.new(0, 15, 0, 82)
viewButton.Size = UDim2.new(1, -30, 0, 35)
viewButton.Font = Enum.Font.GothamBold
viewButton.TextSize = 16
viewButton.Text = "ON"
viewButton.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
viewButton.TextColor3 = Color3.fromRGB(220, 220, 225)
Instance.new("UICorner", viewButton).CornerRadius = UDim.new(0, 8)

local btnStroke = Instance.new("UIStroke", viewButton)
btnStroke.Color = Color3.fromRGB(55, 55, 60)
btnStroke.Thickness = 1

local function updateLayout()
    if isDropdownOpen then
        dropdownMenu.Visible = true
        TweenService:Create(dropdownMenu, TweenInfo.new(0.3), {Size = UDim2.new(1,-30,0,240)}):Play()
        TweenService:Create(viewButton, TweenInfo.new(0.3), {Position = UDim2.new(0, 15, 0, 328)}):Play()
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 375)}):Play()
    else
        TweenService:Create(dropdownMenu, TweenInfo.new(0.3), {Size = UDim2.new(1,-30,0,0)}):Play()
        TweenService:Create(viewButton, TweenInfo.new(0.3), {Position = UDim2.new(0, 15, 0, 82)}):Play()
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 350, 0, 130)}):Play()
        task.wait(0.3)
        if not isDropdownOpen then dropdownMenu.Visible = false end
    end
end

dropdown.MouseButton1Click:Connect(function()
    isDropdownOpen = not isDropdownOpen
    if isDropdownOpen then
        refreshPlayers(searchBar.Text)
    end
    updateLayout()
end)

minimizeButton.MouseButton1Click:Connect(function()
    floatButton.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + 310, frame.Position.Y.Scale, frame.Position.Y.Offset)
    frame.Visible = false
    floatButton.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    frame.Position = UDim2.new(floatButton.Position.X.Scale, floatButton.Position.X.Offset - 310, floatButton.Position.Y.Scale, floatButton.Position.Y.Offset)
    floatButton.Visible = false
    frame.Visible = true
end)

viewButton.MouseButton1Click:Connect(function()
    viewing = not viewing
    
    if viewing then
        viewButton.Text = "OFF"
        viewButton.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
        viewButton.TextColor3 = Color3.fromRGB(20, 20, 22)
        savedTargetPositions = {}
        
        for _, p in pairs(selectedPlayers) do
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                savedTargetPositions[p] = p.Character.HumanoidRootPart.CFrame
                hideCharacterCompletely(p.Character, true)
            end
        end
        
        viewConnection = RunService.Heartbeat:Connect(function()
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHrp then return end
            
            local activeList = {}
            for _, p in pairs(selectedPlayers) do
                if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    table.insert(activeList, p)
                end
            end
            
            local count = #activeList
            if count == 0 then return end
            
            local angleStep = (math.pi * 2) / count
            for i, p in ipairs(activeList) do
                local tHrp = p.Character.HumanoidRootPart
                pcall(function()
                    local angle = i * angleStep
                    local offset = CFrame.new(math.cos(angle) * 4, 0, math.sin(angle) * 4)
                    
                    tHrp.CFrame = myHrp.CFrame * offset
                    tHrp.Velocity = Vector3.new(0, 0, 0)
                    tHrp.RotVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end)
    else
        viewButton.Text = "ON"
        viewButton.BackgroundColor3 = Color3.fromRGB(36, 36, 40)
        viewButton.TextColor3 = Color3.fromRGB(220, 220, 225)
        
        if viewConnection then
            viewConnection:Disconnect()
            viewConnection = nil
        end
        
        for p, pos in pairs(savedTargetPositions) do
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = p.Character.HumanoidRootPart
                pcall(function()
                    tHrp.CFrame = pos
                    tHrp.Velocity = Vector3.new(0, 0, 0)
                    tHrp.RotVelocity = Vector3.new(0, 0, 0)
                    hideCharacterCompletely(p.Character, false)
                end)
            end
        end
        savedTargetPositions = {}
    end
end)

local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

local floatDragging = false
local floatDragInput, floatDragStart, floatStartPos

floatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        floatDragging = true
        floatDragStart = input.Position
        floatStartPos = floatButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then floatDragging = false end
        end)
    end
end)

floatButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then floatDragInput = input end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    if floatDragging and floatDragInput then
        local delta = floatDragInput.Position - floatDragStart
        floatButton.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X,
                                         floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
    end
end)

local guiVisible = true
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.L then
        guiVisible = not guiVisible
        if guiVisible then
            frame.Visible = true
            floatButton.Visible = false
        else
            frame.Visible = false
            floatButton.Visible = false
        end
    end
end)
