extends Enemy

var bulletRes = load("res://scenes/game/projectiles/grime_projectile.tscn")

func _shoot():
	var gameScene = get_parent().get_parent()
	var player = gameScene.get_node("Player").get_node("Player")
	var bullet = bulletRes.instantiate()
	bullet.damage = strength
	bullet.target = player.position
	bullet.position = position
	sprite_swap()
	await get_tree().create_timer(0.5).timeout
	gameScene.add_child(bullet)

func sprite_swap():
	get_node("StandSprite").visible = false
	get_node("ShootSprite").visible = true
	get_node("ShootSprite").play()
	await get_tree().create_timer(1.0).timeout
	get_node("StandSprite").visible = true
	get_node("ShootSprite").visible = false
	
