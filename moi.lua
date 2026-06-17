local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local username = LocalPlayer.Name
local configPath = username .. "-sendmailgag2.json"

local defaultConfig = {
    Recipient = "enter recipient name",
    RecipientUserId = 0,
    Note = "Mtr Chill",
    Seeds = {
        Bamboo              = { enabled = false, amount = 1 },
        ["Glow Mushroom"]   = { enabled = false, amount = 1 },
        Mushroom            = { enabled = false, amount = 1 },
        ["Gold Seed"]       = { enabled = false, amount = 1 },
        ["Rainbow Seed"]    = { enabled = false, amount = 1 },
        Acorn               = { enabled = false, amount = 1 },
        Apple               = { enabled = false, amount = 1 },
        ["Baby Cactus"]     = { enabled = false, amount = 1 },
        Banana              = { enabled = false, amount = 1 },
        Blueberry           = { enabled = false, amount = 1 },
        Cactus              = { enabled = false, amount = 1 },
        Carrot              = { enabled = false, amount = 1 },
        Cherry              = { enabled = false, amount = 1 },
        Coconut             = { enabled = false, amount = 1 },
        Corn                = { enabled = false, amount = 1 },
        ["Dragon Fruit"]    = { enabled = false, amount = 1 },
        ["Dragon's Breath"] = { enabled = false, amount = 1 },
        ["Ghost Pepper"]    = { enabled = false, amount = 1 },
        Grape               = { enabled = false, amount = 1 },
        ["Green Bean"]      = { enabled = false, amount = 1 },
        ["Horned Melon"]    = { enabled = false, amount = 1 },
        Mango               = { enabled = false, amount = 1 },
        ["Moon Bloom"]      = { enabled = false, amount = 1 },
        Pineapple           = { enabled = false, amount = 1 },
        ["Poison Apple"]    = { enabled = false, amount = 1 },
        ["Poison Ivy"]      = { enabled = false, amount = 1 },
        Pomegranate         = { enabled = false, amount = 1 },
        Romanesco           = { enabled = false, amount = 1 },
        Strawberry          = { enabled = false, amount = 1 },
        Sunflower           = { enabled = false, amount = 1 },
        Tomato              = { enabled = false, amount = 1 },
        Tulip               = { enabled = false, amount = 1 },
        ["Venus Fly Trap"]  = { enabled = false, amount = 1 },
    },
    Pets = {
        Bee             = { enabled = false, amount = 1 },
        BlackDragon     = { enabled = false, amount = 1 },
        Bunny           = { enabled = false, amount = 1 },
        Deer            = { enabled = false, amount = 1 },
        Frog            = { enabled = false, amount = 1 },
        GoldenDragonfly = { enabled = false, amount = 1 },
        IceSerpent      = { enabled = false, amount = 1 },
        Monkey          = { enabled = false, amount = 1 },
        Owl             = { enabled = false, amount = 1 },
        Raccoon         = { enabled = false, amount = 1 },
        Robin           = { enabled = false, amount = 1 },
        Unicorn         = { enabled = false, amount = 1 },
    },
}

local function loadConfig()
    if isfile and isfile(configPath) then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(configPath))
        end)
        if ok and type(decoded) == "table" then
            return decoded
        end
    end
    return nil
end

local function saveConfig(cfg)
    if writefile then
        local ok, encoded = pcall(function()
            return HttpService:JSONEncode(cfg)
        end)
        if ok then
            writefile(configPath, encoded)
        end
    end
end

local savedCfg = loadConfig()
local cfg = savedCfg or {}

for section, items in pairs(defaultConfig) do
    if type(items) == "table" and section ~= "Recipient" and section ~= "RecipientUserId" and section ~= "Note" then
        cfg[section] = cfg[section] or {}
        for name, def in pairs(items) do
            cfg[section][name] = cfg[section][name] or { enabled = false, amount = def.amount }
        end
    end
end
cfg.Recipient       = cfg.Recipient       or defaultConfig.Recipient
cfg.RecipientUserId = cfg.RecipientUserId or defaultConfig.RecipientUserId
cfg.Note            = cfg.Note            or defaultConfig.Note

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoMailGAG2_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local C = {
    bg           = Color3.fromRGB(18, 18, 24),
    panel        = Color3.fromRGB(26, 26, 36),
    border       = Color3.fromRGB(50, 50, 70),
    accent       = Color3.fromRGB(80, 200, 140),
    text         = Color3.fromRGB(220, 220, 230),
    muted        = Color3.fromRGB(130, 130, 155),
    red          = Color3.fromRGB(220, 70, 70),
    tab          = Color3.fromRGB(35, 35, 50),
    tabSel       = Color3.fromRGB(50, 180, 110),
    itemBg       = Color3.fromRGB(30, 30, 44),
    itemOn       = Color3.fromRGB(20, 65, 45),
    itemOnBorder = Color3.fromRGB(60, 200, 120),
    header       = Color3.fromRGB(22, 22, 32),
}

