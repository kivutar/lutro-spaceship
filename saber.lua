local saber = {}
saber.__index = saber

function newSaber(object)
	local n = object
	n.x = n.holder.x - 14
	n.y = n.holder.y + 12
	if n.holder.direction == "right" then
		n.x = n.holder.x + 13
	end
	n.width = 12
	n.height = 5
	n.type = "saber"
	n.saber = {}
	n.saber.left  = newAnimation(lutro.graphics.newImage("assets/saber_left.png"), 14, 5, 1, 60)
	n.saber.right = newAnimation(lutro.graphics.newImage("assets/saber_right.png"), 14, 5, 1, 60)
	n.anim = n.saber[n.holder.direction]
	return setmetatable(n, saber)
end

function saber:update(dt)
	self.x = self.holder.x-14
	self.y = self.holder.y+12
	if self.holder.direction == "right" then
		self.x = self.holder.x + 13
	end
	self.anim = self.saber[self.holder.direction]
	self.anim:update(dt)
end

function saber:draw()
	self.anim:draw(self.x, self.y)
end

function saber:on_collide(e1, e2, dx, dy)
end
