extends Enemy

var bulletRes = load("res://scenes/game/projectiles/grime_projectile.tscn")

func _shoot():
	var gameScene = get_parent().get_parent()
	var player = gameScene.get_node("Player").get_node("Player")
	var bullet = bulletRes.instantiate()
	bullet.damage = strength
	bullet.target = player.position
	bullet.position = position
	gameScene.add_child(bullet)
	
	
