tool
extends Node2D

func _ready() -> void:
	Physics2DServer.area_set_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,0))
	Physics2DServer.area_set_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY, 0)

	var window_size := get_window_size()
	OS.min_window_size = window_size
	OS.max_window_size = window_size

func get_window_size() -> Vector2:
	if Engine.editor_hint:
		return Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	else:
		return get_viewport().size
