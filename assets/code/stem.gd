extends Node2D

var vert_offset: int
var ready_to_grow_new: bool = false
var growth_time = 0.5
var growth_tween: Tween

func _ready() -> void:
	vert_offset = $Sprite2D.get_rect().size.y - 3
	$Sprite2D.position.y -= vert_offset * 0.5
	$NextStemAnchor.position.y -= vert_offset
	$Sprite2D.scale.y = 0
	growth_tween = get_tree().create_tween()
	growth_tween.bind_node(self)
	growth_tween.tween_property($Sprite2D, "scale", Vector2(1,1), growth_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	growth_tween.tween_callback(finished_growing)
	$Sprite2D.position.y = (($Sprite2D.scale.y * $Sprite2D.get_rect().size.y) - 3) * -0.5

func _process(delta: float) -> void:
	if !ready_to_grow_new:
		$Sprite2D.position.y = (($Sprite2D.scale.y * $Sprite2D.get_rect().size.y) - 3) * -0.5
		

func finished_growing() -> void: 
	ready_to_grow_new = true
