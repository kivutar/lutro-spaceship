require "collisions"

local screen = {}
screen.__index = screen

function newScreen(object)
	local n = object

	n.anim = newAnimation(lutro.graphics.newImage(
				"assets/screen.png"), n.width, n.height, 1, 10)

	return setmetatable(n, screen)
end

function screen:update(dt)
	self.anim:update(dt)
end

function screen:draw()
	self.anim:draw(self.x, self.y)
end
