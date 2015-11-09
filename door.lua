local door = {}
door.__index = door

function newDoor(object)
	local n = object
	return setmetatable(n, door)
end

function door:update(dt)
end

function door:draw()
	--lutro.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function door:on_collide(e1, e2, dx, dy)
end