local function mkFrame(parent, size, pos, bg, radius, border)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = pos
    f.BackgroundColor3 = bg or C.panel
    f.BorderSizePixel = 0
    if radius then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius)
        c.Parent = f
    end
    if border then
        local s = Instance.new("UIStroke")
        s.Color = border
        s.Thickness = 1
        s.Parent = f
    end
    f.Parent = parent
    return f
end

local function mkLabel(parent, text, size, color, font, align)
    local l = Instance.new("TextLabel")
    l.Text = text
    l.TextSize = size or 13
    l.TextColor3 = color or C.text
    l.Font = font or Enum.Font.Gotham
    l.BackgroundTransparency = 1
    l.TextXAlignment = align or Enum.TextXAlignment.Left
    l.Size = UDim2.new(1, 0, 0, size and size + 6 or 19)
    l.Parent = parent
    return l
end

local function mkBtn(parent, text, size, pos, bg, textColor)
    local b = Instance.new("TextButton")
    b.Text = text
    b.Size = size
    b.Position = pos or UDim2.new(0, 0, 0, 0)
    b.BackgroundColor3 = bg or C.accent
    b.TextColor3 = textColor or Color3.fromRGB(10, 10, 20)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    b.Parent = parent
    return b
end

local Main = mkFrame(ScreenGui,
    UDim2.new(0, 340, 0, 530),
    UDim2.new(0.5, -170, 0.5, -265),
    C.bg, 10, C.border)
Main.ClipsDescendants = true

local dragging, dragStart, startPos
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Header = mkFrame(Main, UDim2.new(1, 0, 0, 38), UDim2.new(0, 0, 0, 0), C.header, 0)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
mkFrame(Header, UDim2.new(1, 0, 0, 10), UDim2.new(0, 0, 1, -10), C.header)

local titleLbl = mkLabel(Header, "📦 AutoMail By Mtr Chill", 14, C.accent, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.Size = UDim2.new(1, -80, 1, 0)

local senderLbl = mkLabel(Header, "Sender: " .. username, 11, C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Left)
senderLbl.Position = UDim2.new(0, 12, 0, 20)
senderLbl.Size = UDim2.new(1, -80, 0, 16)

local closeBtn = mkBtn(Header, "✕", UDim2.new(0, 26, 0, 26), UDim2.new(1, -32, 0.5, -13), C.red, Color3.new(1, 1, 1))
closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local MTBtn = Instance.new("TextButton")
MTBtn.Size = UDim2.new(0, 48, 0, 48)
MTBtn.Position = UDim2.new(0, 20, 0.5, -24)
MTBtn.BackgroundColor3 = Color3.fromRGB(14, 40, 24)
MTBtn.TextColor3 = Color3.fromRGB(80, 200, 140)
MTBtn.Text = "MT"
MTBtn.Font = Enum.Font.GothamBold
MTBtn.TextSize = 15
MTBtn.BorderSizePixel = 0
MTBtn.ZIndex = 10
Instance.new("UICorner", MTBtn).CornerRadius = UDim.new(1, 0)
local mtStroke = Instance.new("UIStroke")
mtStroke.Color = Color3.fromRGB(60, 180, 100)
mtStroke.Thickness = 2
mtStroke.Parent = MTBtn
MTBtn.Parent = ScreenGui

local mtDragStart, mtStartPos, mtMoved
MTBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        mtDragStart = inp.Position
        mtStartPos = MTBtn.Position
        mtMoved = false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if mtDragStart and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = inp.Position - mtDragStart
        if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
            mtMoved = true
        end
        if mtMoved then
            MTBtn.Position = UDim2.new(
                mtStartPos.X.Scale, mtStartPos.X.Offset + delta.X,
                mtStartPos.Y.Scale, mtStartPos.Y.Offset + delta.Y)
        end
    end
end)
MTBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        if not mtMoved then
            Main.Visible = not Main.Visible
            MTBtn.BackgroundColor3 = Main.Visible and Color3.fromRGB(14, 40, 24) or Color3.fromRGB(40, 14, 14)
            MTBtn.TextColor3       = Main.Visible and Color3.fromRGB(80, 200, 140) or Color3.fromRGB(200, 80, 80)
        end
        mtDragStart = nil
        mtMoved = false
    end
