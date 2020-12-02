--[[
    -- Bullet Class --
]]

Bullet = Class{}

function Bullet:init(x, y, angle)
    self.x = x
    self.y = y
    self.radius = 3

    self.dy = math.sin(angle) * 300
    self.dx = math.cos(angle) * 300
end

--[[
    Expects an asteroid as an argument and returns true or false, depending
    on whether they are overlapping.
]]
function Bullet:collides(asteroid)
    if self.x > asteroid.x + asteroid.radius or asteroid.x > self.x + asteroid.radius then
        return false
    end

    if self.y > asteroid.y + asteroid.radius or asteroid.y > self.y + asteroid.radius then
        return false
    end 

    return true
end

function Bullet:edge()
    if self.x <= 0 or self.x >= VIRTUAL_WIDTH then
        return true
    end
    if self.y <= 0 or self.y >= VIRTUAL_HEIGHT then
        return true
    end
    return false
end

function Bullet:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Bullet:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end