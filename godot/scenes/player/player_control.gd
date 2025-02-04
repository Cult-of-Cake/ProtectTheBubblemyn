extends CharacterBody2D
class_name Player

@onready var pause_overlay = get_node("/root/IngameScene/UI/PauseOverlay")

var isPlayer = true

const SPEED = 150.0
const HIGHSPEED = 450.0
const ACCEL = 20.0
const JUMP_VELOCITY = -400.0

var maxHP = 100
var hp

#player state
var speedup = false
var speedupTimer
var soapTimer
var invincible = false
var isSoap = false

#weapons
const weapon_slot_rotations: Array[float] = [ \
	0.0, \
	PI/3, \
	2*PI/3, \
	PI, \
	4*PI/3, \
	5*PI/3 \
]
const weapon_slot_positions: Array[Vector2] = [ \
	Vector2(50.0, 0.0), \
	Vector2(25.0, 43.301270189221932338186158537647), \
	Vector2(-25.0, 43.301270189221932338186158537647), \
	Vector2(-50.0, 0.0), \
	Vector2(-25.0, -43.301270189221932338186158537647), \
	Vector2(25.0, -43.301270189221932338186158537647), \
]
const weapon_slot_orientations: Array[Vector2] = [ \
	Vector2(1.0, 0.0), \
	Vector2(0.5, 0.86602540378443864676372317075294), \
	Vector2(-0.5, 0.86602540378443864676372317075294), \
	Vector2(-1.0, 0.0), \
	Vector2(-0.5, -0.86602540378443864676372317075294), \
	Vector2(0.5, -0.86602540378443864676372317075294), \
]

const basic_bubble_shooter_template = preload("res://scenes/game/weapons/basic_bubble_shooter.tscn")
const bubble_shooter_template = preload("res://scenes/game/weapons/bubble_shooter.tscn")
const bath_bomb_launcher_template = preload("res://scenes/game/weapons/bath_bomb_launcher.tscn")
const scatter_shot_template = preload("res://scenes/game/weapons/scatter_shot.tscn")
const beam_weapon_template = preload("res://scenes/game/weapons/beam_weapon.tscn")

# This has to match the order of our weapons enum:
var weapon_templates = [bubble_shooter_template,
	bath_bomb_launcher_template, scatter_shot_template, beam_weapon_template]

var basicStarterWeapon: Weapon
var weapons: Array[Weapon] = [null, null, null, null, null, null]

#variables for referencing nodes
var HPBar

func _ready():
	HPBar = get_node("HPBar")
	hp = maxHP
	HPBar.max_value = maxHP
	HPBar.value = hp
	
	# instantiate single basic weapon
	basicStarterWeapon = basic_bubble_shooter_template.instantiate()
	add_child(basicStarterWeapon)
	# Basic weapon shoots from the centre of the player creature
	basicStarterWeapon.position = Vector2(0.0, 0.0)
	

func _physics_process(delta: float) -> void:
	
	 # 8 Direction movement inputs
	var direction := Input.get_vector("move_left", "move_right","move_up", "move_down")
	
	# This will have the player deaccelerate
	if !speedup:
		velocity = lerp(velocity, direction * SPEED, ACCEL * delta)
	else:
		velocity = lerp(velocity, direction * HIGHSPEED, ACCEL * delta)
	# This moves the character
	
	clearSprites()
	
	if abs(velocity.x) > abs (velocity.y):
		if velocity.x > 0: 
			get_node("Right").visible = true
		elif velocity.x < 0:
			get_node("Left").visible = true
	elif abs(velocity.y) > abs (velocity.x):
		if velocity.y > 0:
			get_node("Facing").visible = true
		elif velocity.y < 0:
			get_node("Away").visible = true
	else:
		get_node("Facing").visible = true
	
	
	
	move_and_slide()

func clearSprites():
	get_node("Facing").visible = false
	get_node("Left").visible = false
	get_node("Right").visible = false
	get_node("Away").visible = false

func addWeaponToSlot(slotIndex: int, weaponTemplate: Resource) -> void:
	assert(slotIndex >= 0 && slotIndex < 6)
	var newWeapon = weaponTemplate.instantiate()
	add_child(newWeapon)
	newWeapon.rotation = weapon_slot_rotations[slotIndex]
	newWeapon.position = weapon_slot_positions[slotIndex]
	newWeapon.orientation = weapon_slot_orientations[slotIndex]
	weapons[slotIndex] = newWeapon

func firstFreeWeaponsSlot() -> int:
	for n in range(6):
		if weapons[n] == null:
			return n
	return -1

#region Power-Ups

func on_powerup_collide(item : PowerUp.Types):
	AudioController.play_bubbleup()
	match item:
		PowerUp.Types.SPEEDUP:
			activateSpeedup()
		PowerUp.Types.INVINCIBLE:
			activateSoap()
		PowerUp.Types.HEAL:
			hp = clamp(hp + maxHP * 0.1, 0, maxHP)
			HPBar.value = hp

func activateSpeedup():
	speedup = true
	var timeLeft
	if is_instance_valid(speedupTimer):
		timeLeft = speedupTimer.time_left
	else:
		timeLeft = 0
	if(timeLeft > 0.1):
		speedupTimer.time_left = 10
	else:
		speedupTimer = get_tree().create_timer(10)
	await speedupTimer.timeout
	speedup = false

func activateSoap():
	isSoap = true
	get_node("Soapsprite").visible = true
	var timeLeft
	if is_instance_valid(soapTimer):
		timeLeft = soapTimer.time_left
	else:
		timeLeft = 0
	if(timeLeft > 0.1):
		soapTimer.time_left = 10
	else:
		soapTimer = get_tree().create_timer(10, false)
	await soapTimer.timeout
	isSoap = false
	get_node("Soapsprite").visible = false
#endregion

func take_damage(damage):
	AudioController.play_mudhit()
	if !isSoap:
		hp = clamp(hp - damage, 0, maxHP)
		print("hp is ", hp)
	HPBar.value = hp
	
#region Levelling
var milestones = [5, 10, 20, 40, 60, 80]
var hit = [false, false, false, false, false]

var current_xp : int = 0
func on_enemy_killed(enemy : Enemy) -> void:
	current_xp += enemy.xp_worth
	for i in range(0, 5):
		if !hit[i] and current_xp >= milestones[i]:
			hit[i] = true
			offer_weapon_screen()

func offer_weapon_screen() -> void:
	# Pause
	get_viewport().set_input_as_handled()
	get_tree().paused = true
	pause_overlay.grab_button_focus()
	pause_overlay.select_weapon_set()
	# Show weapon chooser
	pause_overlay.show()
	pause_overlay.get_node("CenterContainer").hide()
	pause_overlay.get_node("WeaponChooser").show()

func choose_weapon(weapon : Weapon.Types) -> void:
	pause_overlay.get_node("WeaponChooser").hide()
	pause_overlay.get_node("CenterContainer").show()
	# Unpause
	get_viewport().set_input_as_handled()
	get_tree().paused = false
	pause_overlay.hide()
	# Add weapon
	print(weapon_templates[weapon])
	addWeaponToSlot(firstFreeWeaponsSlot(), weapon_templates[weapon])

#endregion


func collisionWithEnemy(body: Node2D) -> void:
	if isSoap:
		body.take_damage(100)
	else:
		var toBody = body.position - position
		body.position = body.position + toBody
		take_damage(body.strength)
