local json = require "dkjson"
local http = require "socket.http"
 -- Dependency TODO: place djjson.lua in path & unsure LuaSocket is bundled with love build

local scene = {}

local font = love.graphics.newFont(18)

local town = nil -- filled with load() fun.
local weatherData = nil -- This is the parsed json value from the API
local loading = nil
local errorMsg = nil

-- TODO: Find these weather cat sprites
local catSprites = {
    Clear = love.graphics.newImage("assets/cats/FILLHERE.png")
    Rain = love.graphics.newImage("assets/cats/FILLHERE.png")
    Snow = love.graphics.newImage("assets/cats/FILLHERE.png")
    Cloudy = love.graphics.newImage("assets/cats/FILLHERE.png")
    Default = love.graphics.newImage("assets/cats/FILLHERE.png")
}

-- Helper to map API weather codes to keys
local function mapCondition(main)
    main = main:lower()
    if main:find("clear") then return "Clear"
    elseif main:find("rain") or main:find("drizzle") then return "Rain"
    elseif main:find("cloudy") then return "Cloudy" 
    elseif main:find("snow") then return "Snow"
    else return "Default"
    end
end

function scene.load(passedTown)
    town = passedTown or "Unknown"
    loading = true
    errorMsg = nil
    weatherData = nil

    -- Use coroutine for request so Lua can keep cooking everything else
    local co = coroutine.create(function()
        local apiKey = "ADD API KEY HERE"
        local url = string.format("https://api.openweathermap.org/data/2.5/weather?q=%s&units=metric&appid=%s",
        love.filesystem.encodeURL(town), apiKey)

        local body, code, headers, status = http.request(url)
        if not body then
            errorMsg = "Network error - Couldn't reach the API :("
            loading = false
            return
        end 

        local decoded, pos, error = json.decode(body, 1, nil)
        if err then
            errorMsg = "Failed to parse the JSON :(. Go tell Liam to do better."
            loading = false
            return
        end

        weatherData = decoded
        loading = false
    end)

    -- Store coroutine for reuse each frame
    scene._requestCo = co
end

function scene.update(dt)
    if loading and scene._requestCo then
        local ok, msg = coroutine.resume(scene._requestCo)
        if not ok then
            errorMsg = "Unexpected Error: " .. tostring(msg)
            loading = false
        end
    end
end

function scene.draw()
    love.graphics.setFont(font)

    -- Background pastel color
    love.graphics.clear(0.93, 0.95, 0.98)

    if loading then
        love.graphics.printf("Fetching weather for" .. town .. "...", 0, love.graphics.getHeight()/2-20, love.graphics.getWidth(), "center")
        return
    end

    if errorMsg then
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.printf(errorMsg, 0, love.graphics.getHeight()/2-20, love.graphics.getWidth(), "center")
        return
    end

    -- At this point we should have all the Weather Data
    local mainCondition = weatherData.weather[1].main -- e.g. "Clear"
    local catKey = mapCondition(mainCondition)
    local catImage = catSprites[catKey] or catSprites.Default

    -- Draw the kitty centered
    local cx = love.graphics.getWidth() / 2
    local cy = love.graphics.getHeight() / 2 - 50
    local scale = 0.6
    love.graphics.draw(catImage, cx - catImage:getWidth() * scale / 2,
                        cy - catImage:getHeight() * scale / 2
                        0, scale, scale)
    
    -- Back button (simple text)
    local backText = "< Head back to menu"
    love.graphics.setColor(0.2, 0.4, 0.8)
    love.graphics.print(backText, 20, love.graphics.getHeight() - 30)
end

function scene.mousepressed(x, y, button)
    if button ~= 1 then return end
     -- Detect click on the back text area
    if y > love.graphics.getHeight()-40 and x < 150 then
        require("sceneManager").changeScene("scenes.menu")
    end
end

return scene