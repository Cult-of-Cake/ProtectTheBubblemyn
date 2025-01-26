extends Weapon
class_name BasicBubbleShooter

const bubble_projectile_template = preload("res://scenes/game/projectiles/bubble_projectile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# orientation is unused in the basic shooter since it aims towards the mouse cursor.
	orientation = Vector2(0.0, 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	# Recieves input to attack
	if Input.is_action_just_pressed("attack"):
		_shoot()


func _shoot() -> void:
	var target = get_global_mouse_position()
	var bullet = bubble_projectile_template.instantiate()
	bullet.global_position = $ProjectileSpawnPosition.global_position
	bullet.velocity = $ProjectileSpawnPosition.global_position.direction_to(target)
	# add bullet as child of (weapon -> player -> scene)
	get_parent().get_parent().add_child(bullet)
