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
	self.counter = self.counter + 1

	if self.counter >= 0 and self.counter < 120 then
		self.stance = "off"
	elseif self.counter >= 120 and self.counter < 240 then
		self.stance = "warn"
	elseif self.counter >= 240 and self.counter < 360 then
		self.stance = "on"
	elseif self.counter >= 360 then
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

	self.anim:update(1/60)
end

function biglaser:draw()
	for i = 0, self.height / 16 - 1 do
		self.anim:draw(self.x, self.y + i*16)
	end
end

function biglaser:on_collide(e1, e2, dx, dy)
end
