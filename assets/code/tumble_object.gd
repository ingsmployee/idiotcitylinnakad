extends RigidBody2D
class_name TumbleObject
## Put this script on anything that can be generically picked up and thrown around.

var is_held: bool = false
var time_on_ground: float = 0
var hold_offset: Vector2
## WARNING don't use this, doesn't work atm
@onready var moment_of_inertia = 1.0 / PhysicsServer2D.body_get_direct_state(get_rid()).inverse_inertia

func _physics_process(delta: float) -> void:
	if is_held:
		if Input.is_action_just_pressed("rotate_left"):
			apply_torque_impulse(-4500 * mass) # i know this doesn't physics but shhh shut up... wait... it'll all be circles anyway...
			# NO DON'T IMPLEMENT MOMENT OF INERTIA CALCULATIONS IT WONT BE THAT HARD BUT THE DEMONS WILL WIN
			# oh wait there's a property for it
			# silly me
		elif Input.is_action_just_pressed("rotate_right"):
			apply_torque_impulse(4500 * mass)
			
		var desired_position = get_global_mouse_position() - hold_offset
		var desired_motion = (desired_position - global_position)
		#desired_motion = desired_motion.rotated(-rotation)
		apply_force(desired_motion * 10) #hold_offset.rotated(rotation)
		linear_damp = 10
		angular_damp = 10
		
		gravity_scale = 0.5
	else:
		linear_damp = 0.5
		angular_damp = 0
		gravity_scale = 1
	
	


func _process(delta: float) -> void:
	if is_held && Input.is_action_just_released("primary_mouse"):
		is_held = false
	


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == 1 && event.is_pressed():
		is_held = true
		## NOTE
		# event.position is for the viewport, and has nothing to do with the actual like physical space
		hold_offset = to_local(get_global_mouse_position())
		
		
		
	
