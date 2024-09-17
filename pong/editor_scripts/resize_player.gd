tool
extends EditorScript

const player_scene := preload("res://player.tscn")

const WIDTH = 15
const HEIGHT = 120

const BOUNDARY_HEIGHT = 10

func _run():
	if not Engine.editor_hint:
		print("This script only run once to init resource")
		return

	var scene := get_scene()
#	var scene2 = get_editor_interface().get_edited_scene_root()

	if scene.name != "Player":
		print("This script only work with Player screen")
		return

#	var height: int = ProjectSettings.get_setting("display/window/size/height")
#	var width: int = ProjectSettings.get_setting("display/window/size/width")

	var color_rect = scene.get_node("ColorRect") as ColorRect
	color_rect.rect_size.x = WIDTH
	color_rect.rect_size.y = HEIGHT

	print("DONE")
