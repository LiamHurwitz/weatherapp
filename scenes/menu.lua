local scene = {}

local homeTowns = { "Duvall", "Oxnard" }

-- UI state
local selectedTown = nil
local searchText = ""
local inputActive = false

local font = love.graphics.newFont(18)

-- Helper function to draw a rounded rectangle button
local function drawButton(x, y, w, h, label, hovered)
    local bg = hovered and {0.8, 0.9, 1} or {0.9. 0.95, 1}
    love.graphics.setColor(bg)
    love.graphics.rectangle("fill", x, y, w, h, 8, 8)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(label, x, y + h/2 - font:getHeight()/2, w, "center")
end

function scene.load() -- Nothing here yet

end

function scene.update(dt)
    -- No animations yet; menu is static for now
end

function scene.draw()
    love.graphics.setFont(font)

    local mx, my = love.mouse.getPosition()
    local btnW, btnH = 200, 40
    local startY = 120
    local spacing = 60

    -- Draw the preset town buttons
    for i, town in ipairs(homeTowns) do
        local x = (love.graphics.getWidth() - btnW) / 2
        local y = startY + (i - 1) * spacing
        local hovered = mx >= x and mx <= x + btnW and my = y and my <= y + btnH
        drawButton(x, y, btnW, btnH, town, hovered)
    end

    -- Draw the search box
    local boxW, boxH = 260, 40
    local bx = (love.graphics.getWidth() - boxW) / 2
    local by = startY + #homeTowns * spacing + 20
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", bx, by, boxW, boxH, 6, 6)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(searchText .. (inputActive and "|" or ""), bx + 8, by + 8)

    -- Draw "GO" button
    local gx = bx + boxW + 10
    local gy = by
    local goHovered = mx >= gx and mx <= gx + 80 and my >= gy and my <= gy + boxH
    drawButton(gx, gy, 80, boxH, "Go", goHovered)
end

function scene.mousepressed(x, y, button)
    if button ~= 1 then return end -- Only allow left clicking

    local btnW, btnH = 200, 40
    local startY = 120
    local spacing = 60

    -- Check preset town buttons
    for i, town in ipairs(homeTowns) do
        local bx = (love.graphics.getWidth() - btnW) / 2
        local by = startY + (i - 1) * spacing
        if x >= bx and x <= bx + btnW and y >= by and y <= by + btnH then
            selectedTown = town
            -- Switch to the weather scene, passing the town name
            require("sceneManager").changeScene("scenes.weather", town)
            return
        end
    end

    -- Search box activation
    local boxW, boxH = 260, 40
    local bx = (love.graphics.getWidth() - boxW) / 2
    local by = startY + #homeTowns * spacing + 20
    inputActive = (x >= bx and x <= bx + boxW and y >= by and y <= by + boxH)

    -- "GO" button
    local gx = bx + boxW + 10
    local gy = by
    if x >= gx and x <= gx + 80 and y >= gy and y <= gy + boxH then
        local town = searchText:match("^%s*(.-)%s*$") -- This apparently trims whitespace
        if town ~= "" then
            require("sceneManager").changeScene("scenes.weather", town)
        end
    end
end

function scene.textinput(t)
    if inputActive then
        searchText = searchText .. t 
    end
end

function scene.keypressed(key)
    if inputActive and key == "backspace" then
        local byteoffset = utf8.offset(searchText, -1)
        if byteoffset then
            searchText = string.sub(searchText, 1, byteoffset - 1)
        end
    elseif key == "escape" then
        inputActive = false
    end
end

return scene

-- What this code does:
-- Click on one of the home towns -> Calls sceneManager.changeScene("scenes.weather", townname)
-- click the text box -> gives it a focus (inputActive = true)
-- type so text appears -> textinput appends characters
-- press backspace -> removes last characters
-- clock go -> trims the ended string and switches to the weather scene if non-empty