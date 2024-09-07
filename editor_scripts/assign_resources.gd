tool
extends EditorScript

const player_scene := preload("res://player.tscn")

func _run():
	if not Engine.editor_hint:
		print("This script only run once to init resource")
		return

	var scene := get_scene()

	if scene.name != "GameScreen":
		print("This script only work with Main game screen")
		return

	var children := scene.get_children()

	# Delete player node
	for child in children:
		if child is Player:
			scene.remove_child(child)
			child.queue_free()

	# Add new player node
	var player1: Node2D = player_scene.instance()
	player1.name = "Player1"
	scene.add_child(player1)
	player1.owner = scene
	player1.position = Vector2(0, 0)


	var player2 := player_scene.instance()
	player2.name = "Player2"
	scene.add_child(player2)
	player2.owner = scene
	player2.position = Vector2(100, 0)

	print("Players added to GameScreen.")




