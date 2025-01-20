function love.load()

    font = love.graphics.newFont(20)
    
    love.window.setTitle("Pong Game")
    love.window.setMode(800, 600)

    paddle1H, paddle1W = 75, 10
    paddle1X, paddle1Y = 10, 250

    paddle2H, paddle2W = 75, 10
    paddle2X, paddle2Y = 780, 250

    paddleSpeed = 10

    ballX, ballY = 390, 300
    ballSpeedX = 4
    ballSpeedY = 4
    ballRadius = 10
    ballSpeedMulti = 1.1

    ballTrail = {}
    maxTrailLength = 4

    Point1 = 0
    Point2 = 0

    gameMode = "vsAI"

end

function love.update(dt)

    -- Movement of Paddles
    if love.keyboard.isDown("w") then
        paddle1Y = paddle1Y - paddleSpeed
    end
    if love.keyboard.isDown("s") then
        paddle1Y = paddle1Y + paddleSpeed
    end

    if gameMode == "vsPlayer" then
        if love.keyboard.isDown("up") then
            paddle2Y = paddle2Y - paddleSpeed
        end
        if love.keyboard.isDown("down") then
            paddle2Y = paddle2Y + paddleSpeed
        end
    elseif gameMode == "vsAI" then
        -- Following the Ball
        if ballY > paddle2Y + paddle2H/2 then
            paddle2Y = paddle2Y + paddleSpeed
        elseif ballY < paddle2Y + paddle2H/2 then
            paddle2Y = paddle2Y - paddleSpeed
        end
    end

    -- BALL
    -- Ball Movement
    ballX = ballX - ballSpeedX
    ballY = ballY + ballSpeedY
    -- Ball collision on right and left walls and Point1
    if ballX >= 800 then
        ballX, ballY = 400, 300
        ballSpeedX = math.random(4,5) * (math.random(2) == 1 and 1 or -1)
        ballSpeedY = math.random(4,5) * (math.random(2) == 1 and 1 or -1)
        Point1 = Point1 + 1
    end
    -- Ball collision on right and left walls and Point2
    if ballX <= 0 then
        ballX, ballY = 400, 300
        ballSpeedX = math.random(4,5) * (math.random(2) == 1 and 1 or -1)
        ballSpeedY = 2
        Point2 = Point2 + 1
    end
    -- Ball collision for top and bottom
    if ballY >= 600 or ballY <= 0 then
        ballSpeedY = -ballSpeedY
    end
    -- Ball collision for Paddle 1 and Speed increment
    if ballX - ballRadius <= paddle1X + paddle1W and ballY >= paddle1Y and ballY <= paddle1Y + paddle1H then
        ballSpeedX = -(ballSpeedX*ballSpeedMulti)    
    end
    -- Ball collision for Paddle 2 and speed increment
    if ballX + ballRadius >= paddle2X and ballY >= paddle2Y and ballY <= paddle2Y + paddle2H then
        ballSpeedX = -(ballSpeedX*ballSpeedMulti)
    end
    -- Capping the Max Ball speed
    if ballSpeedX > 10 then ballSpeedX = 10 end

    -- Trail Behinnd the Ball(Graphical)
    -- Storing Previous Ball Positions
    table.insert(ballTrail, {x = ballX, y = ballY, alpha = 1})
    -- Limiting Trail Length
    if #ballTrail > maxTrailLength then
        table.remove(ballTrail, 1)
    end

    -- Preventing Paddle movement outside bounds
    -- Boundary for Paddle 1
    paddle1Y = math.max(0, math.min(600 - paddle1H, paddle1Y))
    --Boundary for Paddle 2
    paddle2Y = math.max(0, math.min(600 - paddle2H, paddle2Y))

end

function love.draw()

    love.graphics.setFont(font)

    -- Paddle 1 (w, s)
    love.graphics.rectangle("fill", paddle1X, paddle1Y, paddle1W, paddle1H)
    -- Paddle 2 (up, down)
    love.graphics.rectangle("fill", paddle2X, paddle2Y, paddle2W, paddle2H)
    -- BALL
    love.graphics.circle("fill", ballX, ballY, ballRadius)
    -- Point1
    love.graphics.rectangle("line", 241, 15, 150, 30)
    love.graphics.rectangle("line", 241, 15, 150, 60)
    love.graphics.print("Left Paddle", 260, 20)
    love.graphics.print(Point1, 310, 50)
    --Point2
    love.graphics.rectangle("line", 426, 15, 150, 30)
    love.graphics.rectangle("line", 426, 15, 150, 60)
    love.graphics.print("Right Paddle", 440, 20)
    love.graphics.print(Point2, 490, 50)
    --Telling the User the GameMode
    if gameMode == "vsAI" then
        love.graphics.rectangle("line", 370, 95, 80, 40)
        love.graphics.print(gameMode, 390, 100)
    else
        love.graphics.rectangle("line", 350, 95, 120, 40)
        love.graphics.print(gameMode, 370, 100)
    end

    -- Ball Trail
    for i, trail in ipairs(ballTrail) do
        -- Decreasing Opacity as Trail moves Farther away
        local alpha = trail.alpha * (i/#ballTrail)
        -- Setting color with transparency
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.circle("line", trail.x, trail.y, ballRadius)
    end
    
end

function love.keypressed(key)
    if key == "m" then
        if gameMode == "vsAI" then
            gameMode = "vsPlayer"
        else
            gameMode = "vsAI"
        end
    end
end
