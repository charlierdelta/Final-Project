--[[
	-- Wall Class --
]]

Wall = Class{}
--[[
	Walls are circles without a dy or dx component and thus are static. A seperate class from Asteroid for clarity.
	
]]
function Wall:init(x, y, radius)
	self.x = x
	self.y = y
	self.radius = radius
end

function Wall:render()
	love.graphics.circle('fill', self.x, self.y, self.radius)
end
