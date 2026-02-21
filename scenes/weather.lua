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
local catSprties = {
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

    