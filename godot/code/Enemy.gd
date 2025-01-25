extends Node
class_name Enemy

enum pathOptions { STAND, WANDER, MOVE_TO_PLAYER }

@export var strength : float
@export var speed : float
@export var path : pathOptions

func set_goal_point() -> void:
	print("global_position")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if path != pathOptions.STAND:
		$MovementTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
