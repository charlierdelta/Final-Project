push = require 'push'

Class = require 'class'

require 'Ship'

require 'Asteroid'

require 'Bullet'

require 'Wall'

require 'Victory'

VIRTUAL_WIDTH = 864
VIRTUAL_HEIGHT = 486

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

math.randomseed(os.time())

SHIP_SPEED = 150

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
    love.window.setTitle('Asteroid Escape')

    smallFont = love.graphics.newFont('fonts/font.ttf', 16)
    largeFont = love.graphics.newFont('fonts/font.ttf', 32)
    love.graphics.setFont(largeFont)
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    
    player = Ship(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 10)
    
    asteroids = {}
    
    bullets = {}
    
    circleWalls = {}
    
    planetVictory = {}
    
    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
    
    vtokens = 0
    midState = 12
    
    gameState = 'screen'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    
    if gameState == 'stage1' then    
        if key == 'space' then
            bullet = Bullet(player.x, player.y, player.heading)
            table.insert(bullets, bullet)
        end
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

function fillAsteroids()
    for i = 1, 2 do
        aster = Asteroid(math.random(VIRTUAL_WIDTH * (2 / 3), VIRTUAL_WIDTH),math.random(10, 450), 20, 2)
        table.insert(asteroids, aster)
    end
    for i = 1, 2 do
        aster = Asteroid(math.random(10, VIRTUAL_WIDTH / 3),math.random(10, 450), 20, 2)
        table.insert(asteroids, aster)
    end
end

