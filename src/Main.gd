extends Node

const PLAYER := preload("res://player/Player.tscn")
const BALL := preload("res://ball/Ball.tscn")

func _ready() -> void:
	var window_size = get_viewport().size

	var player_1 := create_player(Vector2(GlobalVars.PLAYER_POSITION_OFFSET, window_size.y / 2), 1)
	add_child(player_1)

	var player_2 := create_player(Vector2(window_size.x - GlobalVars.PLAYER_POSITION_OFFSET, window_size.y / 2), 2)
	add_child(player_2)

	var ball := BALL.instance()
	ball.position = window_size / 2
	# TODO: implement random shot
	ball.move_vector = Vector2(300, 300)

	add_child(ball)

func create_player(position:Vector2, player_type: int) -> Node:
	var player := PLAYER.instance()
	player.position = position
	player.player_type = player_type
	return player
