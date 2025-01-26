extends Node
class_name EnemyManager


@onready var enemySpawner = $enemyTrack/enemySpawn
#const enemy_template = preload("res://scenes/game/enemies/enemy_template.tscn")
var enemy_template = preload("res://scenes/game/enemies/splugey.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.start()

func on_spawn_timer() -> void:
	var newEnemy = enemy_template.instantiate()
	newEnemy.speed = 5
	# newEnemy.path = Enemy.pathOptions.MOVE_TO_PLAYER # Moves enemy to player
	
	enemySpawner.progress_ratio = randf()
	newEnemy.global_position = enemySpawner.global_position
	#newEnemy
	self.add_child(newEnemy)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
