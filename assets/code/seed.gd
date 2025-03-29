extends TumbleObject
class_name Seed

var stats: PlantStats = PlantStats.new()
var plants_node: CanvasGroup
const TIME_ON_GROUND_TO_PLANT: int = 2

func _process(delta: float) -> void:
	if linear_velocity.length() > 5 || is_held:
		time_on_ground = 0
	elif time_on_ground > TIME_ON_GROUND_TO_PLANT:
		grow()
		queue_free()
	else:
		time_on_ground += delta
	
	if is_held && Input.is_action_just_released("primary_mouse"):
		is_held = false

func grow() -> void:
	var newborn: Plant = PlantsBase.get_new_plant(&"generic")
	plants_node.add_child(newborn)
	newborn.add_new_stem()
	newborn.global_position = global_position
