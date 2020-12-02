--[[
    -- Ship Class --
]]

Ship = Class{}

--[[
    Ship takes an x and y for starting position as well as a radius to determine size.
    Initializes heading to point right and dx and dy to zero so there is it does not move
]]
function Ship:init(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.heading = 0
    self.dx = 0
    self.dy = 0
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

--[[
    Uses LÖVE2D's `circle` function, which takes draw mode, 
    positions, and radius for the circle. Adds a line to show
    player where the 'thrust' will push the ship, which is 
    drawn with the ship's position and the heading and is as long
    as the radius
]]
function Ship:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(self.x, self.y, self.x + self.radius * math.cos(self.heading), self.y + self.radius * math.sin(self.heading))
end