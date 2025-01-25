extends Node
class_name EnemyManager

#const enemy_template = preload("res://scenes/game/enemies/enemy_template.tscn")
var enemy_template = preload("res://scenes/game/enemies/splugey.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.start()

func on_spawn_timer() -> void:
	var newEnemy = enemy_template.instantiate()
	newEnemy.speed = 5
	#newE
	self.add_child(newEnemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
