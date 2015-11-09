require "global"
require "tiled"
require "anim"
require "scientist"
require "door"
require "laser"
require "crab"

function lutro.conf(t)
	t.width  = SCREEN_WIDTH
	t.height = SCREEN_HEIGHT
end

add_entity_from_map = function(object)
	if object.type == "ground" then
		table.insert(entities, object)
	elseif object.type == "door" then
		table.insert(entities, newDoor(object))
	elseif object.type == "laser" then
		table.insert(entities, newLaser(object))
	elseif object.type == "crab" then
		table.insert(entities, newCrab(object))
	end
end

function lutro.load()
	camera_x = 0
	camera_y = 0
	lutro.graphics.setBackgroundColor(0, 0, 0)
	stars = lutro.graphics.newImage("assets/stars.png")
	map = tiled_load("assets/spaceship.json")
	tiled_load_objects(map, add_entity_from_map)
	scientist = newScientist()
	table.insert(entities, scientist)
end

function lutro.update(dt)
	for i=1, #entities do
		if entities[i].update then
			entities[i]:update(dt)
		end
	end
	detect_collisions()
end

function lutro.draw()
	lutro.graphics.clear()

	lutro.graphics.translate(0, 0)
	lutro.graphics.draw(stars)

	lutro.graphics.push()

	-- camera
	camera_x = - scientist.x + SCREEN_WIDTH/2 - scientist.width/2;
	if camera_x > 0 then
		camera_x = 0
	end
	if camera_x < -(map.width * map.tilewidth) + SCREEN_WIDTH then
		camera_x = -(map.width * map.tilewidth) + SCREEN_WIDTH
	end

	camera_y = - scientist.y + SCREEN_HEIGHT/2 - scientist.height/2;
	if camera_y > 0 then
		camera_y = 0
	end
	if camera_y < -(map.height * map.tileheight) + SCREEN_HEIGHT then
		camera_y = -(map.height * map.tileheight) + SCREEN_HEIGHT
	end

	lutro.graphics.translate(camera_x, camera_y)

	tiled_draw_layer(map.layers[1])
	tiled_draw_layer(map.layers[2])
	for i=1, #entities do
		if entities[i].draw then
			entities[i]:draw(dt)
		end
	end
	tiled_draw_layer(map.layers[3])

	lutro.graphics.pop()
end
