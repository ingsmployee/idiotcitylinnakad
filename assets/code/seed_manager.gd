extends CanvasGroup
class_name SeedManager

var seed_scene: PackedScene = preload("res://assets/scenes/seed.tscn")

func create_seed(newborn_position: Vector2) -> RigidBody2D:
	var newborn: Seed = seed_scene.instantiate()
	newborn.plants_node = %Plants
	newborn.walls = %Walls
	add_child(newborn)
	newborn.position = newborn_position
	return newborn

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_b"):
		create_seed(get_viewport_rect().size / 2)