end)

local recipRow = mkFrame(Main, UDim2.new(1, -20, 0, 28), UDim2.new(0, 10, 0, 44), C.panel, 6, C.border)
local recipIcon = mkLabel(recipRow, "→", 12, C.muted, Enum.Font.GothamBold)
recipIcon.Size = UDim2.new(0, 20, 1, 0)
recipIcon.Position = UDim2.new(0, 6, 0, 0)
recipIcon.TextXAlignment = Enum.TextXAlignment.Center

local recipBox = Instance.new("TextBox")
recipBox.Text = cfg.Recipient or ""
recipBox.PlaceholderText = "Recipient name..."
recipBox.Size = UDim2.new(1, -30, 1, 0)
recipBox.Position = UDim2.new(0, 26, 0, 0)
recipBox.BackgroundTransparency = 1
recipBox.TextColor3 = C.text
recipBox.PlaceholderColor3 = C.muted
recipBox.TextSize = 12
recipBox.Font = Enum.Font.Gotham
recipBox.TextXAlignment = Enum.TextXAlignment.Left
recipBox.Parent = recipRow
recipBox:GetPropertyChangedSignal("Text"):Connect(function()
    cfg.Recipient = recipBox.Text
    saveConfig(cfg)
end)

local noteRow = mkFrame(Main, UDim2.new(1, -20, 0, 26), UDim2.new(0, 10, 0, 76), C.panel, 6, C.border)
local noteBox = Instance.new("TextBox")
noteBox.Text = cfg.Note or ""
noteBox.PlaceholderText = "Note..."
noteBox.Size = UDim2.new(1, -10, 1, 0)
noteBox.Position = UDim2.new(0, 8, 0, 0)
noteBox.BackgroundTransparency = 1
noteBox.TextColor3 = C.muted
noteBox.PlaceholderColor3 = C.border
noteBox.TextSize = 11
noteBox.Font = Enum.Font.Gotham
noteBox.TextXAlignment = Enum.TextXAlignment.Left
noteBox.Parent = noteRow
noteBox:GetPropertyChangedSignal("Text"):Connect(function()
    cfg.Note = noteBox.Text
    saveConfig(cfg)
end)

local tabBar = mkFrame(Main, UDim2.new(1, -20, 0, 28), UDim2.new(0, 10, 0, 108), C.panel, 6)
local tabNames = { "Seeds", "Pets", "Log" }
local activeTab = "Seeds"
local tabBtns = {}

for i, name in ipairs(tabNames) do
    local tabW = 100
    local tb = mkBtn(tabBar, name,
        UDim2.new(0, tabW, 1, -4),
        UDim2.new(0, (i - 1) * (tabW + 4) + 2, 0, 2),
        C.tab, C.muted)
    tb.Font = Enum.Font.GothamBold
    tb.TextSize = 12
    tabBtns[name] = tb
end

local searchRow = mkFrame(Main, UDim2.new(1, -20, 0, 28), UDim2.new(0, 10, 0, 140), C.panel, 6, C.border)
local searchIcon = mkLabel(searchRow, "🔍", 12, C.muted, Enum.Font.Gotham)
searchIcon.Size = UDim2.new(0, 24, 1, 0)
searchIcon.TextXAlignment = Enum.TextXAlignment.Center

