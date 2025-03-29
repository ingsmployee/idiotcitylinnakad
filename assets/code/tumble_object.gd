extends RigidBody2D

var is_held: bool = false

func _physics_process(delta: float) -> void:
	if is_held:
		var desired_motion = (get_global_mouse_position() - global_position)
		apply_central_force(desired_motion * 10)
		linear_damp = 10
		
		gravity_scale = 0.2
	else:
		linear_damp = 0.5
		gravity_scale = 1


func _process(delta: float) -> void:
	
	if is_held && Input.is_action_just_released("primary_mouse"):
		is_held = false


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			is_held = true
		elif event.button_index == 0:
			is_held = false
	
