extends Node
class_name EnemyManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.start()

func on_spawn_timer() -> void:
	print ("thing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
