extends Resource
class_name PlantsBase

static var stem_scene: PackedScene = preload("res://assets/scenes/stem.tscn")

static var stem_textures: Dictionary[StringName, Dictionary] = {
	"generic": {
		"end": preload("res://assets/textures/generic_stem_end.png"),
		"small": preload("res://assets/textures/generic_stem_small.png"),
		"medium": preload("res://assets/textures/generic_stem_medium.png"),
		"large": preload("res://assets/textures/generic_stem_large.png"),
		"leaf": [
			preload("res://assets/textures/PROC_generic_leaf_a.png"),
			preload("res://assets/textures/PROC_generic_leaf_b.png"),
			preload("res://assets/textures/PROC_generic_leaf_c.png")
			]
	}
	
}


#var stems: Dictionary[String, Texture2D]


## Chance for each stem to split
@export var chance_to_split: float = 0.2
## Max amount of new splits every time it grows.
@export var max_splits_per_growth = 1
## Max amount of splits in general.
@export var max_total_splits = 3
## Chance that a split branch will decide to not grow. One branch is guaranteed to grow. NOT IMPLEMENTED
@export var split_idle_chance = 0.5

static func get_new_stem(plant_node: Node2D) -> Node2D:
	var newborn = stem_scene.instantiate()
	newborn.plant_node = plant_node
	return newborn

static func get_stem_texture(palette:StringName, id:StringName) -> CompressedTexture2D:
	var entry = stem_textures[palette][id]
	if entry is Array:
		return entry.pick_random()
	return entry
