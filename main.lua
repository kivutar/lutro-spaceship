require "global"
require "tiled"
require "anim"
require "scientist"
require "door"
require "laser"
require "biglaser"
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
	elseif object.type == "biglaser" then
		table.insert(entities, newBigLaser(object))
	elseif object.type == "crab" then
		table.insert(entities, newCrab(object))
	end
end

function lutro.load()

	sfx_jump          = lutro.audio.newSource("assets/jump.wav")
	sfx_step          = lutro.audio.newSource("assets/step.wav")
	sfx_hit           = lutro.audio.newSource("assets/hit.wav")
	sfx_laserhit      = lutro.audio.newSource("assets/laser.wav")
	sfx_biglaser_on   = lutro.audio.newSource("assets/biglaser_on.wav")
	sfx_biglaser_warn = lutro.audio.newSource("assets/biglaser_warn.wav")

	camera_x = 0
	camera_y = 0
	screen_shake = 0
	lutro.graphics.setBackgroundColor(0, 0, 0)
	stars = lutro.graphics.newImage("assets/stars.png")
	map = tiled_load("assets/spaceship.json")
	tiled_load_objects(map, add_entity_from_map)
	scientist = newScientist()
	table.insert(entities, scientist)
end

function lutro.update(dt)
	if screen_shake > 0 then
		screen_shake = screen_shake - dt
	end

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

	-- Shake camera if hit
	local shake_x = 0
	local shake_y = 0
	if screen_shake > 0 then
		shake_x = 5*(math.random()-0.5)
		shake_y = 5*(math.random()-0.5)
	end

	lutro.graphics.translate(camera_x + shake_x, camera_y + shake_y)

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