local searchBox = Instance.new("TextBox")
searchBox.Text = ""
searchBox.PlaceholderText = "Search items..."
searchBox.Size = UDim2.new(1, -28, 1, 0)
searchBox.Position = UDim2.new(0, 26, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.TextColor3 = C.text
searchBox.PlaceholderColor3 = C.muted
searchBox.TextSize = 12
searchBox.Font = Enum.Font.Gotham
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.Parent = searchRow

local listFrame = mkFrame(Main, UDim2.new(1, -20, 0, 228), UDim2.new(0, 10, 0, 174), C.panel, 6, C.border)
listFrame.ClipsDescendants = true

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = C.accent
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrollFrame

local listPad = Instance.new("UIPadding")
listPad.PaddingTop = UDim.new(0, 4)
listPad.PaddingLeft = UDim.new(0, 4)
listPad.PaddingRight = UDim.new(0, 4)
listPad.Parent = scrollFrame

local logFrame = mkFrame(Main, UDim2.new(1, -20, 0, 228), UDim2.new(0, 10, 0, 174), C.panel, 6, C.border)
logFrame.ClipsDescendants = true
logFrame.Visible = false

local logScroll = Instance.new("ScrollingFrame")
logScroll.Size = UDim2.new(1, 0, 1, 0)
logScroll.BackgroundTransparency = 1
logScroll.BorderSizePixel = 0
logScroll.ScrollBarThickness = 3
logScroll.ScrollBarImageColor3 = C.accent
logScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logScroll.Parent = logFrame

local logLayout = Instance.new("UIListLayout")
logLayout.Padding = UDim.new(0, 2)
logLayout.SortOrder = Enum.SortOrder.LayoutOrder
logLayout.Parent = logScroll

local logPad = Instance.new("UIPadding")
logPad.PaddingTop = UDim.new(0, 4)
logPad.PaddingLeft = UDim.new(0, 6)
logPad.PaddingRight = UDim.new(0, 4)
logPad.Parent = logScroll

local clearLogBtn = mkBtn(Main, "🗑 Clear Log", UDim2.new(1, -20, 0, 22),
    UDim2.new(0, 10, 0, 406), Color3.fromRGB(40, 20, 20), C.red)
clearLogBtn.TextSize = 11
clearLogBtn.Visible = false

local logCount = 0
local MAX_LOG = 300

local LOG_COLORS = {
    ok    = { bg = Color3.fromRGB(18, 55, 35),  text = Color3.fromRGB(80, 220, 140),  },
    fail  = { bg = Color3.fromRGB(55, 18, 18),  text = Color3.fromRGB(220, 80, 80),   },
    warn  = { bg = Color3.fromRGB(50, 38, 10),  text = Color3.fromRGB(220, 170, 50),  },
    info  = { bg = Color3.fromRGB(20, 28, 45),  text = Color3.fromRGB(120, 160, 220), },
    sep   = { bg = Color3.fromRGB(22, 22, 32),  text = Color3.fromRGB(70, 70, 90),    },
    gift  = { bg = Color3.fromRGB(20, 45, 55),  text = Color3.fromRGB(80, 190, 220),  },
    claim = { bg = Color3.fromRGB(35, 18, 55),  text = Color3.fromRGB(180, 130, 255), },
}

local function addLog(msg, kind)
    logCount += 1
    local frames = {}
    for _, c in ipairs(logScroll:GetChildren()) do
        if c:IsA("Frame") then table.insert(frames, c) end
    end
    if #frames >= MAX_LOG then frames[1]:Destroy() end

    if not kind then
        if msg:find("thành công") or msg:find("Gift OK") or msg:find("OK") then kind = "ok"
        elseif msg:find("fail") or msg:find("Fail") or msg:find("error") then kind = "fail"
        elseif msg:find("skip") or msg:find("Skip") then kind = "warn"
        elseif msg:find("Claim") or msg:find("claim") then kind = "claim"
        elseif msg:find("Gift") or msg:find("gift") then kind = "gift"
        elseif msg:find("──") or msg:find("---") then kind = "sep"
        else kind = "info" end
    end

    local scheme = LOG_COLORS[kind] or LOG_COLORS.info

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 18)
    row.BackgroundColor3 = scheme.bg
    row.BackgroundTransparency = 0.3
    row.LayoutOrder = logCount
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
    row.Parent = logScroll

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, -4)
    bar.Position = UDim2.new(0, 0, 0, 2)
    bar.BackgroundColor3 = scheme.text
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
    bar.Parent = row

    local timeLbl = Instance.new("TextLabel")
    timeLbl.Size = UDim2.new(0, 56, 1, 0)
    timeLbl.Position = UDim2.new(0, 4, 0, 0)
    timeLbl.BackgroundTransparency = 1
    timeLbl.TextColor3 = Color3.fromRGB(70, 70, 90)
    timeLbl.Font = Enum.Font.Gotham
    timeLbl.TextSize = 10
    timeLbl.TextXAlignment = Enum.TextXAlignment.Left
    timeLbl.Text = os.date("%H:%M:%S")
    timeLbl.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -64, 1, 0)
    lbl.Position = UDim2.new(0, 62, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = scheme.text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Text = msg:gsub("^[✅❌⚠ℹ🎁📬%s]+", "")
    lbl.Parent = row

    task.defer(function()
        logScroll.CanvasPosition = Vector2.new(0, math.huge)
    end)
end

clearLogBtn.MouseButton1Click:Connect(function()
    for _, c in ipairs(logScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    logCount = 0
    addLog("Log cleared", "sep")
end)

local statusBar = mkFrame(Main, UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 406), C.header)
local statusLbl = mkLabel(statusBar, "Ready", 11, C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Left)
statusLbl.Size = UDim2.new(1, 0, 1, 0)

local startBtn = mkBtn(Main, "▶  Start Gift ALL",
    UDim2.new(1, -20, 0, 28),
    UDim2.new(0, 10, 0, 430),
    C.accent, Color3.fromRGB(10, 20, 15))
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 13

local onceBtn = mkBtn(Main, "⚡  Send Gift Once",
    UDim2.new(1, -20, 0, 26),
    UDim2.new(0, 10, 0, 462),
    Color3.fromRGB(60, 80, 160), Color3.fromRGB(200, 210, 255))
onceBtn.Font = Enum.Font.GothamBold
onceBtn.TextSize = 12

local claimBtn = mkBtn(Main, "📬  Auto Claim Mail",
    UDim2.new(1, -20, 0, 26),
    UDim2.new(0, 10, 0, 496),
    Color3.fromRGB(70, 40, 100), Color3.fromRGB(210, 180, 255))
claimBtn.Font = Enum.Font.GothamBold
claimBtn.TextSize = 12

local function setStatus(msg, color)
    statusLbl.Text = msg
    statusLbl.TextColor3 = color or C.muted
end

local itemRows = {}
for _, t in ipairs(tabNames) do
    itemRows[t] = {}
end

local function buildRows(tabName)
    for _, ch in ipairs(scrollFrame:GetChildren()) do
        if ch:IsA("Frame") then ch:Destroy() end
    end

    local section = cfg[tabName] or {}
    local filter = searchBox.Text:lower()
    local order = 0

    local keys = {}
    for k in pairs(section) do table.insert(keys, k) end
    table.sort(keys, function(a, b)
        local ea = section[a] and section[a].enabled and 1 or 0
        local eb = section[b] and section[b].enabled and 1 or 0
        if ea ~= eb then return ea > eb end
        return a < b
    end)

    for _, name in ipairs(keys) do
        local data = section[name]
        if filter == "" or name:lower():find(filter, 1, true) then
            order += 1
            local row = mkFrame(scrollFrame,
                UDim2.new(1, -4, 0, 32),
                UDim2.new(0, 0, 0, 0),
                data.enabled and C.itemOn or C.itemBg,
                6,
                data.enabled and C.itemOnBorder or C.border)
            row.LayoutOrder = order

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(1, -80, 1, 0)
            toggleBtn.Position = UDim2.new(0, 0, 0, 0)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.Parent = row

            local dot = mkLabel(row, data.enabled and "●" or "○", 12,
                data.enabled and C.accent or C.muted, Enum.Font.GothamBold)
            dot.Size = UDim2.new(0, 18, 1, 0)
            dot.Position = UDim2.new(0, 8, 0, 0)
            dot.TextXAlignment = Enum.TextXAlignment.Center

            local nameLbl = mkLabel(row, name, 12, data.enabled and C.accent or C.text, Enum.Font.Gotham)
            nameLbl.Size = UDim2.new(1, -100, 1, 0)
            nameLbl.Position = UDim2.new(0, 28, 0, 0)

            local amtLbl = mkLabel(row, "x", 11, C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Right)
            amtLbl.Size = UDim2.new(0, 14, 1, 0)
            amtLbl.Position = UDim2.new(1, -72, 0, 0)

            local amtBox = Instance.new("TextBox")
            amtBox.Text = tostring(math.min(data.amount or 1, 10000))
            amtBox.Size = UDim2.new(0, 52, 0, 22)
            amtBox.Position = UDim2.new(1, -58, 0.5, -11)
            amtBox.BackgroundColor3 = C.bg
            amtBox.TextColor3 = C.text
            amtBox.TextSize = 12
            amtBox.Font = Enum.Font.GothamBold
            amtBox.TextXAlignment = Enum.TextXAlignment.Center
            amtBox.BorderSizePixel = 0
            Instance.new("UICorner", amtBox).CornerRadius = UDim.new(0, 4)
            local ams = Instance.new("UIStroke")
            ams.Color = C.border
            ams.Thickness = 1
            ams.Parent = amtBox
            amtBox.Parent = row

            amtBox.FocusLost:Connect(function()
                local v = math.clamp(math.floor(tonumber(amtBox.Text) or 1), 1, 10000)
                amtBox.Text = tostring(v)
                section[name].amount = v
                saveConfig(cfg)
            end)

            toggleBtn.MouseButton1Click:Connect(function()
                data.enabled = not data.enabled
                section[name].enabled = data.enabled
                saveConfig(cfg)
                buildRows(tabName)
            end)

            itemRows[tabName][name] = { frame = row, amtBox = amtBox }
        end
    end
end

local function switchTab(name)
    activeTab = name
    for _, t in ipairs(tabNames) do
        local tb = tabBtns[t]
        if t == name then
            tb.BackgroundColor3 = C.tabSel
            tb.TextColor3 = Color3.fromRGB(10, 20, 15)
        else
            tb.BackgroundColor3 = C.tab
            tb.TextColor3 = C.muted
        end
    end
    local isLog = name == "Log"
    listFrame.Visible = not isLog
    searchRow.Visible = not isLog
    logFrame.Visible = isLog
    clearLogBtn.Visible = isLog
    if not isLog then
        buildRows(name)
    end
end

for _, name in ipairs(tabNames) do
    tabBtns[name].MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    buildRows(activeTab)
end)

