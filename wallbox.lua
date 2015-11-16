require "collisions"

local wallbox = {}
wallbox.__index = wallbox

function newWallBox(object)
	local n = object
	n.stance = "closed"

	n.imgs = {}
	n.imgs.closed = lutro.graphics.newImage("assets/wallbox.png")
	n.imgs.opened = lutro.graphics.newImage("assets/wallbox_open.png")

	n.img = n.imgs[n.stance]

	return setmetatable(n, wallbox)
end

function wallbox:update(dt)
	self.img = self.imgs[self.stance]
end

function wallbox:draw()
	lutro.graphics.draw(self.img, self.x, self.y)
end

function wallbox:on_collide(e1, e2, dx, dy)
	if e2.type == "saber" then
		if self.stance == "closed" then
			lutro.audio.play(sfx_wallbox)
			table.insert(entities, newBattery(
				{x = self.x + self.width/2, y = self.y + self.height / 2}))
		end
		self.stance = "opened"
	end
end
