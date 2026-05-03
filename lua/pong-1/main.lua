local PLAYER_FONT_PATH = "assets/fonts/PressStart2P-Regular.ttf"

local GameState = {
    MENU = 1,
    PLAYING = 2,
    PAUSED = 3,
    GAME_OVER = 4
}

local GeometryMode = {
    FILL = "fill",
    LINE = "line",
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

local player1Goal = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
}

local player2Goal = {
    x = 0,
    y = 0,
    width = 0,
    height = 0,
}

local PLAYER_SPEED = 170
local BALL_SPEED = 280

local PLAYER_1_CONTROL = {
    up = "w",
    down = "s"
}

local PLAYER_2_CONTROL = {
    up = "up",
    down = "down"
}

local scoreBoardFont = nil
local menuFont = nil

local ball = {
    x = 0,
    y = 0,
    radius = 0,
    speed = 0,
    vectorX = 0,
    vectorY = 0,
    startTimer = 3,
}

local MENU_ITEM_GAP = 80
local MENU = {}
local focusedStartMenuIndex = 1

local function startGame()
    player1 = {
        x = GOAL_PADDING,
        y = (windowHeight - PADDLE_HEIGHT) / 2,
        score = 0,
    }

    player1Goal = {
        x = 0,
        y = 0,
        width = 5,
        height = windowHeight,
    }

    player2 = {
        x = windowWidth - PADDLE_WIDTH - GOAL_PADDING,
        y = (windowHeight - PADDLE_HEIGHT) / 2,
        score = 0,
        isAI = false,
    }

    player2Goal = {
        x = windowWidth,
        y = 0,
        width = 5,
        height = windowHeight,
    }

    ball = {
        x = windowWidth / 2,
        y = windowHeight / 2,
        radius = 12,
        speed = BALL_SPEED,
        vectorX = 0,
        vectorY = 0,
        startTimer = 0.5,
    }

    gameState = GameState.PLAYING
end

local function quitGame()
    love.event.quit()
end

function love.load()
    gameState = GameState.MENU
    -- gameState = GameState.PLAYING

    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    MENU = {
        {
            label = "2 Players",
            y = windowHeight / 2 - MENU_ITEM_GAP,
            limit = windowWidth,
            action = startGame
        },
        -- {
        --     label = "VS Bot",
        --     y = windowHeight / 2,
        --     limit = windowWidth,
        --     action = ...
        -- },
        {
            label = "Quit",
            y = windowHeight / 2 + MENU_ITEM_GAP,
            limit = windowWidth,
            action = quitGame
        }
    }

    scoreBoardFont = love.graphics.newFont(PLAYER_FONT_PATH, 48)
    menuFont = love.graphics.newFont(PLAYER_FONT_PATH, 36)
end

-- TODO: implement AI for player 2
function love.update(delta)
    if gameState == GameState.PLAYING then
        local player1Move, player2Move = 0, 0

        -- Split UP & DOWN detection make logic simpler
        if (love.keyboard.isDown(PLAYER_1_CONTROL.up)) then
            player1Move = player1Move - PLAYER_SPEED * delta
        end

        if (love.keyboard.isDown(PLAYER_1_CONTROL.down)) then
            player1Move = player1Move + PLAYER_SPEED * delta
        end

        local player1NewY = player1.y + player1Move
        if (player1NewY >= 0 and player1NewY + PADDLE_HEIGHT <= windowHeight) then
            player1.y = player1.y + player1Move
        end

        if (love.keyboard.isDown(PLAYER_2_CONTROL.up)) then
            player2Move = player2Move - PLAYER_SPEED * delta
        end

        if (love.keyboard.isDown(PLAYER_2_CONTROL.down)) then
            player2Move = player2Move + PLAYER_SPEED * delta
        end

        local player2NewY = player2.y + player2Move
        if (player2NewY >= 0 and player2NewY + PADDLE_HEIGHT <= windowHeight) then
            player2.y = player2NewY
        end

        if (ball.startTimer > 0) then
            ball.startTimer = ball.startTimer - delta
        else
            -- TODO: consider check boundary 1st before calculation
            if (ball.vectorX == 0 and ball.vectorY == 0) then
                -- Random starting vector
                -- TODO: better limit to only shoot 315 -> 45 & 135 -> 215
                local targetX = love.math.random(0, windowWidth)
                local targetY = love.math.random(0, windowHeight)
                local vectorX = targetX - ball.x
                local vectorY = targetY - ball.y

                local distance = math.sqrt(vectorX ^ 2 + vectorY ^ 2)

                ball.vectorX = vectorX / distance
                ball.vectorY = vectorY / distance
            end

            local ballNewX = ball.x + ball.vectorX * delta * ball.speed
            local ballNewY = ball.y + ball.vectorY * delta * ball.speed

            -- Collision with top & bottom
            if (ballNewY - ball.radius <= 0) then
                ball.vectorY = -ball.vectorY
                ballNewY = ball.y + ball.vectorY * delta * ball.speed
            elseif (ballNewY + ball.radius >= windowHeight) then
                ball.vectorY = -ball.vectorY
                ballNewY = ball.y + ball.vectorY * delta * ball.speed
            end

            -- Collision with left & right
            if (ballNewX - ball.radius <= player1Goal.x) then
                ball.x = windowWidth / 2
                ball.y = windowHeight / 2
                ball.vectorX = 0
                ball.vectorY = 0
                ball.startTimer = 0.5
                player2.score = player2.score + 1

                return
            elseif (ballNewX + ball.radius >= player2Goal.x) then
                ball.x = windowWidth / 2
                ball.y = windowHeight / 2
                ball.vectorX = 0
                ball.vectorY = 0
                ball.startTimer = 0.5
                player1.score = player1.score + 1

                return
            end

            -- Collision with paddles
            -- TODO: I don't understand this part yet
            -- TODO: if hit by the side, it will cause bug and bounce internally
            local closedPointX = math.max(player1.x, math.min(ballNewX, player1.x + PADDLE_WIDTH))
            local closedPointY = math.max(player1.y, math.min(ballNewY, player1.y + PADDLE_HEIGHT))
            local distance = math.sqrt((closedPointX - ballNewX) ^ 2 + (closedPointY - ballNewY) ^ 2)

            if (distance <= ball.radius) then
                ball.vectorX = -ball.vectorX
                ballNewX = ball.x + ball.vectorX * delta * ball.speed
            end

            closedPointX = math.max(player2.x, math.min(ballNewX, player2.x + PADDLE_WIDTH))
            closedPointY = math.max(player2.y, math.min(ballNewY, player2.y + PADDLE_HEIGHT))
            distance = math.sqrt((closedPointX - ballNewX) ^ 2 + (closedPointY - ballNewY) ^ 2)

            if (distance <= ball.radius) then
                ball.vectorX = -ball.vectorX
                ballNewX = ball.x + ball.vectorX * delta * ball.speed
            end


            ball.x = ballNewX
            ball.y = ballNewY
        end
    end
