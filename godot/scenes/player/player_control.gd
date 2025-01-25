extends CharacterBody2D


const SPEED = 300.0
const ACCEL = 20.0
const JUMP_VELOCITY = -400.0

var maxHP = 100
var hp

#variables for referencing nodes
var HPBar

func _ready():
	HPBar = get_node("HPBar")
	hp = maxHP
	HPBar.max_value = maxHP
	HPBar.value = hp

func _physics_process(delta: float) -> void:
	
	 # 8 Direction movement inputs
	var direction := Input.get_vector("move_left", "move_right","move_up", "move_down")
	
	# This will have the player deaccelerate
	velocity = lerp(velocity, direction * SPEED, ACCEL * delta) 
	
	# This moves the character
	move_and_slide()
	
	_attack()

func _attack():
	
	# Recieves input to attack
	if Input.is_action_just_pressed("attack"):
		
		# Add what the attack does here
		print("attack occured")
