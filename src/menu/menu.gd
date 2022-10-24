tool
extends CanvasLayer

signal restart_game

onready var overlay_node = $Overlay
onready var message_node = $MessageContainer

func set_visibility(is_visible: bool) -> void:
	overlay_node.visible = is_visible
	message_node.visible = is_visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		get_tree().paused = !get_tree().paused
		overlay_node.visible = get_tree().paused
		message_node.visible = get_tree().paused
	elif event.is_action_pressed("game_quit") && get_tree().paused:
		get_tree().quit(0)
	elif event.is_action_pressed("game_restart") && get_tree().paused:
		emit_signal("restart_game")
