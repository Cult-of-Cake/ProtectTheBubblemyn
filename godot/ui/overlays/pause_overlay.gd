extends Control

signal game_exited

@onready var resume_button := %ResumeButton
@onready var exit_button := %ExitButton
@onready var menu_container := %MenuContainer
@onready var bubbledex = %BubbledexContainer
@onready var bubbledex_button = %BubbledexButton
@onready var exit_bubbledex_button = %ExitBubbledex
@onready var pause_menu_container = %CenterContainer
@onready var weapon_buttons = [%NewWeapon1,%NewWeapon2,%NewWeapon3]
@onready var globals = get_node("/root/UserSettings") 
@onready var base_weapon_list  = globals.WEAPON_TYPES.keys() 
@onready var player : Player = get_node("/root/IngameScene/Map/Player/Player")


var selected_weapons
func _ready() -> void:
	base_weapon_list.pop_back()
	resume_button.pressed.connect(_resume)
	exit_button.pressed.connect(_exit)
	bubbledex_button.pressed.connect(_bubbledex)
	exit_bubbledex_button.pressed.connect(_exit_bubbledex)
	select_weapon_set()

func select_weapon_set() -> void:
	var weapon_list = base_weapon_list.duplicate()
	weapon_list.shuffle()
	selected_weapons = weapon_list.slice(0, 3)
	print(selected_weapons)
	# Update button labels
	for i in range(0, 3):
		weapon_buttons[i].get_node("Label").text = selected_weapons[i]
	
	
func grab_button_focus() -> void:
	resume_button.grab_focus()
	
func _resume() -> void:
	get_tree().paused = false
	visible = false
	
	
func _exit() -> void:
	game_exited.emit()
	get_tree().quit()

func _bubbledex() -> void: 
	pause_menu_container.visible = false
	bubbledex.visible = true
	
func _exit_bubbledex() -> void: 
	bubbledex.visible = false
	pause_menu_container.visible = true



func _unhandled_input(event):
	if event.is_action_pressed("pause") and visible:
		get_viewport().set_input_as_handled()
		_resume()


func on_weapon_picked(button : int) -> void:
	var chosen = selected_weapons[button]
	print("button ", button, " chosen ", chosen)
	player.choose_weapon(globals.WEAPON_TYPES[chosen])
