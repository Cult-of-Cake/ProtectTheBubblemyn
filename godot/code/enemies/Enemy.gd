extends CharacterBody2D
class_name Enemy

enum pathOptions { STAND, WANDER, MOVE_TO_PLAYER }

var isEnemy : bool = true

@export var enemy_id : String
@export var uid : int
@export var current_health : int
@export var strength : float
@export var speed : float
@export var path : pathOptions
@export var xp_worth : int

signal died

var goal_position : Vector2
func set_goal_point() -> void:
	match path:
		pathOptions.WANDER:
			const magnitude = 100
			randomize()
			var x_variation = randi_range(-magnitude, magnitude)
			var y_variation = randi_range(-magnitude, magnitude)
			goal_position = global_position + Vector2(x_variation, y_variation)
			$MovementTimer.wait_time = randf_range(1, 2.5)
		pathOptions.MOVE_TO_PLAYER:
			goal_position = get_parent().get_parent().get_node("Player").get_node("Player").position
	var direction = get_direction()
	choose_sprite(direction)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if path != pathOptions.STAND:
		$MovementTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !(path == pathOptions.STAND):
		var direction = global_position.direction_to(goal_position)
		velocity = direction * speed * 5
		move_and_slide()

func take_damage(damage: int) -> void:
	current_health -= damage
	if current_health < 0:
		die()

func get_direction():
	var direction
	if abs(velocity.x) > abs (velocity.y):
		if velocity.x > 0: 
			direction = "right"
		elif velocity.x < 0:
			direction = "left"
	elif abs(velocity.y) > abs (velocity.x):
		if velocity.y > 0:
			direction = "down"
		elif velocity.y < 0:
			direction = "up"
	else:
		direction = "down"
	return direction
func choose_sprite(direction):
	remove_sprites()
	if(direction == "right"):
		get_node("Right").visible = true
	elif(direction == "left"):
		get_node("Left").visible = true
	elif(direction == "up"):
		get_node("Away").visible = true
	elif(direction == "down"):
		get_node("Facing").visible = true

func remove_sprites():
	get_node("Facing").visible = false
	get_node("Left").visible = false
	get_node("Right").visible = false
	get_node("Away").visible = false


func die() -> void:
	died.emit(self)
	queue_free()
