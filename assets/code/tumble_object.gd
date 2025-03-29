extends RigidBody2D
class_name TumbleObject
## Put this script on anything that can be generically picked up and thrown around.

var is_held: bool = false
var time_on_ground: float = 0

func _physics_process(delta: float) -> void:
	if is_held:
		if Input.is_action_just_pressed("rotate_left"):
			apply_torque_impulse(-4500 * mass) # i know this doesn't physics but shhh shut up... wait... it'll all be circles anyway...
			# NO DON'T IMPLEMENT MOMENT OF INERTIA CALCULATIONS IT WONT BE THAT HARD BUT THE DEMONS WILL WIN
		elif Input.is_action_just_pressed("rotate_right"):
			apply_torque_impulse(4500 * mass)
			
		var desired_motion = (get_global_mouse_position() - global_position)
		apply_central_force(desired_motion * 10)
		linear_damp = 10
		angular_damp = 10
		
		gravity_scale = 0.2
	else:
		linear_damp = 0.5
		angular_damp = 0
		gravity_scale = 1


func _process(delta: float) -> void:
	if is_held && Input.is_action_just_released("primary_mouse"):
		is_held = false
	


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1:
		is_held = true
		
	
