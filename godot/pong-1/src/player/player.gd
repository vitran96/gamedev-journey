extends KinematicBody2D

export var speed := 7
export var player_type := PlayerTypes.NONE

var UP_ACTION := ""
var DOWN_ACTION := ""

onready var ball_hit_audio = $BallHitAudio
onready var sound_detect_area_2d = $SoundDetectArea2D

func _ready() -> void:
	match player_type:
		PlayerTypes.PLAYER_1:
			UP_ACTION = "player_1_up"
			DOWN_ACTION = "player_1_down"
			sound_detect_area_2d.position.x += 2
		PlayerTypes.PLAYER_2:
			UP_ACTION = "player_2_up"
			DOWN_ACTION = "player_2_down"
			sound_detect_area_2d.position.x -= 2
		PlayerTypes.NONE:
			pass

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed(UP_ACTION):
		move_and_collide(Vector2(0, -speed))
	elif Input.is_action_pressed(DOWN_ACTION):
		move_and_collide(Vector2(0, speed))

func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == "Ball":
		ball_hit_audio.play()
