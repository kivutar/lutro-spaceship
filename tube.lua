require "collisions"

local tube = {}
tube.__index = tube

function newTube(object)
	local n = object

	n.anim = newAnimation(lutro.graphics.newImage(
				"assets/tube_glow.png"), n.width, n.height, 1, 2)

	return setmetatable(n, tube)
end

function tube:update(dt)
	self.anim:update(dt)
end

function tube:draw()
	self.anim:draw(self.x, self.y)
end
