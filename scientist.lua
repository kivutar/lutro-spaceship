require "collisions"

local scientist = {}
scientist.__index = scientist

function newScientist()
	local n = {}
	n.width = 12
	n.height = 24
	n.xspeed = 0
	n.yspeed = 0
	n.xaccel = 100
	n.yaccel = 300
	n.x = (SCREEN_WIDTH - n.width) / 2
	n.y = (SCREEN_HEIGHT - n.height) / 2
	n.direction = "left"
	n.stance = "stand"
	n.DO_JUMP = 0
	n.hit = 0
	n.type = "character"

	n.animations = {
		stand = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/scientist_stand_left.png"),  32, 32, 1, 10),
			right = newAnimation(lutro.graphics.newImage(
				"assets/scientist_stand_right.png"), 32, 32, 1, 10)
		},
		hit = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/scientist_hit_left.png"),  32, 32, 1, 10),
			right = newAnimation(lutro.graphics.newImage(
				"assets/scientist_hit_right.png"), 32, 32, 1, 10)
		},
		fall = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/scientist_fall_left.png"),  32, 32, 1, 10),
			right = newAnimation(lutro.graphics.newImage(
				"assets/scientist_fall_right.png"), 32, 32, 1, 10)
		},
		jump = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/scientist_jump_left.png"),  32, 32, 1, 10),
			right = newAnimation(lutro.graphics.newImage(
				"assets/scientist_jump_right.png"), 32, 32, 1, 10)
		},
		run = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/scientist_run_left.png"),  32, 32, 2, 10),
			right = newAnimation(lutro.graphics.newImage(
				"assets/scientist_run_right.png"), 32, 32, 2, 10)
		},
	}

	n.anim = n.animations[n.stance][n.direction]

	return setmetatable(n, scientist)
end

function scientist:on_the_ground()
	return solid_at(self.x + 1, self.y+24, self)
		or solid_at(self.x + 11, self.y+24, self)
end

function scientist:update(dt)
	if self.hit > 0 then
		self.hit = self.hit - dt
	else
		self.hit = 0
	end

	local JOY_LEFT  = lutro.input.joypad("left")
	local JOY_RIGHT = lutro.input.joypad("right")
	local JOY_A     = lutro.input.joypad("a")

	-- gravity
	if not self:on_the_ground() then
		self.yspeed = self.yspeed + self.yaccel * dt
		self.y = self.y + dt * self.yspeed
	end

	-- jumping
	if JOY_A then
		self.DO_JUMP = self.DO_JUMP + 1
	else
		self.DO_JUMP = 0
	end

	if self.DO_JUMP == 1 and self:on_the_ground() then
		self.y = self.y - 1
		self.yspeed = -100
		lutro.audio.play(sfx_jump)
	end

	if self.DO_JUMP > 1 and self.DO_JUMP < 24 and self.yspeed < -90 then
		self.yspeed = -100
	end

	-- moving
	if JOY_LEFT then
		self.xspeed = self.xspeed - self.xaccel * dt;
		if self.xspeed < -100 then
			self.xspeed = -100
		end
		self.direction = "left";
	end

	if JOY_RIGHT then
		self.xspeed = self.xspeed + self.xaccel * dt;
		if self.xspeed > 100 then
			self.xspeed = 100
		end
		self.direction = "right";
	end

	-- apply speed
	self.x = self.x + self.xspeed * dt;

	-- decelerating
	if  not (JOY_RIGHT and self.xspeed > 0)
	and not (JOY_LEFT  and self.xspeed < 0)
	and self:on_the_ground()
	then
		if self.xspeed > 0 then
			self.xspeed = self.xspeed - 10
			if self.xspeed < 0 then
				self.xspeed = 0;
			end
		elseif self.xspeed < 0 then
			self.xspeed = self.xspeed + 10;
			if self.xspeed > 0 then
				self.xspeed = 0;
			end
		end
	end

	-- animations
	if self:on_the_ground() then
		if self.xspeed == 0 then
			self.stance = "stand"
		else
			self.stance = "run"
		end
	else
		if self.yspeed > 0 then
			self.stance = "fall"
		else
			self.stance = "jump"
		end
	end

	if self.hit > 0 then
		self.stance = "hit"
	end

	local anim = self.animations[self.stance][self.direction]
	-- always animate from first frame 
	if anim ~= self.anim then
		anim.timer = 0
	end
	self.anim = anim;

	self.anim:update(dt)
end

function scientist:draw()
	self.anim:draw(self.x - 10, self.y - 8)
end

function scientist:on_collide(e1, e2, dx, dy)
	if e2.type == "ground" then
		if math.abs(dy) < math.abs(dx) and dy ~= 0 then
			self.yspeed = 0
			self.y = self.y + dy
			lutro.audio.play(sfx_step)
		end

		if math.abs(dx) < math.abs(dy) and dx ~= 0 then
			self.xspeed = 0
			self.x = self.x + dx
		end
	elseif e2.type == "door" then
		map = tiled_load("assets/" .. e2.properties.to)
		entities = {self}
		tiled_load_objects(map, add_entity_from_map)
		if e2.properties.x then
			self.x = tonumber(e2.properties.x)
		end
		self.y = self.y + tonumber(e2.properties.y)
	elseif e2.type == "laser" and self.hit == 0 then
		lutro.audio.play(sfx_laserhit)
		screen_shake = 0.25
		self.hit = 0.5
		self.xspeed = - self.xspeed
		self.x = self.x + dx
	elseif e2.type == "crab" and self.hit == 0 then
		lutro.audio.play(sfx_hit)
		screen_shake = 0.25
		self.hit = 0.5
		if dx > 0 then
			self.xspeed = 100
		else
			self.xspeed = -100
		end
		self.y = self.y - 1
		self.yspeed = -50
		self.x = self.x + dx
	end
end
