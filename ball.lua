require "collisions"

local ball = {}
ball.__index = ball

function newBall(object)
	local n = object
	n.width = 16
	n.height = 16
	n.xspeed = n.properties.xspeed
	n.yspeed = n.properties.yspeed
	n.stance = "roll"
	n.DO_JUMP = 0
	n.hit = 0
	n.die = 0
	n.hp = 3

	n.animations = {
		roll = newAnimation(lutro.graphics.newImage(
				"assets/ball_roll.png"), 32, 32, 1, 20),
	}

	n.anim = n.animations[n.stance]

	return setmetatable(n, ball)
end

function ball:update(dt)
	-- apply speed
	self.x = self.x + self.xspeed;
	self.y = self.y + self.yspeed;

	self.anim = self.animations[self.stance]

	self.anim:update(1/60)
end

function ball:draw()
	self.anim:draw(self.x - 8, self.y - 8)
end

function ball:on_collide(e1, e2, dx, dy)
	if e2.type == "ground"
	or e2.type == "door"
	or e2.type == "laser"
	then
		if math.abs(dy) < math.abs(dx) and dy ~= 0 then
			self.y = self.y + dy
			self.yspeed = -self.yspeed
			lutro.audio.play(sfx_step)
		end

		if math.abs(dx) < math.abs(dy) and dx ~= 0 then
			self.x = self.x + dx
			self.xspeed = -self.xspeed
			lutro.audio.play(sfx_step)
		end
	end
end
