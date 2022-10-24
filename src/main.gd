tool
extends Node

const PLAYER := preload("res://player/player.tscn")
const DEATH_ZONE := preload("res://death_zone/death_zone.tscn")
const BALL := preload("res://ball/ball.tscn")

var rng = RandomNumberGenerator.new()

onready var hud_node := $HUD

var player_1_node: Node = null
var player_2_node: Node = null

var ball_node: Node = null

func _ready() -> void:
	hud_node.set_score_text(PlayerTypes.PLAYER_1, GlobalVars.player_1_score)
	hud_node.set_score_text(PlayerTypes.PLAYER_2, GlobalVars.player_2_score)

	var window_size := GlobalSettings.get_window_size()
	var middle_y := window_size.y / 2

	player_1_node= create_player(Vector2(GlobalVars.PLAYER_POSITION_OFFSET, middle_y), PlayerTypes.PLAYER_1)
	player_1_node.name = "Player1"
	add_child(player_1_node)

	var death_zone_1 := create_death_zone(Vector2(0 - GlobalVars.DEATH_ZONE_OFFSET, middle_y), PlayerTypes.PLAYER_1)
	add_child(death_zone_1)

	player_2_node= create_player(Vector2(window_size.x - GlobalVars.PLAYER_POSITION_OFFSET, middle_y), PlayerTypes.PLAYER_2)
	player_2_node.name = "Player2"
	add_child(player_2_node)

	var death_zone_2 := create_death_zone(Vector2(window_size.x + GlobalVars.DEATH_ZONE_OFFSET, middle_y), PlayerTypes.PLAYER_2)
	add_child(death_zone_2)

	ball_node = create_ball(window_size / 2)
	add_child(ball_node)

func create_player(position: Vector2, player_type: int) -> Node:
	var player := PLAYER.instance()
	player.position = position
	player.player_type = player_type
	return player

func create_death_zone(position: Vector2, player_type: int) -> Node:
	var death_zone := DEATH_ZONE.instance()
	death_zone.position = position
	death_zone.player_type = player_type
	death_zone.connect("hit_death_zone", self, "_on_hit_death_zone")
	return death_zone

func create_ball(position: Vector2) -> Node:
	var ball := BALL.instance()
	ball.position = position
#	TODO: need different random direction
#	The current will produce a bad angle to play, it should be a cone shape direct to 1 of the player
	rng.randomize()
	ball.direction = rng.randf_range(PI, 2*PI)
	return ball

func reset_player_position() -> void:
	var window_size := GlobalSettings.get_window_size()
	var middle_y := window_size.y / 2
	player_1_node.position = Vector2(GlobalVars.PLAYER_POSITION_OFFSET, middle_y)
	player_2_node.position = Vector2(window_size.x - GlobalVars.PLAYER_POSITION_OFFSET, middle_y)

func reset_ball() -> void:
	remove_child(ball_node)
	ball_node.queue_free()
	var window_size := GlobalSettings.get_window_size()
	ball_node = create_ball(window_size / 2)
	add_child(ball_node)

func _on_hit_death_zone(player_type: int) -> void:
	match player_type:
		PlayerTypes.PLAYER_1:
			GlobalVars.player_2_score += 1
			hud_node.set_score_text(PlayerTypes.PLAYER_2, GlobalVars.player_2_score)
		PlayerTypes.PLAYER_2:
			GlobalVars.player_1_score += 1
			hud_node.set_score_text(PlayerTypes.PLAYER_1, GlobalVars.player_1_score)
	reset_player_position()
	reset_ball()
