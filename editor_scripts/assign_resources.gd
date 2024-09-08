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

	var boundary1: Node
	var boundary2: Node

	var player1: Node
	var player2: Node

	# Delete player node
	for child in children:
		if child is Player:
#			scene.remove_child(child)
#			child.queue_free()
			if child.name == "Player1":
				player1 = child
			elif child.name == "Player2":
				player2 = child
		elif child is Boundary:
			if child.name == "TopBoundary":
				boundary1 = child
			elif child.name == "BottomBoundary":
				boundary2 = child

	# Add boundary
	if not boundary1:
		boundary1 = _create_boundary(scene, 0, "TopBoundary")

	if not boundary2:
		boundary2 = _create_boundary(scene, game_height - 10, "BottomBoundary")

	# Add player
	var player_y = game_height / 2 - 130 / 2
	if not player1:
		player1 = _create_player(scene, "Player1")

	player1.position = Vector2(10, player_y)

	if not player2:
		player2 = _create_player(scene, "Player2")

	player2.position = Vector2(game_width - 10 - 15, player_y)



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
