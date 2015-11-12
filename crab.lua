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
	n.hit = 0
	n.die = 0
	n.hp = 3
	n.DIR = 0

	n.animations = {
		run = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/crab_run_left.png"),  32, 32, 2, 10),
			right = newAnimation(lutro.graphics.newImage(
				"assets/crab_run_right.png"), 32, 32, 2, 10)
		},
		hit = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/crab_hit_left.png"),  32, 32, 1, 60),
			right = newAnimation(lutro.graphics.newImage(
				"assets/crab_hit_right.png"), 32, 32, 1, 60)
		},
		die = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/crab_die_left.png"),  32, 32, 1, 60),
			right = newAnimation(lutro.graphics.newImage(
				"assets/crab_die_right.png"), 32, 32, 1, 60)
		},
	}

	n.anim = n.animations[n.stance][n.direction]

	return setmetatable(n, crab)
end

function crab:on_the_ground()
	return solid_at(self.x + 1, self.y+14, self)
		or solid_at(self.x + 13, self.y+14, self)
end

function crab:update(dt)
	if self.hit > 0 then
		self.hit = self.hit - dt
	else
		self.hit = 0
	end

	if self.die > 0 then
		self.die = self.die - dt
	elseif self.die < 0 then
		self.die = 0
		self = nil
		for i=1, #entities do
			if entities[i] and entities[i].hp == 0 then
				table.remove(entities, i)
			end
		end
	end

	-- gravity
	if not self:on_the_ground() then
		self.yspeed = self.yspeed + self.yaccel * dt
		self.y = self.y + dt * self.yspeed
	end

	-- moving
	if self.DIR and self.hit == 0 and self.die == 0 then
		self.xspeed = -50
		self.direction = "left";
	elseif self.hit == 0 and self.die == 0 then
		self.xspeed = 50
		self.direction = "right";
	end

	if self.hit > 0 then
		if self.xspeed > 0 then
			self.xspeed = self.xspeed - 2
			if self.xspeed < 0 then
				self.xspeed = 0;
			end
		elseif self.xspeed < 0 then
			self.xspeed = self.xspeed + 2;
			if self.xspeed > 0 then
				self.xspeed = 0;
			end
		end
	end

	-- apply speed
	self.x = self.x + self.xspeed * dt;

	if self.die > 0 then
		self.stance = "die"
	elseif self.hit > 0 then
		self.stance = "hit"
	else
		self.stance = "run"
	end

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
	elseif e2.type == "saber" and (self.hit == 0 or self.hit < 0.4) and self.die == 0 then
		self.hp = self.hp - 1
		if self.hp <= 0 then 
			lutro.audio.play(sfx_robot_die)
			self.die = 0.7
			self.xspeed = 0
		else
			lutro.audio.play(sfx_robot_hit)
			self.hit = 1.0
			if dx > 0 then
				self.xspeed = 100
			else
				self.xspeed = -100
			end
		end
	end
end
