extends Node2D
class_name PowerUp

enum Types { SPEEDUP }
@export var type : Types


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_collect(body : Player):
	body.on_powerup_collide(type)
	queue_free()
