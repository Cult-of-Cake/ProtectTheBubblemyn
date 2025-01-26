extends Node2D
class_name PowerUp

enum Types { SPEEDUP, INVINCIBLE, HEAL, ENUM_SIZE }
var icon_name = [ "soap", "mr_green", "heal" ]
@export var type : Types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file_name = "res://graphics/icons/icon_" + icon_name[type] + ".png"
	var image = Image.load_from_file(file_name)
	$Sprite2D.texture = ImageTexture.create_from_image(image)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_collect(body : Player):
	body.on_powerup_collide(type)
	queue_free()
