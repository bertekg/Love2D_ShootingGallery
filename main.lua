function love.load()
    love.window.setTitle("Shoting Gallery")
    target = {}
    target.x = 300
    target.y = 250
    target.radius = 50

    score = 0
    timer = 0
    gameState = 1

    fontSize = 40
    fontSizeManu = 30
    pixelBuffer = 5
    gameFont = love.graphics.newFont(fontSize)
    gameFontMenu = love.graphics.newFont(fontSizeManu)

    sprites = {}
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')

    love.mouse.setVisible(false)

    fpsCounter = 0
end

function love.update(dt)
    fpsCounter = 1 / dt
    if gameState == 2 then
        if timer > 0 then
            timer = timer - dt
        end
        if timer <= 0 then
            timer = 0
            gameState = 1
        end
    end    
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print("Wynik: " .. score, pixelBuffer, pixelBuffer)
    love.graphics.print("Czas: " .. math.ceil(timer), 300, pixelBuffer)
    love.graphics.print("FPS: " .. math.ceil(fpsCounter), 600, pixelBuffer)

    if gameState == 1 then
        love.graphics.setFont(gameFontMenu)
        love.graphics.printf("Lewym przyciskiem strzelasz", 0, 250, love.graphics.getWidth(), "center")
        love.graphics.printf("Kliknij srodkowy przycisk aby rozpoczac gre!", 0, 300, love.graphics.getWidth(), "center")
    end
    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)    
    --[[
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", 300, 250, 200, 100, 25)

    love.graphics.setColor(1, 0.63, 0)
    love.graphics.circle("fill", 175, 150, 100, 36)
    ]]
end

function love.mousepressed(x, y, button, istouch, presses)
    if (button == 1 or button == 2) and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            if button == 1 then
                score = score + 1
            else
                score = score + 2
                timer = timer - 1
            end
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius + fontSize + pixelBuffer, love.graphics.getHeight() - target.radius)
        else
            if score > 0 then
                score = score - 1
            end
        end
    elseif button == 3 and gameState == 1 then
        gameState = 2
        timer = 10
        score = 0
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end