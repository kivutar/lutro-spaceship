require "collisions"

local battery = {}
battery.__index = battery

function newBattery(object)
	local n = object
	n.width = 6
	n.height = 10
	n.x = n.x - n.width/2
	n.y = n.y - n.height/2

	n.yspeed = -2
	n.yaccel = 0.05

	n.type = "battery"

	n.bounce = 2

	n.anim = newAnimation(lutro.graphics.newImage(
				"assets/battery.png"), n.width, n.height, 1, 1)

	return setmetatable(n, battery)
end

function battery:update(dt)
	self.yspeed = self.yspeed + self.yaccel
	self.y = self.y + self.yspeed

	self.anim:update(1/60)
end

function battery:draw()
	self.anim:draw(self.x, self.y)
end

function battery:on_collide(e1, e2, dx, dy)
	if e2.type == "ground"
	or e2.type == "door"
	or e2.type == "laser"
	then
		if math.abs(dy) < math.abs(dx) and dy ~= 0 then
			self.y = self.y + dy
			if self.bounce > 0 then
				self.yspeed = -self.yspeed / 2
				lutro.audio.play(sfx_step)
				self.bounce = self.bounce - 1
			else
				self.yspeed = 0
			end
		end
	end
end