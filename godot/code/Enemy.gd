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
			var x_variation = (randi() % 2*magnitude) - magnitude
			var y_variation = (randi() % 2*magnitude) - magnitude
			goal_position += Vector2(x_variation, y_variation)
			print(global_position)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if path != pathOptions.STAND:
		$MovementTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = global_position.direction_to(goal_position)
	velocity = direction * speed
	move_and_slide()
