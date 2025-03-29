extends Node2D
class_name Plant

var max_branches: int = 5
var random = RandomNumberGenerator.new()

var chance_to_split: float = 0.5
var split_idle_chance: float = 0.5
var palette: StringName


var last_stems: Array[Node2D]
var total_splits: int = 0
var has_large: bool = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_a"):
		add_new_stem()

func add_new_stem() -> void:
	if last_stems.size() == 0:
		var newborn: Stem = PlantsBase.get_new_stem(self)
		last_stems.append(newborn)
		$Sprites/Holder.add_child(newborn)
		newborn.is_origin = true
		print("Creating a new root stem! " + str(newborn.global_position))
		return
	
	var splits_performed: int = 0
	var newborn_stems: Array[Node2D]
	for stem: Stem in last_stems:
		if !stem.ready_to_grow_new:
			continue
		# if we haven't hit either of the maximum splits and have won the split chance lottery, then split
		# reduce the chance to split every time we do it
		if (random.randf() < ((2*chance_to_split) / (splits_performed + 2))):
			splits_performed += 1
			newborn_stems.append_array(stem.create_split_stems(palette))
			
		else:
			var newborn = stem.create_stem(palette)
			print("Creating a single stem!" + str(newborn.global_position))
			newborn_stems.append(newborn)
			
			
	
	last_stems.append_array(newborn_stems)
	last_stems.shuffle()
	

#func _process(delta):
	#for branch in branch_sprites:
	#	branch.rotation_degrees += sin(Time.get_ticks_msec() * 0.001) * 0.2