switchTab("Seeds")

local SharedModules = ReplicatedStorage:WaitForChild("SharedModules", 10)
local Networking = nil
if SharedModules then
    local nm = SharedModules:FindFirstChild("Networking")
    if nm then
        local ok, r = pcall(require, nm)
        if ok then Networking = r end
    end
end

local function resolveUserId(name, userId)
    if userId and userId > 0 then return userId end
    local ok, id = pcall(function()
        return Players:GetUserIdFromNameAsync(name)
    end)
    if ok and type(id) == "number" then return id end
    return nil
end

local function lookupRecipient()
    if not Networking or not Networking.Mailbox or not Networking.Mailbox.LookupPlayer then
        return nil, "Networking.Mailbox not found"
    end
    local ok, uid, displayName = pcall(function()
        return Networking.Mailbox.LookupPlayer:Fire(cfg.Recipient)
    end)
    if not ok or type(uid) ~= "number" or uid <= 0 then
        return nil, "Recipient not found: " .. tostring(cfg.Recipient)
    end
    return uid, displayName
end

local function sendBatch(uid, payload, note)
    if not Networking or not Networking.Mailbox or not Networking.Mailbox.SendBatch then
        return false, "SendBatch not available"
    end
    local ok, result, msg = pcall(function()
        return Networking.Mailbox.SendBatch:Fire(uid, payload, tostring(note or ""))
    end)
    if not ok then return false, tostring(result) end
    if result == true then return true, tostring(msg or "OK") end
    return false, tostring(msg or "Send error")
