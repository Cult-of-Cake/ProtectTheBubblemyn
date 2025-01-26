extends CharacterBody2D
class_name Enemy

enum pathOptions { STAND, WANDER, MOVE_TO_PLAYER }

var isEnemy : bool = true

@export var enemy_id : String
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
	
func die() -> void:
	died.emit(enemy_id)
	queue_free()
