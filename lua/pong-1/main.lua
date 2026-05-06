local PLAYER_FONT_PATH = "assets/fonts/PressStart2P-Regular.ttf"
local SOUND_PATH = "assets/sounds"
local BGM_PATH = SOUND_PATH .. "/bensound-yesterday.mp3"
local BOUNCING_SOUND_PATH = SOUND_PATH .. "/impactMetal_heavy_002.ogg"
local UI_SOUND_PATH = SOUND_PATH .. "/switch_007.ogg"
local GOAL_HIT_SOUND_PATH = SOUND_PATH .. "/impactGlass_medium_003.ogg"

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

local gameState

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
}

local isAI = false

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

local scoreBoardFont
local menuFont

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
local START_MENU = {}
local focusedIndex = 1

local PAUSE_MENU = {}

local GAME_OVER_MENU = {}

local POINT_2_WIN = 5
-- local POINT_2_WIN = 1

local uiSoundSrc
local bounceSoundSrc
local bgmSoundSrc
local goalHitSoundSrc

local function startGame()
    bgmSoundSrc:stop()
    bgmSoundSrc:play()

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

local function startGameVsBot()
    isAI = true
    startGame()
end

function love.load()
    gameState = GameState.MENU
    -- gameState = GameState.PLAYING

    uiSoundSrc = love.audio.newSource(UI_SOUND_PATH, "static")
    bounceSoundSrc = love.audio.newSource(BOUNCING_SOUND_PATH, "static")
    bgmSoundSrc = love.audio.newSource(BGM_PATH, "static")
    goalHitSoundSrc = love.audio.newSource(GOAL_HIT_SOUND_PATH, "static")

    windowWidth = love.graphics.getWidth()
    windowHeight = love.graphics.getHeight()

    START_MENU = {
        {
            label = "2 Players",
            y = windowHeight / 2 - MENU_ITEM_GAP,
            limit = windowWidth,
            action = startGame
        },
        {
            label = "VS Bot",
            y = windowHeight / 2,
            limit = windowWidth,
            action = startGameVsBot
        },
        {
            label = "Quit",
            y = windowHeight / 2 + MENU_ITEM_GAP,
            limit = windowWidth,
            action = quitGame
        }
    }

    PAUSE_MENU = {
        {
            label = "Continue",
            y = windowHeight / 2 - MENU_ITEM_GAP,
            limit = windowWidth,
            action = function ()
                focusedIndex = 1
                gameState = GameState.PLAYING
                ---@diagnostic disable-next-line: need-check-nil, undefined-field
                bgmSoundSrc:play()
            end
        },
        {
            label = "Restart",
            y = windowHeight / 2,
            limit = windowWidth,
            action = startGame
        },
        {
            label = "Back to menu",
            y = windowHeight / 2 + MENU_ITEM_GAP,
            limit = windowWidth,
            action = function ()
                focusedIndex = 1
                gameState = GameState.MENU
            end
        },
        {
            label = "Quit",
            y = windowHeight / 2 + MENU_ITEM_GAP * 2,
            limit = windowWidth,
            action = quitGame
        }
    }

    GAME_OVER_MENU = {
        {
            label = "Restart",
            y = windowHeight / 2,
            limit = windowWidth,
            action = startGame
        },
        {
            label = "Back to menu",
            y = windowHeight / 2 + MENU_ITEM_GAP,
            limit = windowWidth,
            action = function ()
                focusedIndex = 1
                gameState = GameState.MENU
            end
        },
        {
            label = "Quit",
            y = windowHeight / 2 + MENU_ITEM_GAP * 2,
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

        if player1.score >= POINT_2_WIN or player2.score >= POINT_2_WIN then
            gameState = GameState.GAME_OVER
            ---@diagnostic disable-next-line: need-check-nil, undefined-field
            bgmSoundSrc:stop()
            return
        end

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

        local player2NewY
        if isAI then
            local playerMiddle = player2.y + PADDLE_HEIGHT/2
            local distance = math.abs(ball.y - playerMiddle)
            local moveStep = PLAYER_SPEED * delta
            if distance < moveStep then
                -- NOTE: over OVERSHOOTING (jitering / flickering)
                -- this make the paddle move smoothly but a bit too smart

                -- TODO: still jiterring and teleport sometime
                player2NewY = ball.y
            else
                if ball.y < player2.y then
                    player2Move = player2Move - PLAYER_SPEED * delta
                elseif ball.y > player2.y then
                    player2Move = player2Move + PLAYER_SPEED * delta
                end

                player2NewY = player2.y + player2Move
            end
        else
            if (love.keyboard.isDown(PLAYER_2_CONTROL.up)) then
                player2Move = player2Move - PLAYER_SPEED * delta
            end

            if (love.keyboard.isDown(PLAYER_2_CONTROL.down)) then
                player2Move = player2Move + PLAYER_SPEED * delta
            end

            player2NewY = player2.y + player2Move
        end

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

                ---@diagnostic disable-next-line: need-check-nil, undefined-field
                bounceSoundSrc:clone():play()
            elseif (ballNewY + ball.radius >= windowHeight) then
                ball.vectorY = -ball.vectorY
                ballNewY = ball.y + ball.vectorY * delta * ball.speed
                ---@diagnostic disable-next-line: need-check-nil, undefined-field
                bounceSoundSrc:clone():play()
            end

            -- Collision with left & right
            if (ballNewX - ball.radius <= player1Goal.x) then
                ball.x = windowWidth / 2
                ball.y = windowHeight / 2
                ball.vectorX = 0
                ball.vectorY = 0
                ball.startTimer = 0.5
                player2.score = player2.score + 1

                ---@diagnostic disable-next-line: need-check-nil, undefined-field
                goalHitSoundSrc:clone():play()

                return
            elseif (ballNewX + ball.radius >= player2Goal.x) then
                ball.x = windowWidth / 2
                ball.y = windowHeight / 2
                ball.vectorX = 0
                ball.vectorY = 0
                ball.startTimer = 0.5
                player1.score = player1.score + 1

                ---@diagnostic disable-next-line: need-check-nil, undefined-field
                goalHitSoundSrc:clone():play()

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

                ---@diagnostic disable-next-line: need-check-nil, undefined-field
                bounceSoundSrc:clone():play()
            end

            closedPointX = math.max(player2.x, math.min(ballNewX, player2.x + PADDLE_WIDTH))
            closedPointY = math.max(player2.y, math.min(ballNewY, player2.y + PADDLE_HEIGHT))
            distance = math.sqrt((closedPointX - ballNewX) ^ 2 + (closedPointY - ballNewY) ^ 2)

            if (distance <= ball.radius) then
                ball.vectorX = -ball.vectorX
                ballNewX = ball.x + ball.vectorX * delta * ball.speed

                ---@diagnostic disable-next-line: need-check-nil, undefined-field
                bounceSoundSrc:clone():play()
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

    elseif gameState == GameState.MENU then
        -- Draw the menu
        ---@diagnostic disable-next-line: param-type-mismatch
        love.graphics.setFont(menuFont)

        for i, value in ipairs(START_MENU) do
            local label = value.label
            if i == focusedIndex then
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 255))
                label = "> " .. label .. " <"
            else
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 60))
            end

            love.graphics.printf(label, 0, value.y, value.limit, "center")
        end
    elseif gameState == GameState.GAME_OVER then
        ---@diagnostic disable-next-line: param-type-mismatch
        love.graphics.setFont(scoreBoardFont)
        local winningPlayer = "Player 1"
        if player2.score >= POINT_2_WIN then
            winningPlayer = "Player 2"
        end

        love.graphics.setColor(love.math.colorFromBytes(173, 216, 230, 255))
        love.graphics.printf(winningPlayer .. " WIN", 0, 50, 800, "center")

        -- Draw the menu
        ---@diagnostic disable-next-line: param-type-mismatch
        love.graphics.setFont(menuFont)

        for i, value in ipairs(GAME_OVER_MENU) do
            local label = value.label
            if i == focusedIndex then
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 255))
                label = "> " .. label .. " <"
            else
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 60))
            end

            love.graphics.printf(label, 0, value.y, value.limit, "center")
        end
    elseif gameState == GameState.PAUSED then
        -- Draw the menu
        ---@diagnostic disable-next-line: param-type-mismatch
        love.graphics.setFont(menuFont)

        for i, value in ipairs(PAUSE_MENU) do
            local label = value.label
            if i == focusedIndex then
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 255))
                label = "> " .. label .. " <"
            else
                love.graphics.setColor(love.math.colorFromBytes(160, 160, 160, 60))
            end

            love.graphics.printf(label, 0, value.y, value.limit, "center")
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if gameState == GameState.PLAYING then
        -- PLAYING -> pause key -> pause
        if key == "escape" or key == "l" then
            focusedIndex = 1
            gameState = GameState.PAUSED

            ---@diagnostic disable-next-line: need-check-nil, undefined-field
            bgmSoundSrc:pause()
        end
    elseif gameState == GameState.MENU then
        -- PAUSE -> pause key -> playing
        -- PAUSE / MENU / END -> up/down -> change options
        -- PAUSE / MENU / END -> enter/escape -> choose options
        if key == "up" then
            if focusedIndex > 1 then
                focusedIndex = focusedIndex - 1
                ---@diagnostic disable: need-check-nil
                ---@diagnostic disable-next-line: undefined-field
                uiSoundSrc:clone():play()
            end
        elseif key == "down" then
            if focusedIndex < #(START_MENU) then
                focusedIndex = focusedIndex + 1
                ---@diagnostic disable: need-check-nil
                ---@diagnostic disable-next-line: undefined-field
                uiSoundSrc:clone():play()
            end
        elseif key == "return" or key == "kpenter" then
            START_MENU[focusedIndex].action()
        end
    elseif gameState == GameState.GAME_OVER then
        if key == "up" then
            if focusedIndex > 1 then
                focusedIndex = focusedIndex - 1
                ---@diagnostic disable: need-check-nil
                ---@diagnostic disable-next-line: undefined-field
                uiSoundSrc:clone():play()
            end
        elseif key == "down" then
            if focusedIndex < #(GAME_OVER_MENU) then
                focusedIndex = focusedIndex + 1
                ---@diagnostic disable: need-check-nil
                ---@diagnostic disable-next-line: undefined-field
                uiSoundSrc:clone():play()
            end
        elseif key == "return" or key == "kpenter" then
            GAME_OVER_MENU[focusedIndex].action()
        end
    elseif gameState == GameState.PAUSED then
        if key == "escape" or key == "l" then
            gameState = GameState.PLAYING
            ---@diagnostic disable-next-line: need-check-nil, undefined-field
            bgmSoundSrc:play()
        elseif key == "up" then
            if focusedIndex > 1 then
                focusedIndex = focusedIndex - 1
                ---@diagnostic disable: need-check-nil
                ---@diagnostic disable-next-line: undefined-field
                uiSoundSrc:clone():play()
            end
        elseif key == "down" then
            if focusedIndex < #(PAUSE_MENU) then
                focusedIndex = focusedIndex + 1
                ---@diagnostic disable: need-check-nil
                ---@diagnostic disable-next-line: undefined-field
                uiSoundSrc:clone():play()
            end
        elseif key == "return" or key == "kpenter" then
            PAUSE_MENU[focusedIndex].action()
        end
    end
end

function love.mousepressed(x, y, button, isTouch)
    -- TODO:
    -- PAUSE / MENU / END -> left click -> choose option
end
