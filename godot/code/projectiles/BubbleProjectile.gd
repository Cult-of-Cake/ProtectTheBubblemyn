extends CharacterBody2D

var bulletLifespan = 5
var damage = 1
var speed = 500

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "isEnemy" in body && body.isEnemy:
		print("valid target")
		body.take_damage(damage)
	queue_free()
	
func _ready():
	var target = get_global_mouse_position()
	velocity = position.direction_to(target)
	await get_tree().create_timer(bulletLifespan).timeout
	queue_free()
	
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta * speed)
