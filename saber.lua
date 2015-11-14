local saber = {}
saber.__index = saber

function newSaber(object)
	local n = object
	n.x = n.holder.x - 14
	n.y = n.holder.y - 8
	if n.holder.direction == "right" then
		n.x = n.holder.x + 13
	end
	n.width = 14
	n.height = 30
	n.type = "saber"

	return setmetatable(n, saber)
end

function saber:update(dt)
	self.x = self.holder.x - 14
	self.y = self.holder.y - 8
	if self.holder.direction == "right" then
		self.x = self.holder.x + 13
	end
end

function saber:draw()
	--lutro.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function saber:on_collide(e1, e2, dx, dy)
end
