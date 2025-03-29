extends TumbleObject
class_name Seed

var stats: PlantStats = PlantStats.new()
var plants_node: CanvasGroup
var walls: StaticBody2D
var is_on_ground: bool = false
const TIME_ON_GROUND_TO_PLANT: int = 2

func _process(delta: float) -> void:
	if linear_velocity.length() > 5 || is_held || !is_on_ground:
		time_on_ground = 0
	elif time_on_ground > TIME_ON_GROUND_TO_PLANT:
		grow()
		queue_free()
	else:
		time_on_ground += delta
	
	if is_held && Input.is_action_just_released("primary_mouse"):
		is_held = false

func _physics_process(delta: float) -> void:
	## NOTE new keyword learned!
	super(delta)
	is_on_ground = false
	for body in get_colliding_bodies():
		if body == walls:
			is_on_ground = true

func grow() -> void:
	var newborn: Plant = PlantsBase.get_new_plant(&"generic")
	plants_node.add_child(newborn)
	newborn.add_new_stem()
	newborn.global_position = global_position
