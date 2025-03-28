extends Resource
class_name PlantsBase

var stem_scene: PackedScene = preload("res://assets/scenes/stem.tscn")

var branch_possibilities: Array[Texture2D] = [
	preload("res://assets/textures/PROC_generic_stem_a.png")
]

## Chance for each stem to split
@export var chance_to_split: float = 0.2
## Max amount of new splits every time it grows.
@export var max_splits_per_growth = 1
## Max amount of splits in general.
@export var max_total_splits = 3
## Chance that a split branch will decide to not grow. One branch is guaranteed to grow. NOT IMPLEMENTED
@export var split_idle_chance = 0.5

func get_new_stem() -> Node2D:
	var newborn = stem_scene.instantiate()
	newborn.get_node("Sprite2D").texture = branch_possibilities.pick_random()
	return newborn
	
