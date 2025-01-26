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

func _ready() -> void:
	resume_button.pressed.connect(_resume)
	exit_button.pressed.connect(_exit)
	bubbledex_button.pressed.connect(_bubbledex)
	exit_bubbledex_button.pressed.connect(_exit_bubbledex)
	
	
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
