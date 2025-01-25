extends CharacterBody2D

var bulletLifespan = 5
var damage = 1
var speed = 175
var target

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "isPlayer" in body && body.isPlayer:
		body.take_damage(damage)
	queue_free()

#This refers to a target, which must be set by whatever created this before this scene is added as a child
func _ready():
	velocity = position.direction_to(target)
	await get_tree().create_timer(bulletLifespan).timeout
	queue_free()
	
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta * speed)
