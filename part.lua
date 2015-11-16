require "collisions"

local part = {}
part.__index = part

function newPart(object)
	local n = object
	n.width = math.random(1, 4)
	n.height = n.width

	n.xspeed = 100*(math.random()-0.5)
	n.yspeed = -200*(math.random())
	n.yaccel = 300

	n.bounce = 16

	n.anim = newAnimation(lutro.graphics.newImage(
				"assets/part_"..n.width..".png"), n.width, n.height, 1, 10)

	n.anim.timer = math.random(0, 1)

	return setmetatable(n, part)
end

function part:update(dt)
	self.yspeed = self.yspeed + self.yaccel * dt
	self.y = self.y + dt * self.yspeed

	self.x = self.x + self.xspeed * dt;

	self.anim:update(dt)
end

function part:draw()
	self.anim:draw(self.x, self.y)
end

function part:on_collide(e1, e2, dx, dy)
	if e2.type == "ground"
	or e2.type == "door"
	or e2.type == "laser"
	then
		if math.abs(dy) < math.abs(dx) and dy ~= 0 then
			self.yspeed = -self.yspeed / 2
			self.y = self.y + dy

			if self.bounce == 16 then
				lutro.audio.play(sfx_step)
			end
		end

		if math.abs(dx) < math.abs(dy) and dx ~= 0 then
			self.xspeed = -self.xspeed / 2
			self.x = self.x + dx
			self.GOLEFT = not self.GOLEFT
		end

		self.bounce = self.bounce - 1
		if self.bounce <= 0 then
			for i=1, #entities do
				if entities[i] == self then
					table.remove(entities, i)
				end
			end
		end
	end
end