extends Weapon
class_name ScatterShot

const bubble_projectile_template = preload("res://scenes/game/projectiles/bubble_projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _shoot() -> void:
	var bullet = bubble_projectile_template.instantiate()
	bullet.scale = Vector2(0.3, 0.3)
	bullet.global_position = $ProjectileSpawnPosition.global_position
	var degrees = rad_to_deg(orientation.angle())
	var scatter = fmod(degrees + randf_range(-30, 30), 360)
	bullet.velocity = Vector2.from_angle(deg_to_rad(scatter))
	# add bullet as child of (weapon -> player -> scene)
	get_parent().get_parent().add_child(bullet)
