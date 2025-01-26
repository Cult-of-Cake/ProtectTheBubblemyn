extends CharacterBody2D
class_name Player

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
var weapons: Array[Weapon] = [null, null, null, null, null, null]

#variables for referencing nodes
var HPBar

func _ready():
	HPBar = get_node("HPBar")
	hp = maxHP
	HPBar.max_value = maxHP
	HPBar.value = hp
	
	# instantiate single basic weapon in first slot
	addWeaponToSlot(0, basic_bubble_shooter_template)
	
	#this should ultimately all get triggered from somewhere else
	#await get_tree().create_timer(5).timeout
	#activateSpeedup()

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
	if !isSoap:
		hp = clamp(hp - damage, 0, maxHP)
	HPBar.value = hp
	
#region Levelling
var current_xp : int = 0
func on_enemy_killed(enemy : Enemy) -> void:
	current_xp += enemy.xp_worth
	

#endregion


func collisionWithEnemy(body: Node2D) -> void:
	if isSoap:
		body.take_damage(body.strength)
	else:
		var toBody = body.position - position
		body.position = body.position + toBody
		take_damage(5)
