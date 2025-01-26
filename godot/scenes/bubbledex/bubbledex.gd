extends Control

@onready var globals = get_node("/root/UserSettings")
@onready var itemList = %ItemList

@export var entries: Array[Bubbledex_Entry] = []



signal button_pressed(entry: Bubbledex_Entry)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rebuild_bubbledex()
	
func remove_all_children() -> void: 
	var children = itemList.get_children()
	for child : Node in children:
		child.free()

	
func rebuild_bubbledex() -> void: 
	remove_all_children()
	for entry : Bubbledex_Entry in entries:
		var button = Button.new()
		button.text = entry.entry_name
		button.pressed.connect(Callable(self, "_on_button_pressed").bind(entry))
		button.visible = false
		if entry.id in globals.UNLOCKED_BUBBLEDEX_ENTRIES:
			button.visible = true
		itemList.add_child(button)

func _on_button_pressed(entry: Bubbledex_Entry) -> void:
	$TextureRect.texture = entry.image
	$RichTextLabel.text = entry.description
