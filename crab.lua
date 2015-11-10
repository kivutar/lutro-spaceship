require "collisions"

local crab = {}
crab.__index = crab

function newCrab(object)
	local n = object
	n.width = 14
	n.height = 14
	n.xspeed = 0
	n.yspeed = 0
	n.yaccel = 300
	n.direction = "left"
	n.stance = "run"
	n.DO_JUMP = 0
	n.DIR = 0

	n.animations = {
		run = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/crab_run_left.png"),  32, 32, 2, 10),
			right = newAnimation(lutro.graphics.newImage(
				"assets/crab_run_right.png"), 32, 32, 2, 10)
		},
	}

	n.anim = n.animations[n.stance][n.direction]

	return setmetatable(n, crab)
end

function crab:on_the_ground()
	return solid_at(self.x + 1, self.y+14, self)
		or solid_at(self.x + 14, self.y+14, self)
end

function crab:update(dt)

	-- gravity
	if not self:on_the_ground() then
		self.yspeed = self.yspeed + self.yaccel * dt
		self.y = self.y + dt * self.yspeed
	end

	-- moving
	if self.DIR then
		self.xspeed = -20
		self.direction = "left";
	else
		self.xspeed = 20
		self.direction = "right";
	end

	-- apply speed
	self.x = self.x + self.xspeed * dt;

	local anim = self.animations[self.stance][self.direction]
	-- always animate from first frame 
	if anim ~= self.anim then
		anim.timer = 0
	end
	self.anim = anim;

	self.anim:update(dt)
end

function crab:draw()
	self.anim:draw(self.x - 9, self.y - 18)
end

function crab:on_collide(e1, e2, dx, dy)
	if e2.type == "ground"
	or e2.type == "door"
	or e2.type == "laser"
	then
		if math.abs(dy) < math.abs(dx) and dy ~= 0 then
			self.yspeed = 0
			self.y = self.y + dy
			lutro.audio.play(self.sfx.step)
		end

		if math.abs(dx) < math.abs(dy) and dx ~= 0 then
			self.xspeed = 0
			self.x = self.x + dx
			self.DIR = not self.DIR
		end
	end
end
