extends CharacterBody2D
class_name BathBombProjectile

const bubble_projectile_template = preload("res://scenes/game/projectiles/bubble_projectile.tscn")

var bombLifespan = 3
var damageOnDirectCollision = 2
var speed = 75

var numProjectilesToSpawn = 8

var projectileSpawnVelocities : Array[Vector2]

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "isEnemy" in body && body.isEnemy:
		_detonate(body as Enemy)
	
func _ready():
	# On detonation, projectiles spawn at equidistant points around the circle
	# with velocity vectors directly out from that point.
	for n in range(numProjectilesToSpawn):
		var radians = n * 2 * PI / numProjectilesToSpawn
		var x = cos(radians)
		var y = sin(radians)
		projectileSpawnVelocities.append(Vector2(x, y))
	
	$DetonationTimer.start(bombLifespan)
	
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta * speed)

func _detonation_timer_elapsed() -> void:
	_detonate(null)

func _detonate(collidedEnemy: Enemy) -> void:
	$DetonationTimer.stop()
	if collidedEnemy != null:
		collidedEnemy.take_damage(damageOnDirectCollision)
	
	#spawn bubble projectiles
	for spawnVelocity in projectileSpawnVelocities:
		var projectile = bubble_projectile_template.instantiate()
		projectile.global_position = global_position
		projectile.velocity = spawnVelocity
		# add spawned projectile as child of (bomb-projectile -> scene)
		get_parent().add_child(projectile)
	
	queue_free()
