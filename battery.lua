require "collisions"

local battery = {}
battery.__index = battery

function newBattery(object)
	local n = object
	n.x = n.x - 3
	n.y = n.y - 5
	n.width = 6
	n.height = 10

	n.yspeed = -100
	n.yaccel = 300

	n.anim = newAnimation(lutro.graphics.newImage(
				"assets/battery.png"), n.width, n.height, 1, 10)

	n.anim.timer = math.random(0, 1)

	return setmetatable(n, battery)
end

function battery:update(dt)
	self.yspeed = self.yspeed + self.yaccel * dt
	self.y = self.y + dt * self.yspeed

	self.anim:update(dt)
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
			self.yspeed = -self.yspeed / 2
			self.y = self.y + dy
			lutro.audio.play(sfx_step)
		end
	end
end