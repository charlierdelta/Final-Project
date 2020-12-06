--[[
    -- Asteroid Class --
]]

Asteroid = Class{}
--[[
    Asteroid takes an x and y for starting position as well as a radius to determine size.
    Initializes dx and dy with random values in set ranges
]]
function Asteroid:init(x, y, radius, stage)
    self.x = x
    self.y = y
    self.radius = radius
    self.stage = stage

    self.dy = math.random(2) == 1 and math.random(-90, -80) or math.random(80, 90)
    self.dx = math.random(2) == 1 and math.random(-90, -80) or math.random(80, 90)
end


function Asteroid:update(dt)
    if self.y < 0 and self.dy < 0 then
        self.y = VIRTUAL_HEIGHT - self.radius
    end
    if self.y >= VIRTUAL_HEIGHT - self.radius / 2 then
        self.y = 0 + self.radius / 2
    end
    if self.x < 0 and self.dx < 0 then
        self.x = VIRTUAL_WIDTH - self.radius
    end
    if self.x >= VIRTUAL_WIDTH - self.radius / 2 then
        self.x = 0 + self.radius / 2
    end
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Asteroid:setDX(dx)
    self.dx = dx
end

function Asteroid:setDY(dy)
    self.dy = dy
end

function Asteroid:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end