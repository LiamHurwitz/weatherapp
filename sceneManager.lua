-- Source: https://gist.github.com/EngineerSmith/7d269d21e2b0e6d3e4f98f4eef7019dc


-- I'm unaware of such a tutorial - but you can always attempt it yourself.
-- I use my own scene manager to switch between things like the main menu to the game https://gist.github.com/EngineerSmith/7d269d21e2b0e6d3e4f98f4eef7019dc
-- Basically replaces the love callbacks where need be for your scene
-- I made a quick example of a splash scene that works with it
-- https://gist.github.com/EngineerSmith/7da38ba31823968b395aceab540855eb
-- The above would be called in main.lua as such:
-- ```lua
-- love.load = function(args)
-- require("sceneManager").changeScene("scenes.example_scene", args) -- if file was within scenes folder
-- end}
-- ```

-- It helps separate your code out. Now all you need to do if make some buttons which call the `changeScene` function when you want to switch to your game in the main menu


local sceneManager = {
    currentScene = nil
    nilFunc = function() end,
    sceneHandlers = {
        -- Game loop
        "load",
        "unload",
        "update", -- Omitted updateNetwork from example since not multiplayer
        "draw",
        "quit",
        -- Window
        "focus",
        "resize",
        "visable",
        "displayrotated",
        "filedropped",
        "directorydropped",
        -- Mouse input
        "mousepressed",
        "mousemoved",
        "mousefocus",
        "wheelmoved",
        -- Key input
        "keypressed",
        "keyreleased",
        "textinput",
        "textexited",
        -- Errors
        "threaderror",
        "lowmemory",
    },
}

sceneManager.changeScene = function(scene, ...)
    -- Usage `require("sceneManager").changeScene("scenes.gameScene")
    scene = require(scene)
    if sceneManager.currentScene then
        love.unload()
    end
    for _, v in ipairs(sceneManager.sceneHandlers) do 
        love[v] = scene[v] or sceneManager.nilFunc
    end
    sceneManager.currentScene = scene
    collectgarbage("collect")
    collectgarbage("collect")
    love.load(...)
end

return sceneManager