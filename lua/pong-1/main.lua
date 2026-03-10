local GameState = {
    MENU = 1,
    PLAYING = 2,
    PAUSED = 3,
    GAME_OVER = 4
}

local gameState = GameState.PLAYING

local windowWidth = love.graphics.getWidth()
local windowHeight = love.graphics.getHeight()

local paddleWidth = 10
local paddleHeight = 100

local GOAL_PADDING = 20

local player1 = {
    x = GOAL_PADDING,
    y = (windowHeight - paddleHeight) / 2,
    score = 0
}

local player2 = {
    x = windowWidth - paddleWidth - GOAL_PADDING,
    y = (windowHeight - paddleHeight) / 2,
    score = 0,
    isAI = false
}

local ball = {
    x = windowWidth / 2,
    y = windowHeight / 2,
    radius = 12,
    speed = 3
}

function love.load()
end

-- TODO: implement AI for player 2
function love.update(delta)
end

function love.draw()
    if gameState == GameState.PLAYING then
        -- Draw the 2 paddles
        love.graphics.setColor(160, 160, 160)

        -- Paddle 1
        love.graphics.rectangle("fill", player1.x, player1.y, paddleWidth, paddleHeight);

        -- Paddle 2
        love.graphics.rectangle("fill", player2.x, player2.y, paddleWidth, paddleHeight);

        -- Draw horizontal split
        love.graphics.rectangle("fill", windowWidth / 2 - 1, 0, 2, windowHeight);

        -- Draw the score

        -- Draw the ball
        love.graphics.circle("line", ball.x, ball.y, ball.radius)
    elseif gameState == GameState.MENU then
        -- TODO:
        -- Draw the menu
    elseif gameState == GameState.GAME_OVER then
        -- TODO:
        -- Draw the game over screen
    elseif gameState == GameState.PAUSED then
        -- TODO:
        -- Draw the paused screen
    end
end

function love.keypressed(key, scancode, isrepeat)
    -- TODO:
end

function love.mousepressed(x, y, button, isTouch)
    -- TODO:
end
