function love.load()
    x, y, w, h
end

function love.update(dt)
    paddleH = paddleH + 1
    paddleW = paddleW + 1
end

function love.draw()
    love.graphics.rectangle("fill", paddleH, paddleW)
end