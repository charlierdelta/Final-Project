--[[
	-- Victory Class --
]]

Victory = Class{}
--[[
	Victories are circles without a dy or dx component and thus are static. Takes a different color to differentiate
	from other classes. A seperate class from all others for clarity.
	
]]
function Victory:init(x, y, radius, red, green, blue)
	self.x = x
	self.y = y
	self.radius = radius
	self.red = red
	self.green = green
	self.blue = blue
end

function Victory:render()
    love.graphics.setColor(self.red, self.green, self.green)
	love.graphics.circle('fill', self.x, self.y, self.radius)
	love.graphics.setColor(1, 1, 1)
end
