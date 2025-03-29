extends Node2D

var max_branches: int = 5
var random = RandomNumberGenerator.new()

var chance_to_split: float = 0.2
var max_splits_per_growth: int = 1
var max_total_splits: int = 3
var split_idle_chance: float = 0.5



var last_stems: Array[Node2D]
var total_splits: int = 0



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action_a"):
		add_new_stem()

func add_new_stem() -> void:
	var splits_performed: int = 0
	var newborn_stems: Array[Node2D]
	var newborn_split_stems: Array[Node2D]
	var stems_grown_from: Array[Node2D]
	
	if last_stems:
		for stem in last_stems:
			if !stem.ready_to_grow_new:
				continue
			var newborn = PlantsBase.get_new_stem()
			# if we haven't hit either of the maximum splits and have won the split chance lottery, then split
			if splits_performed < max_splits_per_growth && total_splits < max_total_splits && (random.randf() < chance_to_split):
				splits_performed += 1
				total_splits += 1
				# biasing it to grow upwards
				var bias = pow(rotation_degrees / 360, 2) * 180
				var split_angle = clamp(round(random.randfn(bias, 5)), bias - 6, bias + 6)
				if split_angle > 0:
					split_angle = max(3, split_angle)
				else:
					split_angle = min(-3, split_angle)
				
				var other_newborn = PlantsBase.get_new_stem()
				newborn.rotate(deg_to_rad(split_angle))
				other_newborn.rotate(-deg_to_rad(split_angle))
				stem.get_node("NextStemAnchor").add_child(other_newborn)
				newborn_stems.append(other_newborn)
				
				stem.get_node("NextStemAnchor").add_child(newborn)
				newborn_split_stems.append(newborn)
				stems_grown_from.append(stem)
			else:
				stem.get_node("NextStemAnchor").add_child(newborn)
				newborn_stems.append(newborn)
				stems_grown_from.append(stem)
		for stem in newborn_stems:
			stem.rotate(random.randfn(0, 0.2))
		
	else:
		var newborn = PlantsBase.get_new_stem()
		$Sprites/Holder.add_child(newborn)
		newborn_stems.append(newborn)
	
	for stem in stems_grown_from:
		last_stems.erase(stem)
	
	last_stems.append_array(newborn_stems)
	
	

#func _process(delta):
	#for branch in branch_sprites:
	#	branch.rotation_degrees += sin(Time.get_ticks_msec() * 0.001) * 0.2
