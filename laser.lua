local laser = {}
laser.__index = laser

function newLaser(object)
	local n = object
	n.laser = newAnimation(lutro.graphics.newImage("assets/laser.png"),  16, 16, 1, 60)
	return setmetatable(n, laser)
end

function laser:update(dt)
	self.laser:update(dt)
end

function laser:draw()
	self.laser:draw(self.x, self.y)
end

function laser:on_collide(e1, e2, dx, dy)
end
