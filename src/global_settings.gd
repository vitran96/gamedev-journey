tool
extends Node2D

func _ready() -> void:
	Physics2DServer.area_set_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(0,0))
	Physics2DServer.area_set_param(get_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY, 0)

	var window_size := Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	OS.min_window_size = window_size
	OS.max_window_size = window_size
