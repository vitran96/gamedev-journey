tool
extends EditorScript

const player_scene := preload("res://player.tscn")
const boundary_scene := preload("res://boundary.tscn")

func _run() -> void:
	if not Engine.editor_hint:
		print("This script only run once to init resource")
		return

	var scene := get_scene()

	if scene.name != "GameScreen":
		print("This script only work with Main game screen")
		return

	var game_height: int = ProjectSettings.get_setting("display/window/size/height")
	var game_width: int = ProjectSettings.get_setting("display/window/size/width")

	var children := scene.get_children()

	var top_boundary: Node
	var bottom_boundary: Node

	var left_player: Node
	var right_player: Node

	# Check if node is created
	for child in children:
		if child is Player:
			if child.name == "LeftPlayer":
				left_player = child
			elif child.name == "RightPlayer":
				right_player = child
		elif child is Boundary:
			if child.name == "TopBoundary":
				top_boundary = child
			elif child.name == "BottomBoundary":
				bottom_boundary = child

	# Score board

	# Separator

	# Add boundary
	if not top_boundary:
		top_boundary = _create_boundary(scene, 0, "TopBoundary")

	if not bottom_boundary:
		bottom_boundary = _create_boundary(scene, game_height - 10, "BottomBoundary")

	# Add player
	var player_y = game_height / 2 - 130 / 2
	if not left_player:
		left_player = _create_player(scene, "LeftPlayer")

	left_player.position = Vector2(10, player_y)

	if not right_player:
		right_player = _create_player(scene, "RightPlayer")

	right_player.position = Vector2(game_width - 10 - 15, player_y)

	# Ball

	print("DONE")

func _create_boundary(root: Node, y: int, name: String) -> Node:
	var boundary := boundary_scene.instance()

	root.add_child(boundary)
	boundary.name = name
	boundary.position = Vector2(0, y)
	boundary.owner = root

	return boundary

func _create_player(root: Node, name: String) -> Node:
	var player: Node = player_scene.instance()
	player.name = name
	root.add_child(player)
	player.owner = root

	return player
