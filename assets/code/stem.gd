extends Node2D

var vert_offset: int
var ready_to_grow_new: bool = false
var growth_time = 0.5
var growth_tween: Tween
var amount_of_stem_children: int = 0

func _ready() -> void:
	amount_of_stem_children -= 1
	on_growing_new()
	$Sprite2D.scale.y = 0
	grow()

func grow() -> void:
	ready_to_grow_new = false
	if growth_tween && growth_tween.is_running():
		growth_tween.kill()
	growth_tween = get_tree().create_tween()
	growth_tween.bind_node(self)
	growth_tween.tween_property($Sprite2D, "scale", Vector2(1,1), growth_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	growth_tween.tween_callback(finished_growing)
	$Sprite2D.position.y = (($Sprite2D.scale.y * $Sprite2D.get_rect().size.y) - 3) * -0.5

func _process(delta: float) -> void:
	if !ready_to_grow_new:
		$Sprite2D.position.y = (($Sprite2D.scale.y * $Sprite2D.get_rect().size.y) - 3) * -0.5
		$NextStemAnchor.position.y -= (($Sprite2D.scale.y * $Sprite2D.get_rect().size.y) - 3)

func on_growing_new() -> void:
	# propagate through every stem
	if get_parent() is Marker2D:
		get_parent().get_parent().on_growing_new()
	amount_of_stem_children += 1
	match amount_of_stem_children:
		0:
			$Sprite2D.texture = PlantsBase.get_stem_texture("generic", "end")
		1:
			$Sprite2D.texture = PlantsBase.get_stem_texture("generic", "small")
		2:
			$Sprite2D.texture = PlantsBase.get_stem_texture("generic", "medium")
		var amount:
			if amount < 5:
				$Sprite2D.texture = PlantsBase.get_stem_texture("generic", "large")
	print($Sprite2D.get_rect().size.y)
	grow()

func finished_growing() -> void: 
	ready_to_grow_new = true
