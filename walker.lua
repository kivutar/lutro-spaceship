require "collisions"

local walker = {}
walker.__index = walker

function newWalker(object)
	local n = object
	n.width = 26
	n.height = 40
	n.xspeed = 0
	n.yspeed = 0
	n.yaccel = 0.05
	n.direction = "left"
	n.stance = "run"
	n.DO_JUMP = 0
	n.hit = 0
	n.die = 0
	n.hp = 3
	n.GOLEFT = true

	n.animations = {
		run = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/walker_run_left.png"),  48, 48, 2, 20),
			right = newAnimation(lutro.graphics.newImage(
				"assets/walker_run_right.png"), 48, 48, 2, 20)
		},
		jump = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/walker_jump_left.png"),  48, 48, 1, 1),
			right = newAnimation(lutro.graphics.newImage(
				"assets/walker_jump_right.png"), 48, 48, 1, 1)
		},
		fall = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/walker_fall_left.png"),  48, 48, 1, 1),
			right = newAnimation(lutro.graphics.newImage(
				"assets/walker_fall_right.png"), 48, 48, 1, 1)
		},
		hit = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/walker_hit_left.png"),  48, 48, 1, 60),
			right = newAnimation(lutro.graphics.newImage(
				"assets/walker_hit_right.png"), 48, 48, 1, 60)
		},
		die = {
			left  = newAnimation(lutro.graphics.newImage(
				"assets/walker_die_left.png"),  48, 48, 1, 60),
			right = newAnimation(lutro.graphics.newImage(
				"assets/walker_die_right.png"), 48, 48, 1, 60)
		},
	}

	n.anim = n.animations[n.stance][n.direction]

	return setmetatable(n, walker)
end

function walker:on_the_ground()
	return solid_at(self.x + 1, self.y+40, self)
		or solid_at(self.x + 25, self.y+40, self)
end

function walker:update(dt)
	if self.hit > 0 then
		self.hit = self.hit - 1
	end

	if self.die > 0 then
		self.die = self.die - 1
	end

	if self.die == 0 and self.hp == 0 then
		lutro.audio.play(sfx_explode)
		table.insert(entities, newBattery(
				{x = self.x + self.width/2, y = self.y + self.height / 2}))
		for i=1,32 do
			table.insert(entities, newPart(
				{x = self.x + self.width/2, y = self.y + self.height / 2}))
		end
		for i=1, #entities do
			if entities[i] == self then
				table.remove(entities, i)
			end
		end

	end

	-- gravity
	if not self:on_the_ground() then
		self.yspeed = self.yspeed + self.yaccel
		self.y = self.y + self.yspeed
	end

	if solid_at(self.x - 16, self.y+40-8, self) and not solid_at(self.x - 16, self.y+40-8-16, self) and self.GOLEFT 
	or solid_at(self.x + 25 + 16, self.y+40-8, self) and not solid_at(self.x + 25 + 16, self.y+40-8-16, self) and not self.GOLEFT 
	then
		self.y = self.y - 1
		self.yspeed = -2
	end

	if solid_at(self.x - 1, self.y+40-8-16, self) and self.GOLEFT and self:on_the_ground() 
	or solid_at(self.x + 25 + 1, self.y+40-8-16, self) and not self.GOLEFT and self:on_the_ground() 
	or solid_at(self.x - 2, self.y+40-8-32, self) and self.GOLEFT and self:on_the_ground() 
	or solid_at(self.x + 25 + 1, self.y+40-8-32, self) and not self.GOLEFT and self:on_the_ground()
	then
		self.GOLEFT = not self.GOLEFT	
	end

	if not solid_at(self.x     , self.y+40, self) and self.GOLEFT and self:on_the_ground() 
	or not solid_at(self.x + 25, self.y+40, self) and not self.GOLEFT and self:on_the_ground()
	then
		self.y = self.y - 1
		self.yspeed = -2
	end

	-- moving
	if self.GOLEFT and self.hit == 0 and self.die == 0 then
		self.xspeed = -1
		self.direction = "left"
	elseif self.hit == 0 and self.die == 0 then
		self.xspeed = 1
		self.direction = "right"
	end

	self.stance = "run"

	if not self:on_the_ground() then
		if self.yspeed > 0 then
			self.stance = "fall"
		else
			self.stance = "jump"
		end
	end

	if self.hit > 0 then
		if self.xspeed > 0 then
			self.xspeed = self.xspeed - 0.05
			if self.xspeed < 0 then
				self.xspeed = 0
			end
		elseif self.xspeed < 0 then
			self.xspeed = self.xspeed + 0.05;
			if self.xspeed > 0 then
				self.xspeed = 0
			end
		end
	end

	-- apply speed
	self.x = self.x + self.xspeed;

	if self.die > 0 then
		self.stance = "die"
	elseif self.hit > 0 then
		self.stance = "hit"
	end

	local anim = self.animations[self.stance][self.direction]
	-- always animate from first frame 
	if anim ~= self.anim then
		anim.timer = 0
	end
	self.anim = anim

	self.anim:update(1/60)
end

function walker:draw()
	self.anim:draw(self.x - 11, self.y - 8)
end

function walker:on_collide(e1, e2, dx, dy)
	if e2.type == "ground"
	or e2.type == "door"
	or e2.type == "laser"
	then
		if math.abs(dy) < math.abs(dx) and dy ~= 0 then
			self.yspeed = 0
			self.y = self.y + dy
		end

		if math.abs(dx) < math.abs(dy) and dx ~= 0 then
			self.xspeed = 0
			self.x = self.x + dx
			--self.GOLEFT = not self.GOLEFT
		end
	elseif e2.type == "scientist" then
		if math.abs(dx) < math.abs(dy) and dx ~= 0 then
			self.xspeed = 0
			self.GOLEFT = not self.GOLEFT
		end
	elseif e2.type == "saber" and (self.hit == 0 or self.hit < 20) and self.die == 0 then
		self.hp = self.hp - 1
		if self.hp <= 0 then 
			lutro.audio.play(sfx_robot_die)
			self.die = 60
			self.xspeed = 0
		else
			lutro.audio.play(sfx_robot_hit)
			self.hit = 60
			if dx > 0 then
				self.xspeed = 2
			else
				self.xspeed = -2
			end
		end
	end
end
