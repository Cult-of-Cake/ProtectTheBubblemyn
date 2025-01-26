extends Weapon
class_name BasicBubbleShooter

const bubble_projectile_template = preload("res://scenes/game/projectiles/bubble_projectile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shoot() -> void:
	var bullet = bubble_projectile_template.instantiate()
	bullet.global_position = $ProjectileSpawnPosition.global_position
	bullet.velocity = orientation
	# add bullet as child of (weapon -> player -> scene)
	get_parent().get_parent().add_child(bullet)
