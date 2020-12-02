--[[
    This is CS50 2019.
    Games Track
    Pong

    -- Bullet Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a Bullet which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Bullet = Class{}

function Bullet:init(x, y, angle)
    self.x = x
    self.y = y
    self.radius = 3

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the Bullet can move in two dimensions
    self.dy = math.sin(angle) * 300
    self.dx = math.cos(angle) * 300
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Bullet:collides(asteroid)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > asteroid.x + asteroid.radius or asteroid.x > self.x + asteroid.radius then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > asteroid.y + asteroid.radius or asteroid.y > self.y + asteroid.radius then
        return false
    end 

    -- if the above aren't true, they're overlapping
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



--[[
    Simply applies velocity to position, scaled by deltaTime.
]]
function Bullet:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Bullet:setPos(x, y, angle)
    self.x = x
    self.y = y
    
end

function Bullet:render()
    love.graphics.circle('fill', self.x, self.y, self.radius)
end