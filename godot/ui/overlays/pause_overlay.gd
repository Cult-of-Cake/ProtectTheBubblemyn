extends CenterContainer

signal game_exited

@onready var resume_button := %ResumeButton
@onready var exit_button := %ExitButton
@onready var menu_container := %MenuContainer

func _ready() -> void:
	resume_button.pressed.connect(_resume)
	exit_button.pressed.connect(_exit)
	
func grab_button_focus() -> void:
	resume_button.grab_focus()
	
func _resume() -> void:
	get_tree().paused = false
	visible = false
	
	
func _exit() -> void:
	game_exited.emit()
	get_tree().quit()
	
func _unhandled_input(event):
	if event.is_action_pressed("pause") and visible:
		get_viewport().set_input_as_handled()
		_resume()
