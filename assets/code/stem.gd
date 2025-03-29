extends Node2D
class_name Stem

var ready_to_grow_new: bool = false
var growth_time = 0.5
var growth_tween: Tween
var amount_of_stem_children: int = 0
var random = RandomNumberGenerator.new()
var plant_node: Plant
var current_texture_name: StringName = &"none"
var old_rect_height: int
var palette: StringName = &"generic"
var is_origin: bool = false

func _ready() -> void:
	amount_of_stem_children -= 1
	on_growing_new()

func recalculate_offsets(is_new_size: bool = false) -> void:
	var offset = -($Sprite2D.get_rect().size.y - 5)
	if is_new_size:
		if old_rect_height:
			scale.y = old_rect_height / offset
		old_rect_height = offset
	$Sprite2D.position.y = offset * 0.5 * scale.y
	$NextStemAnchor.position.y = offset
	if is_origin:
		get_parent().position.y -= offset
		is_origin = false

func grow() -> void:
	ready_to_grow_new = false
	if growth_tween && growth_tween.is_running():
		growth_tween.stop()
	growth_tween = get_tree().create_tween()
	growth_tween.bind_node(self)
	recalculate_offsets(true)
	growth_tween.tween_property(self, "scale", Vector2(1,1), growth_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	growth_tween.tween_callback(finished_growing)
	

func _process(delta: float) -> void:
	if !ready_to_grow_new:
		recalculate_offsets()

func on_growing_new(amount_grown:int = 1) -> void:
	# propagate through every stem
	if get_parent() is Marker2D:
		get_parent().get_parent().on_growing_new(amount_grown)
	amount_of_stem_children += amount_grown
	if amount_of_stem_children > 6:
		return
	
	var desired_texture_name
	if amount_of_stem_children < 4:
		match amount_of_stem_children:
			0:
				if get_parent() is Marker2D:
					plant_node.last_stems.erase(get_parent().get_parent())
				desired_texture_name = &"end"
			1:
				desired_texture_name = &"small"
			3:
				desired_texture_name = &"medium"
	elif amount_of_stem_children > 5 && !plant_node.has_large:
		desired_texture_name = &"large"
		plant_node.has_large = true
	if desired_texture_name && desired_texture_name != current_texture_name:
		$Sprite2D.texture = PlantsBase.get_stem_texture(palette, desired_texture_name)
		grow()
	

func create_split_stems(palette: StringName = &"generic") -> Array[Node2D]:
	# biasing it to grow upwards
	var newborn_1 = PlantsBase.get_new_stem(plant_node)
	var newborn_2 = PlantsBase.get_new_stem(plant_node)
	var bias = pow(rotation_degrees / 360, 2) * 180
	var split_angle = clamp(round(random.randfn(bias, 7)), bias - 6, bias + 6)
	if split_angle > 0:
		split_angle = max(3, split_angle)
	else:
		split_angle = min(-3, split_angle)
	
	newborn_1.rotate(deg_to_rad(split_angle))
	newborn_2.rotate(-deg_to_rad(split_angle))
	$NextStemAnchor.add_child(newborn_1)
	$NextStemAnchor.add_child(newborn_2)
	return [newborn_1, newborn_2]
	

func create_stem(palette: StringName = &"generic") -> Node2D: 
	var newborn = PlantsBase.get_new_stem(plant_node)
	var bias = -pow(rotation_degrees / 360, 3) * 180
	newborn.rotate(deg_to_rad(2 * clamp(random.randfn(bias, 7), bias - 10, bias + 10)))
	$NextStemAnchor.add_child(newborn)
	newborn.global_position = $NextStemAnchor.global_position
	return newborn

func finished_growing() -> void: 
	ready_to_grow_new = true
