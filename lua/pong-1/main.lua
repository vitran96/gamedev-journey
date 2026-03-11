local GameState = {
    MENU = 1,
    PLAYING = 2,
    PAUSED = 3,
    GAME_OVER = 4
}

local PADDLE_WIDTH = 10
local PADDLE_HEIGHT = 100

local GOAL_PADDING = 20

local gameState = nil

local windowWidth = 0
local windowHeight = 0

local player1 = {
    x = 0,
    y = 0,
    score = 0
}

local player2 = {
    x = 0,
    y = 0,
    score = 0,
    isAI = false
}

local ball = {
    x = 0,
    y = 0,
    radius = 0,
    speed = 0
}

function love.load()
    gameState = GameState.PLAYING

    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()


    GOAL_PADDING = 20

    player1 = {
        x = GOAL_PADDING,
        y = (windowHeight - PADDLE_HEIGHT) / 2,
        score = 0
    }

    player2 = {
        x = windowWidth - PADDLE_WIDTH - GOAL_PADDING,
        y = (windowHeight - PADDLE_HEIGHT) / 2,
        score = 0,
        isAI = false
    }

    ball = {
        x = windowWidth / 2,
        y = windowHeight / 2,
        radius = 12,
        speed = 3
    }
end

-- TODO: implement AI for player 2
function love.update(delta)
end

function love.draw()
    if gameState == GameState.PLAYING then
        -- Draw the 2 paddles
        love.graphics.setColor(160, 160, 160)

        -- Paddle 1
        love.graphics.rectangle("fill", player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT);

        -- Paddle 2
        love.graphics.rectangle("fill", player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT);

        -- Draw horizontal split
        love.graphics.rectangle("fill", windowWidth / 2 - 1, 0, 2, windowHeight);

        -- Draw the score
        -- Score 1
        love.graphics.print(player1.score, windowWidth / 2, windowHeight / 2, 0, 20)

        -- Score 2

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
