tool
extends EditorScript

const player_scene := preload("res://player.tscn")
const boundary_scene := preload("res://boundary.tscn")
const ball_scene := preload("res://ball.tscn")

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

	var left_goal: Node
	var right_goal: Node

	var top_boundary: Node
	var bottom_boundary: Node

	var left_player: Node
	var right_player: Node

	var ball: Node

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
		elif child is Ball:
			ball = child
		elif child is Goal:
			if child.name == "LeftGoal":
				left_goal = child
			elif child.name == "RightGoal":
				right_goal = child

	# Goal

	# Score board

	# Separator

	# Boundary
	if not top_boundary:
		top_boundary = _create_boundary(scene, 0, "TopBoundary")

	if not bottom_boundary:
		bottom_boundary = _create_boundary(scene, game_height - 10, "BottomBoundary")

	# Add player
	var player_y = game_height / 2 - 130 / 2
	if not left_player:
		left_player = _create_player(scene, Vector2(10, player_y), "LeftPlayer")

#	left_player.position = Vector2(10, player_y)

	if not right_player:
		right_player = _create_player(scene, Vector2(game_width - 10 - 15, player_y), "RightPlayer")

#	right_player.position = Vector2(game_width - 10 - 15, player_y)

	# Ball
	if not ball:
		ball = _create_ball(scene, Vector2(game_width / 2, game_height / 2), "Ball")

	print("DONE")

func _create_boundary(root: Node, y: int, name: String) -> Node:
	var boundary := boundary_scene.instance()

	root.add_child(boundary)
	boundary.name = name
	boundary.position = Vector2(0, y)
	boundary.owner = root

	return boundary

func _create_player(root: Node, position: Vector2, name: String) -> Node:
	var player: Node = player_scene.instance()
	player.name = name
	root.add_child(player)
	player.owner = root

	player.position = position

	return player

func _create_ball(root: Node, position: Vector2, name: String) -> Node:
	var ball: Node = ball_scene.instance()
	ball.name = name
	root.add_child(ball)
	ball.owner = root

	ball.position = position

	return ball