function love.update(dt)
    if gameState == 'stage1' then
        controls(dt)
        checkBullets()
        player:update(dt)
        
        for _, v in ipairs(asteroids) do
            v:update(dt)
        end
        for _, v in ipairs(bullets) do
            if v:edge() then
                table.remove(bullets, _)
            end
            v:update(dt)
        end 
        
        for _, v in ipairs(asteroids) do
            if player:collides(v) then
                deathReset()
            end
        end
        
        if #asteroids == 0 then
            if gameState == 'stage1' then
                player:reset(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
                gameState = 'midScreen'
            end
        end
    
    elseif gameState =='midScreen' then
        controls(dt)
        player:update(dt)
        
    elseif gameState == 'bigAsteroid' then 
        controls(dt)
        player:update(dt)
        for _, v in ipairs(circleWalls) do
            if player:collides(v) then
                deathReset()
            end
        end
        if player:collides(asterVictory) then
            if midState == 12 then
                midState = 3
                player:reset(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
                gameState = 'midScreen'
            elseif midState == 4 then
                gameState = 'Victory'
                victoryScreen()
            end
        end
        
    elseif gameState == 'planet' then
        controls(dt)
        player:update(dt)
        
        for _, v in ipairs(planetVictory) do
            if player:collides(v) then
                vtokens = vtokens + 1
                planetVictory = {}
                fillVictory()
            end
        end
        
        if vtokens == 10 then
            if midState == 3 then
                gameState = 'Victory'
                victoryScreen()
            elseif midState == 12 then
                midState = 4
                player:reset(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
                gameState = 'midScreen'
            end
        end
    end
end

function controls(dt)
    if love.keyboard.isDown('up') then
        player.dx = player.dx + math.cos(player.heading) * SHIP_SPEED * dt
        player.dy = player.dy + math.sin(player.heading) * SHIP_SPEED * dt
    end
    if love.keyboard.isDown('left') then
        player.heading = player.heading - 10 * dt
    elseif love.keyboard.isDown('right') then
        player.heading = player.heading + 10 * dt
    end
end

function checkBullets()
    for x, v in ipairs(asteroids) do
        for y, w in ipairs(bullets) do
            if w:collides(v) then
                if v.stage == 0 then
                    table.remove(bullets, y)
                    table.remove(asteroids, x)
                elseif v.stage == 1 then
                    a = Asteroid(v.x, v.y, 8, 0)
                    b = Asteroid(v.x, v.y, 8, 0)
                    b:setDX(-a.dx)
                    b:setDY(-a.dy)
                    table.insert(asteroids, a)
                    table.insert(asteroids, b)
                    table.remove(bullets, y)
                    table.remove(asteroids, x)
                else
                    a = Asteroid(v.x, v.y, 15, 1)
                    b = Asteroid(v.x, v.y, 15, 1)
                    b:setDX(-a.dx)
                    b:setDY(-a.dy)
                    table.insert(asteroids, a)
                    table.insert(asteroids, b)
                    table.remove(bullets, y)
                    table.remove(asteroids, x)
                end
            end
        end
    end
end

function deathReset()
    asteroids = {}
    bullets = {}
    
    gameState = 'deathScreen'
end

function fillWalls()
    table.insert(circleWalls, Wall(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT + 1000, 1070))
    table.insert(circleWalls, Wall(VIRTUAL_WIDTH / 2, -1000, 1050))
    table.insert(circleWalls, Wall(VIRTUAL_WIDTH + 1000, VIRTUAL_HEIGHT / 2, 1070))
    
    table.insert(circleWalls, Wall(VIRTUAL_WIDTH - 20, VIRTUAL_HEIGHT - 20, 150))
    table.insert(circleWalls, Wall(VIRTUAL_WIDTH - 20, 0 - 20, 120))
    table.insert(circleWalls, Wall(600, 270, 40))
    for i = 1, 8 do
        cWalls = Wall(130 + (65 * i), VIRTUAL_HEIGHT - 60, math.random(50, 65))
        table.insert(circleWalls, cWalls)
    end
    for i = 1, 8 do
        cWalls = Wall(100 + (10 * i), VIRTUAL_HEIGHT - (40 * i), math.random(55, 70))
        table.insert(circleWalls, cWalls)
    end
    for i = 1, 11 do
        cWalls = Wall(130 + (40 * i), 150, math.random(40, 55))
        table.insert(circleWalls, cWalls)
    end
    for i = 1, 4 do
        cWalls = Wall(590 + 8 * i, 150 + 20 * i, math.random(30, 45))
        table.insert(circleWalls, cWalls)
    end
    for i = 1, 12 do
        cWalls = Wall(620 - 20 * i, 270 + 1 * i, math.random(30, 35) - i)
        table.insert(circleWalls, cWalls)
    end
end

function fillVictory()
    for i = 1, 4 do 
        pVictory = Victory(math.random(0, VIRTUAL_WIDTH), math.random(0, VIRTUAL_HEIGHT), 8, 0, 0, 0)
        table.insert(planetVictory, pVictory)
    end
end

function love.draw()
    push:apply('start')
    
    if gameState == 'stage1' then
        for _, v in ipairs(bullets) do
            v:render()
        end
        for _, v in ipairs(asteroids) do
            v:render()
        end
        player:render()       
        
    elseif gameState == 'deathScreen' then
        deathScreen()
    elseif gameState == 'screen' then
        startScreen()
    elseif gameState == 'midScreen' then
        midScreen()
        player:render()
        
    elseif gameState == 'bigAsteroid' then
        for _, v in ipairs(circleWalls) do
            v:render()
        end
        player:render()
        asterVictory:render()
    
    elseif gameState == 'planet' then
        love.graphics.clear(65/255, 120/255, 255/255, 255/255)
        for _, v in ipairs(planetVictory) do
            v:render()
        end
        player:render()
        love.graphics.printf('Collect ' .. (10 -vtokens) .. ' gas pockets', 0, 20, VIRTUAL_WIDTH, 'center')
        
    elseif gameState == 'Victory' then
        victoryScreen()
    end
    
    push:apply('end')
end

function startScreen()
    love.graphics.printf('Asteroid Escape', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to begin', 0, 50, VIRTUAL_WIDTH, 'center')
    if love.keyboard.isDown('return') then
        fillAsteroids()
        gameState = 'stage1'
    end
end

function deathScreen()
    love.graphics.setColor(1, 0, 0)
    love.graphics.setFont(largeFont)
    love.graphics.printf('You died', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Enter to play again', 0, 55, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press esc to quit', 0, 80, VIRTUAL_WIDTH, 'center')
    if love.keyboard.isDown('return') then
        fillAsteroids()
        player:reset(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
        gameState = 'stage1'
    end
end

function midScreen()
    love.graphics.setColor(255, 255, 255)
    message = ''
    if midState % 3 == 0 and (midState % 4 == 0) then
        message = 'make repairs and refuel'
        love.graphics.setFont(smallFont)
        love.graphics.printf('Fly here to \nprobe planet \nfor fuel', 10, VIRTUAL_HEIGHT / 2, 200, 'left')
        love.graphics.printf('Fly here to\nmine large asteroid\nfor metal', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH - 10, 'right')
    elseif midState % 3 == 0 then
        message = 'refuel'
        love.graphics.setFont(smallFont)
        love.graphics.printf('Fly here to \nprobe planet \nfor fuel', 10, VIRTUAL_HEIGHT / 2, 200, 'left')
    elseif midState % 4 == 0 then
        message = 'make repairs'
        love.graphics.setFont(smallFont)
        love.graphics.printf('Fly here to\nmine large asteroid\nfor metal', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH - 10, 'right')
    end
    

    love.graphics.setFont(largeFont)
    love.graphics.printf('You cleared the asteroid field', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Now you need to ' .. message, 0, 50, VIRTUAL_WIDTH, 'center')
    
    
    if player.x + player.radius > VIRTUAL_WIDTH - 10 then
        player:reset(VIRTUAL_WIDTH / 12, VIRTUAL_HEIGHT / 10)
        fillWalls()
        
        asterVictory = Victory(VIRTUAL_WIDTH / 2 + 60, VIRTUAL_HEIGHT / 2 - 15, 8, 0, 1, 0)
        gameState = 'bigAsteroid'
    elseif player.x - player.radius < 10 then
        player:reset(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
        fillVictory()
        gameState = 'planet'
    end
end

function victoryScreen()
    bullets = {}
    asteroids = {}
    love.graphics.setColor(0, 1, 0)
    love.graphics.setFont(largeFont)
    love.graphics.printf('You succeeded!', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('You live to fly another day', 0, 55, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press enter to play again', 0, 80, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press esc to quit', 0, 105, VIRTUAL_WIDTH, 'center')
    if love.keyboard.isDown('return') then
        fillAsteroids()
        player:reset(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
        gameState = 'stage1'
    end
end
