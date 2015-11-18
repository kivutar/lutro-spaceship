require "collisions"

local leds = {}
leds.__index = leds

function newLeds(object)
	local n = object
	color = n.properties.color or "red"

	n.anim = newAnimation(lutro.graphics.newImage(
				"assets/leds_"..color..".png"), 16, 16, 1, 20)

	return setmetatable(n, leds)
end

function leds:update(dt)
	self.anim:update(1/60)
end

function leds:draw()
	self.anim:draw(self.x, self.y)
end