end

local SEED_KEY_MAP = {
    ["Gold Seed"]        = "Gold",
    ["Rainbow Seed"]     = "Rainbow",
    ["Baby Cactus"]      = "BabyCactus",
    ["Dragon Fruit"]     = "DragonFruit",
    ["Dragon's Breath"]  = "DragonsBreath",
    ["Ghost Pepper"]     = "GhostPepper",
    ["Glow Mushroom"]    = "GlowMushroom",
    ["Green Bean"]       = "GreenBean",
    ["Horned Melon"]     = "HornedMelon",
    ["Moon Bloom"]       = "MoonBloom",
    ["Poison Apple"]     = "PoisonApple",
    ["Poison Ivy"]       = "PoisonIvy",
    ["Venus Fly Trap"]   = "VenusFlyTrap",
}

local _PlayerStateClient = nil
pcall(function()
    _PlayerStateClient = require(
        ReplicatedStorage:WaitForChild("ClientModules", 10)
        :WaitForChild("PlayerStateClient", 10)
    )
end)

local function getInvSafe()
    if not _PlayerStateClient then return nil end
    local replica = nil
    if type(_PlayerStateClient.WaitForLocalReplica) == "function" then
        local ok, r = pcall(function()
            return _PlayerStateClient:WaitForLocalReplica(15)
        end)
        if ok and r then replica = r end
    end
    if not replica and type(_PlayerStateClient.GetLocalReplica) == "function" then
        local started = os.clock()
        repeat
            local ok, r = pcall(function()
                return _PlayerStateClient:GetLocalReplica()
            end)
            if ok and r then replica = r break end
            task.wait(0.25)
        until os.clock() - started > 15
    end
    if replica and type(replica.Data) == "table" then
        return replica.Data.Inventory
    end
    return nil
end

local PET_NAME_FIELDS = { "Name", "PetName", "Species", "DisplayName", "Type", "Kind" }

local function resolvePetName(entry)
    for _, field in ipairs(PET_NAME_FIELDS) do
        if entry[field] ~= nil and tostring(entry[field]) ~= "" then
            return tostring(entry[field])
        end
    end
    return ""
end