end

function love.draw()
    if gameState == GameState.PLAYING then
        -- New to create & set font because default has a low size to scale
        ---@diagnostic disable-next-line: param-type-mismatch
        love.graphics.setFont(scoreBoardFont)
        -- Draw the 2 paddles
        -- love.graphics.setColor({160/255, 160/255, 160/255})
        love.graphics.setColor(love.math.colorFromBytes(160, 160, 160))

        -- Paddle 1
        love.graphics.rectangle(GeometryMode.FILL, player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT);

        -- Paddle 2
        love.graphics.rectangle(GeometryMode.FILL, player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT);

        -- Draw horizontal split
        love.graphics.rectangle(GeometryMode.FILL, windowWidth / 2 - 1, 0, 2, windowHeight);

        -- Draw the score
        -- TODO: score > 2 digits have display bug overlap with the middle line
        -- Score board 1
        love.graphics.print(player1.score, windowWidth / 2 - 52)

        -- Score board 2
        love.graphics.print(player2.score, windowWidth / 2 + 10)

        -- Draw the ball
        love.graphics.setColor(love.math.colorFromBytes(210, 4, 45))
        love.graphics.circle(GeometryMode.FILL, ball.x, ball.y, ball.radius)

        -- PAUSE & QUIT buttons
        -- if mouse hover on them, highlight
    elseif gameState == GameState.MENU then
        -- Draw the menu
        ---@diagnostic disable-next-line: param-type-mismatch
        love.graphics.setFont(menuFont)

        for i, value in ipairs(MENU) do
            local label = value.label
            if i == focusedStartMenuIndex then
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 255))
                label = "> " .. label .. " <"
            else
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 60))
            end

            love.graphics.printf(label, 0, value.y, value.limit, "center")
        end
    elseif gameState == GameState.GAME_OVER then
        -- TODO:
        -- Draw the game over screen
        -- if mouse hover on them, highlight
    elseif gameState == GameState.PAUSED then
        -- TODO:
        -- Draw the paused screen
        -- if mouse hover on them, highlight
    end
end

function love.keypressed(key, scancode, isrepeat)
    -- TODO:
    if gameState == GameState.PLAYING then
        -- PLAYING -> pause key -> pause
    elseif gameState == GameState.MENU then
        -- PAUSE -> pause key -> playing
        -- PAUSE / MENU / END -> up/down -> change options
        -- PAUSE / MENU / END -> enter/escape -> choose options
        if key == "up" then
            if focusedStartMenuIndex > 1 then
                focusedStartMenuIndex = focusedStartMenuIndex - 1
            end
        elseif key == "down" then
            if focusedStartMenuIndex <= #(MENU) then
                focusedStartMenuIndex = focusedStartMenuIndex + 1
            end
        elseif key == "return" or key == "kpenter" then
            MENU[focusedStartMenuIndex].action()
        end
    elseif gameState == GameState.GAME_OVER then
    elseif gameState == GameState.PAUSED then
    end
end

function love.mousepressed(x, y, button, isTouch)
    -- TODO:
    -- PAUSE / MENU / END -> left click -> choose option
end
