push = require 'push'

Class = require 'class'

require 'Ship'

require 'Asteroid'

require 'Bullet'

-- close resolution to NES but 16:9
VIRTUAL_WIDTH = 864
VIRTUAL_HEIGHT = 486

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- seed RNG
math.randomseed(os.time())

SHIP_SPEED = 100

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

-- performs initialization of all objects and data needed by program
function love.load()

    -- sets up a different, better-looking retro font as our default
    love.graphics.setFont(love.graphics.newFont('fonts/font.ttf', 8))

    -- sets up virtual screen resolution for an authentic retro feel
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    love.window.setTitle('Asteroid Escape')
    player = Ship(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 10)
    asteroids = {}
    bullets = {}
    for i = 1, 5 do
        aster = Asteroid(math.random(10, 850),math.random(10, 450), 16, 2)
        table.insert(asteroids, aster)
    end
    

    love.keyboard.keysPressed = {}
    love.keyboard.keysReleased = {}
    
    gameState = 'stage1'
end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end

-- global key pressed function
function love.keyboard.wasPressed(key)
    if (love.keyboard.keysPressed[key]) then
        return true
    else
        return false
    end
end

-- global key released function
function love.keyboard.wasReleased(key)
    if (love.keyboard.keysReleased[key]) then
        return true
    else
        return false
    end
end

-- called whenever a key is pressed
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    
    if key == 'space' then
        bullet = Bullet(player.x, player.y, player.heading)
        table.insert(bullets, bullet)
    end
    
    if key == 'v' then
        gameState = 'stage2'
    end

    love.keyboard.keysPressed[key] = true
end

-- called whenever a key is released
function love.keyreleased(key)
    love.keyboard.keysReleased[key] = true
end

-- called every frame, with dt passed in as delta in time since last frame
function love.update(dt)

    if love.keyboard.isDown('up') then
        player.dx = player.dx + math.cos(player.heading) * SHIP_SPEED * dt
        player.dy = player.dy + math.sin(player.heading) * SHIP_SPEED * dt
    end
    if love.keyboard.isDown('left') then
        player.heading = player.heading - 10 * dt
    elseif love.keyboard.isDown('right') then
        player.heading = player.heading + 10 * dt
    end

    
    player:update(dt)
    
    for _, v in ipairs(asteroids) do
        v:update(dt)
    end
    
    for _, v in ipairs(asteroids) do
        if player:collides(v) then
            deathReset()
        end
    end
    
    for _, v in ipairs(bullets) do
        if v:edge() then
            table.remove(bullets, _)
        end
        v:update(dt)
    end  
    
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
                    a = Asteroid(v.x, v.y, 12, 1)
                    b = Asteroid(v.x, v.y, 12, 1)
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
    
    for i = 1, 5 do
        aster = Asteroid(math.random(10, 850),math.random(10, 450), 16, 2)
        table.insert(asteroids, aster)
    end
    player:reset(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)
end

-- called each frame, used to render to the screen
function love.draw()
    -- begin virtual resolution drawing
    push:apply('start')
    if gameState == 'stage1' then
        love.graphics.print('try: ', 10, 10)
    end
    -- XXX
    if gameState == 'stage2' then
        love.graphics.clear(0/255, 0/255, 0/255, 0/255)

        for _, v in ipairs(bullets) do
            v:render()
        end
        
        for _, v in ipairs(asteroids) do
            v:render()
        end
        
        player:render()
        
        displayFPS()
    end
    -- end virtual resolution
    push:apply('end')
end

function displayFPS()
    -- simple FPS display across all states

    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(player.heading), 10, 10)
end