local function collectPayload()
    local payload = {}
    local inv = getInvSafe()

    for name, data in pairs(cfg["Seeds"] or {}) do
        if type(data) == "table" and data.enabled then
            local amt = math.clamp(math.floor(tonumber(data.amount) or 1), 1, 9999)
            table.insert(payload, {
                Category    = "Seeds",
                ItemKey     = SEED_KEY_MAP[name] or name,
                Count       = amt,
                DisplayName = name,
            })
        end
    end

    local petCfg = cfg["Pets"] or {}
    local quota = {}
    for name, data in pairs(petCfg) do
        if type(data) == "table" and data.enabled then
            quota[name] = math.clamp(math.floor(tonumber(data.amount) or 1), 1, 10000)
        end
    end

    if next(quota) ~= nil and inv and type(inv.Pets) == "table" then
        local used = {}
        for itemKey, entry in pairs(inv.Pets) do
            if type(entry) == "table" and entry.Id ~= nil then
                local petName = resolvePetName(entry)
                local normEntry = petName:lower():gsub("%s+", "")
                for cfgName, q in pairs(quota) do
                    if cfgName:lower():gsub("%s+", "") == normEntry or cfgName == petName then
                        used[cfgName] = used[cfgName] or 0
                        if used[cfgName] < q
                            and entry.Equipped ~= true
                            and entry.Locked ~= true
                            and entry.Favorite ~= true
                            and entry.Favorited ~= true
                        then
                            used[cfgName] += 1
                            table.insert(payload, {
                                Category    = "Pets",
                                ItemKey     = tostring(itemKey),
                                Count       = 1,
                                DisplayName = petName ~= "" and petName or cfgName,
                            })
                        end
                        break
                    end
                end
            end
        end
    end

    return payload
end

local running = false

local function getTargetUid()
    local uid, err = lookupRecipient()
    if not uid then
        uid = resolveUserId(cfg.Recipient, tonumber(cfg.RecipientUserId) or 0)
    end
    if not uid then return nil, err or "Recipient not found" end
    if uid == LocalPlayer.UserId then return nil, "Cannot send to yourself" end
    return uid, nil
end

local function sendOneRound(uid, total, skip)
    local payload = collectPayload()
    if #payload == 0 then
        setStatus("⚠ No items selected!", C.muted)
        return total, skip
    end
    for i, item in ipairs(payload) do
        setStatus(string.format(
            "📨 [%d/%d] %s x%d  |  sent: %d",
            i, #payload, item.DisplayName, item.Count, total
        ), C.accent)
        local ok2, msg2 = sendBatch(uid, {
            { Category = item.Category, ItemKey = item.ItemKey, Count = item.Count }
        }, cfg.Note)
        if ok2 then
            local actualCount = tonumber(tostring(msg2):match("%d+")) or item.Count
            total += actualCount
            if actualCount < item.Count then
                addLog(string.format("Gift %s: sent x%d / requested x%d", item.DisplayName, actualCount, item.Count), "warn")
            else
                addLog(string.format("Gift %s x%d — OK", item.DisplayName, actualCount), "ok")
            end
        else
            skip += 1
            addLog(string.format("Gift %s — FAIL: %s", item.DisplayName, tostring(msg2 or "unknown")), "fail")
        end
        if i < #payload then
            task.wait(1.8)
        end
    end
    return total, skip
end

local stopRequested = false

startBtn.MouseButton1Click:Connect(function()
    if running then
        stopRequested = true
        startBtn.Text = "⏳ Stopping after this round..."
        startBtn.BackgroundColor3 = Color3.fromRGB(160, 80, 20)
        return
    end
    setStatus("Looking up recipient...", C.muted)
    local uid, err = getTargetUid()
    if not uid then setStatus("❌ " .. err, C.red) return end

    local payload = collectPayload()
    if #payload == 0 then setStatus("⚠ No items selected!", C.muted) return end

    running = true
    stopRequested = false
    startBtn.Text = "⏹  Stop"
    startBtn.BackgroundColor3 = C.red
    startBtn.TextColor3 = Color3.new(1, 1, 1)

    local roundTotal, roundSkip = 0, 0
    task.spawn(function()
        while true do
            roundTotal, roundSkip = sendOneRound(uid, roundTotal, roundSkip)
            if stopRequested then break end
            setStatus(string.format("🔄 Round done | sent: %d | skipped: %d — continuing...", roundTotal, roundSkip), C.accent)
            task.wait(1)
        end
        running = false
        stopRequested = false
        startBtn.Text = "▶  Start Gift ALL"
        startBtn.BackgroundColor3 = C.accent
        startBtn.TextColor3 = Color3.fromRGB(10, 20, 15)
        addLog(string.format("Stopped | sent: %d | skipped: %d", roundTotal, roundSkip), "sep")
        setStatus(string.format("⏹ Stopped | total sent: %d | skipped: %d", roundTotal, roundSkip), C.muted)
    end)
end)

