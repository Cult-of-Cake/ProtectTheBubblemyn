extends Control

@onready var globals = get_node("/root/UserSettings")

@export var entries: Array[Bubbledex_Entry] = []

signal button_pressed(entry: Bubbledex_Entry)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for entry : Bubbledex_Entry in entries:
		var button = Button.new()
		button.text = entry.entry_name
		button.pressed.connect(Callable(self, "_on_button_pressed").bind(entry))
		button.visible = false
		print("Searching for " + entry.id) 
		print(globals.UNLOCKED_BUBBLEDEX_ENTRIES)
		if entry.id in globals.UNLOCKED_BUBBLEDEX_ENTRIES:
			print(entry.id + " Found!") 
			button.visible = true
		%ItemList.add_child(button)

func _on_button_pressed(entry: Bubbledex_Entry) -> void:
	$TextureRect.texture = entry.image
	$RichTextLabel.text = entry.description
