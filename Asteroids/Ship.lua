--[[
    -- Ship Class --
]]

Ship = Class{}

--[[
    Ship takes an x and y for starting position as well as a radius to determine size.
    Initializes heading to point right and dx and dy to zero so it does not move until player input.
]]
function Ship:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.heading = 0
    self.dx = 0
    self.dy = 0
end

function Ship:collides(asteroid)
    if self.x > asteroid.x + asteroid.radius + self.radius or asteroid.x > self.x + asteroid.radius + self.radius then
        return false
    end

    if self.y > asteroid.y + asteroid.radius + self.radius or asteroid.y > self.y + asteroid.radius + self.radius then
        return false
    end 

    return true
end

function Ship:update(dt)
    if self.y < 0 and self.dy < 0 then
        self.y = VIRTUAL_HEIGHT - self.radius - 1
    end
    if self.y >= VIRTUAL_HEIGHT - self.radius / 2 then
        self.y = 0 + self.radius / 2
    end
    
    self.y = self.y + self.dy * dt
    
    if self.x < 0 and self.dx < 0 then
        self.x = VIRTUAL_WIDTH - self.radius - 1
    end
    if self.x >= VIRTUAL_WIDTH - self.radius / 2 then
        self.x = 0 + self.radius / 2
    end
    
    self.heading = self.heading % (2 * math.pi)
    
    self.x = self.x + self.dx * dt
end

function Ship:reset(x, y)
    self.x = x
    self.y = y
    self.heading = 0
    self.dx = 0
    self.dy = 0
end    

--[[
    Uses LÖVE2D's `circle` function, which takes draw mode, 
    positions, and radius for the circle. Adds a line to show
    player where the front of the ship is, which is drawn with 
    the ship's position and the heading and is as long
    as the radius
]]
function Ship:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(self.x, self.y, self.x + self.radius * math.cos(self.heading), self.y + self.radius * math.sin(self.heading))
end
