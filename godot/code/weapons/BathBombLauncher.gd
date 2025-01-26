extends Weapon
class_name BathBombLauncher

const bath_bomb_projectile_template = preload("res://scenes/game/projectiles/bath_bomb_projectile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _shoot() -> void:
	var projectile = bath_bomb_projectile_template.instantiate()
	projectile.global_position = $ProjectileSpawnPosition.global_position
	projectile.velocity = orientation
	## add projectile as child of (weapon -> player -> scene)
	get_parent().get_parent().add_child(projectile)
