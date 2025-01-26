extends Weapon
class_name BeamWeapon

var rayLength = 500
var damage = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_set_transform_matrix(global_transform.affine_inverse())
	draw_line( \
		global_position, \
		global_position + (orientation * rayLength), \
		Color(100,0,0), \
		2
	)

func _physics_process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html#collision-mask
	# Enemies are layer 2, so use those exclusively; also exclude the weapon itself and its parent
	# (which should be the player).
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + (orientation * rayLength), 2, [self, get_parent()])
	var result = space_state.intersect_ray(query)
	if result:
		if result.collider:
			if "isEnemy" in result.collider && result.collider.isEnemy:
				(result.collider as Enemy).take_damage(damage)
