extends Node2D

func spawn_powerup():
	var map = get_parent()
	var size = map.mapSize
	var leftEdge  = (size.x/2) * -1
	var rightEdge = (size.x/2)
	var topEdge = (size.y/2) * -1
	var bottomEdge = size.y/2
	randomize()
	var x = randi_range(leftEdge, rightEdge)
	var y = randi_range(topEdge, bottomEdge)
	var spawnLocation = Vector2(x, y)

	var newPowerup = load("res://scenes/powers/map_power.tscn").instantiate()
	var numTypes = newPowerup.Types.ENUM_SIZE
	newPowerup.type = randi_range(0, numTypes - 1)
	newPowerup.position = spawnLocation
	map.get_node("Power-Ups").add_child(newPowerup)
	
