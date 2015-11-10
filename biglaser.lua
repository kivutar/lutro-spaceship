local biglaser = {}
biglaser.__index = biglaser

function newBigLaser(object)
	local n = object

	n.animations = {
		off  = newAnimation(lutro.graphics.newImage(
				"assets/biglaser_off.png"), 32, 16, 1, 60),
		warn = newAnimation(lutro.graphics.newImage(
				"assets/biglaser_warn.png"), 32, 16, 1, 60),
		on   = newAnimation(lutro.graphics.newImage(
				"assets/biglaser_on.png"), 32, 16, 1, 60),
	}

	n.stance = "off"

	n.counter = 0

	n.anim = n.animations[n.stance]

	return setmetatable(n, biglaser)
end

function biglaser:update(dt)
	self.counter = self.counter + dt

	if self.counter >= 0 and self.counter < 2 then
		self.stance = "off"
	elseif self.counter >= 2 and self.counter < 3 then
		self.stance = "warn"
	elseif self.counter >= 3 and self.counter < 5 then
		self.stance = "on"
	elseif self.counter >= 5 then
		self.counter = 0
	end

	local anim = self.animations[self.stance]
	if self.anim ~= anim then
		if self.stance == "on" then
			lutro.audio.play(sfx_biglaser_on)
		elseif self.stance == "warn" then
			lutro.audio.play(sfx_biglaser_warn)
		end
		self.anim = anim
	end

	self.anim:update(dt)
end

function biglaser:draw()
	for i = 0, self.height / 16 - 1 do
		self.anim:draw(self.x, self.y + i*16)
	end
end

function biglaser:on_collide(e1, e2, dx, dy)
end
