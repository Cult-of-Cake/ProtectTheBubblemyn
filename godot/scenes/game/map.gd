extends Node2D

var mapSize:Vector2

func _ready():
	var sprite = get_node("Sprite2D")
	var x = sprite.texture.get_width()
	var y = sprite.texture.get_height()
	mapSize = Vector2(x, y)
