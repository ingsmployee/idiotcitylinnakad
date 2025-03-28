extends Node2D

var max_branches = 5 
var branch_sprites = [] 

var branch_possibilities = [
	"res://assets/plant/PROC_generic_stem_a.png"
]

func _ready():
	grow_branch(Vector2(0, -50), 1)

func grow_branch(start_position, depth):
	if depth > max_branches:
		return 
	var branch = Sprite2D.new()
	var type = branch_possibilities[randi_range(0,branch_possibilities.size()-1)]
	branch.texture = load(type)
	branch.offset = Vector2(0, -branch.texture.get_size().y)
	var size = Image.load_from_file(type).get_size()[1]
	
	branch.position = start_position
	branch.rotation_degrees = 30.0 * depth # just constant rn so I can DEBUG THIS SHIT!
	add_child(branch)
	branch_sprites.append(branch)

	await get_tree().create_timer(0.5).timeout
	var new_position = branch.position + Vector2(0, -size).rotated(branch.rotation)
	grow_branch(new_position, depth + 1)
