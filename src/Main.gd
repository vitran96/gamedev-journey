extends Node

const PLAYER := preload("res://player/Player.tscn")
const BALL := preload("res://ball/Ball.tscn")

const PLAYER_POSITION_OFFSET := 30

func _ready() -> void:
	var window_size = get_viewport().size

	var player_1 := PLAYER.instance()
	player_1.position = Vector2(PLAYER_POSITION_OFFSET, window_size.y / 2)
	player_1.player_type = 1

	add_child(player_1)

	var player_2 := PLAYER.instance()
	player_2.position = Vector2(window_size.x - PLAYER_POSITION_OFFSET, window_size.y / 2)
	player_2.player_type = 2

	add_child(player_2)

	var ball := BALL.instance()
	ball.position = window_size / 2
	# TODO: implement random shot
	ball.move_vector = Vector2(200, 200)

	add_child(ball)
