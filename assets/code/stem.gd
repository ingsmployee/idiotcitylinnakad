extends Node2D

var max_branches = 5 
var branch_sprites = [] 

var branch_possibilities = [
	"res://assets/textures/PROC_generic_stem_a.png"
]
func animate():
	var tween = get_tree().create_tween()
	tween.tween_property($FirstBranch, "rotation_degrees", 20, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($FirstBranch, "rotation_degrees", -20, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()  # Makes the animation loop forever
	
func _ready():
	grow_branch(self, Vector2(0, 0), 1)
	animate()

func grow_branch(parent ,start_position, depth):
	if depth > max_branches:
		return 
	var branch = Sprite2D.new()
	var type = branch_possibilities[randi_range(0,branch_possibilities.size()-1)]
	branch.texture = load(type)
	branch.offset = Vector2(0, -branch.texture.get_size().y/2)
	
	branch.position = start_position
	branch.rotation_degrees = randf_range(-30,30)
	add_child(branch)
	branch_sprites.append(branch)

	await get_tree().create_timer(0.5).timeout
	var new_position = branch.position + Vector2(0, -branch.texture.get_size().y*0.95).rotated(branch.rotation)
	grow_branch(branch, new_position, depth + 1)

#func _process(delta):
	#for branch in branch_sprites:
	#	branch.rotation_degrees += sin(Time.get_ticks_msec() * 0.001) * 0.2
