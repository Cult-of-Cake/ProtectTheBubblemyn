extends CharacterBody2D
class_name Enemy

enum pathOptions { STAND, WANDER, MOVE_TO_PLAYER }

@export var strength : float
@export var speed : float
@export var path : pathOptions

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if path != pathOptions.STAND:
		$MovementTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = global_position.direction_to(goal_position)
	velocity = direction * speed * 5
	move_and_slide()
