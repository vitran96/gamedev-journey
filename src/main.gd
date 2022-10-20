tool
extends Node

const PLAYER := preload("res://player/player.tscn")
const DEATH_ZONE := preload("res://death_zone/death_zone.tscn")
const BALL := preload("res://ball/ball.tscn")

func _ready() -> void:
	var window_size : Vector2 = Vector2()
	if Engine.editor_hint:
		window_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	else:
		window_size = get_viewport().size

	var middle_y := window_size.y / 2

	var player_1 := create_player(Vector2(GlobalVars.PLAYER_POSITION_OFFSET, middle_y), 1)
	add_child(player_1)

	var death_zone_1 := DEATH_ZONE.instance()
	death_zone_1.position = Vector2(0 - GlobalVars.DEATH_ZONE_OFFSET, middle_y)
	death_zone_1.connect("body_entered", self, "hit_death_zone")
	add_child(death_zone_1)

	var player_2 := create_player(Vector2(window_size.x - GlobalVars.PLAYER_POSITION_OFFSET, middle_y), 2)
	add_child(player_2)

	var death_zone_2 := DEATH_ZONE.instance()
	death_zone_2.position = Vector2(window_size.x + GlobalVars.DEATH_ZONE_OFFSET, middle_y)
	death_zone_2.connect("body_entered", self, "hit_death_zone")
	add_child(death_zone_2)

	var ball := BALL.instance()
	ball.position = window_size / 2
	if not Engine.editor_hint:
		# TODO: implement random shot
		ball.move_vector = Vector2(300, 300)

	add_child(ball)

func create_player(position:Vector2, player_type: int) -> Node:
	var player := PLAYER.instance()
	player.position = position
	player.player_type = player_type
	return player

func hit_death_zone(area: PhysicsBody2D) -> void:
	if area.name == "Ball":
		get_tree().reload_current_scene()
