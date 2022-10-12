extends KinematicBody2D

enum PLAYER_TYPES {PLAYER_1 = 1, PLAYER_2 = 2}

export var speed := 7
export var player_type:= PLAYER_TYPES.PLAYER_1

var UP_ACTION := ""
var DOWN_ACTION := ""

func _ready() -> void:
	match player_type:
		PLAYER_TYPES.PLAYER_1:
			UP_ACTION = "player_1_up"
			DOWN_ACTION = "player_1_down"
		PLAYER_TYPES.PLAYER_2:
			UP_ACTION = "player_2_up"
			DOWN_ACTION = "player_2_down"

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(UP_ACTION):
		move_and_collide(Vector2(0, -speed))
	elif Input.is_action_pressed(DOWN_ACTION):
		move_and_collide(Vector2(0, speed))
