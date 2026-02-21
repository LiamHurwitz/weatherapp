local sceneMgr = require "sceneManager"

-- TEMP: Set default background color for the entire app
love.graphics.setBackgroundColor(0.95, 0.96, 0.97) -- Light pastel

function love.load()
    sceneMgr.changeScene("scenes.menu")
end

