local GameState = {
}

local GeometryMode = {
    FILL = "fill",
    LINE = "line",
}

local windowWidth = 0
local windowHeight = 0

local ceiling = 0
local ground = 0

local gravity = 0

local player = {
    x = 0,
    y = 0,
    radius = 0,
}

local jetpack_velocity = 0

function love.load()
    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    ground = windowHeight / 4 * 3

    gravity = 20

    jetpack_velocity = 30

    player = {
        x = windowWidth / 3,
        y = ground,
        radius = 12,
    }
end

function love.update(delta)
    -- if press jump, jump
    -- while jump, being force down by gravity
    -- if hit ground, no more going down
    -- if jump action is pressed, change to push mousepressed

    -- spawn random object
    -- move random object

    -- spawn random point
    -- move random point
    -- better spawn in pattern
end

function love.draw()
    love.graphics.setColor(love.math.colorFromBytes(210, 4, 45))
    love.graphics.circle(GeometryMode.FILL, player.x, player.y, player.radius)
end

function love.keypressed(key, scancode, isrepeat)
    -- handle game menu
    -- handle pause menu
    -- handle shop
end

function love.mousepressed(x, y, button, isTouch)
end