onceBtn.MouseButton1Click:Connect(function()
    if running then
        setStatus("⚠ Loop is running, stop it first", C.red)
        return
    end
    setStatus("Looking up recipient...", C.muted)
    local uid, err = getTargetUid()
    if not uid then setStatus("❌ " .. err, C.red) return end

    local payload = collectPayload()
    if #payload == 0 then setStatus("⚠ No items selected!", C.muted) return end

    onceBtn.Text = "⏳ Sending..."
    onceBtn.BackgroundColor3 = Color3.fromRGB(40, 55, 110)
    running = true

    local total, skip = 0, 0
    task.spawn(function()
        total, skip = sendOneRound(uid, total, skip)
        running = false
        onceBtn.Text = "⚡  Send Gift Once"
        onceBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 160)
        addLog(string.format("Done | sent: %d | skipped: %d", total, skip), "info")
        setStatus(string.format("✅ Done | sent: %d | skipped: %d", total, skip), skip > 0 and C.red or C.accent)
    end)
end)

local claimRunning = false

claimBtn.MouseButton1Click:Connect(function()
    if claimRunning then
        claimRunning = false
        claimBtn.Text = "📬  Auto Claim Mail"
        claimBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
        claimBtn.TextColor3 = Color3.fromRGB(210, 180, 255)
        setStatus("⏹ Claim stopped", C.muted)
        return
    end
    if not Networking or not Networking.Mailbox then
        setStatus("❌ Networking.Mailbox not found", C.red)
        return
    end

    claimRunning = true
    claimBtn.Text = "⏹  Stop Claim"
    claimBtn.BackgroundColor3 = C.red
    claimBtn.TextColor3 = Color3.new(1, 1, 1)

    task.spawn(function()
        local totalClaimed = 0
        local CLAIM_DELAY = 0.3

        while claimRunning do
            local inbox = nil
            local ok, result = pcall(function()
                return Networking.Mailbox.OpenInbox:Fire()
            end)
            if ok and type(result) == "table" then
                inbox = type(result.Mailbox) == "table" and result.Mailbox or result
            end

            if not inbox or next(inbox) == nil then
                setStatus(string.format("📭 Inbox empty | claimed: %d", totalClaimed), C.muted)
                task.wait(2)
            else
                local ids = {}
                for mailId in pairs(inbox) do
                    if type(mailId) == "string" then table.insert(ids, mailId) end
                end
                for i, mailId in ipairs(ids) do
                    if not claimRunning then break end
                    setStatus(string.format("📬 Claiming [%d/%d] | total: %d", i, #ids, totalClaimed), Color3.fromRGB(210, 180, 255))
                    local cok, success, reason = pcall(function()
                        return Networking.Mailbox.Claim:Fire(mailId)
                    end)
                    if cok and success then
                        totalClaimed += 1
                        addLog("Claimed mail #" .. i, "claim")
                    else
                        addLog("Claim failed #" .. i .. ": " .. tostring(reason or success), "fail")
                    end
                    task.wait(CLAIM_DELAY)
                end
            end
        end

        claimBtn.Text = "📬  Auto Claim Mail"
        claimBtn.BackgroundColor3 = Color3.fromRGB(70, 40, 100)
        claimBtn.TextColor3 = Color3.fromRGB(210, 180, 255)
        setStatus(string.format("✅ Claim done | total: %d", totalClaimed), C.accent)
    end)
end)

UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.LeftControl then
        Main.Visible = not Main.Visible
    end
end)

task.spawn(function()
    while true do
        task.wait(3)
        if not running then
            local inv = getInvSafe()
            if inv then
                local petQuota = {}
                for name, data in pairs(cfg["Pets"] or {}) do
                    if type(data) == "table" and data.enabled then
                        petQuota[name] = true
                    end
                end
                local petCount = 0
                if next(petQuota) ~= nil and type(inv.Pets) == "table" then
                    for _, entry in pairs(inv.Pets) do
                        if type(entry) == "table" and entry.Id ~= nil then
                            local petName = resolvePetName(entry)
                            local ne = petName:lower():gsub("%s+", "")
                            for cfgName in pairs(petQuota) do
                                if cfgName:lower():gsub("%s+", "") == ne then
                                    petCount += 1
                                    break
                                end
                            end
                        end
                    end
                end
                if petCount > 0 then
                    setStatus(string.format("🔍 Ready | 🐾 %d pet(s) available to send", petCount), C.accent)
                else
                    setStatus("🔍 No selected pets found in inventory", C.muted)
                end
            else
                setStatus("⚠ Could not read inventory", C.muted)
            end
        end
    end
end)

setStatus("Config: " .. configPath, C.muted)
