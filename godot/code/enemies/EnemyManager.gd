extends Node
class_name EnemyManager


@onready var enemySpawner = $enemyTrack/enemySpawn
@onready var player : Player = get_node("../Player/Player")
#const enemy_template = preload("res://scenes/game/enemies/enemy_template.tscn")
var enemy_template = preload("res://scenes/game/enemies/splugey.tscn")

var kill_count = [0, 0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.start()

func on_spawn_timer() -> void:
	var newEnemy = enemy_template.instantiate()
	newEnemy.speed = 5
	# newEnemy.path = Enemy.pathOptions.MOVE_TO_PLAYER # Moves enemy to player
	newEnemy.died.connect(on_enemy_died)
	enemySpawner.progress_ratio = randf()
	newEnemy.global_position = enemySpawner.global_position
	#newEnemy
	self.add_child(newEnemy)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_enemy_died(enemy : Enemy) -> void:
	var id_num = enemy.uid
	var id_string = enemy.enemy_id
	kill_count[id_num] += 1
	if kill_count[id_num] >= 10:
		UserSettings.UNLOCKED_BUBBLEDEX_ENTRIES.append(id_string)
	player.on_enemy_killed(enemy)
