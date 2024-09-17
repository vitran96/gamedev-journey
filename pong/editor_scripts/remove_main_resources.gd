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

	var children := scene.get_children()

	for child in children:
		scene.remove_child(child)
