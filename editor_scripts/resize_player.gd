tool
extends EditorScript

const player_scene := preload("res://player.tscn")

func _run():
	if not Engine.editor_hint:
		print("This script only run once to init resource")
		return

	var scene := get_scene()

	if scene.name != "Player":
		print("This script only work with Player screen")
		return

	print(ProjectSettings.get_setting("display/window/size/window_height_override"))
	print(ProjectSettings.get_setting("display/window/size/window_width_override"))




