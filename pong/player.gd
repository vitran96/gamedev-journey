extends KinematicBody2D
class_name Player

#export var

const SPEED := 200

var velocity := Vector2()

func _physics_process(delta: float) -> void:
	var input_vector := Vector2()
	if Input.is_action_pressed("left_player_up"):
		input_vector.y -= SPEED
	elif Input.is_action_pressed("left_player_down"):
		input_vector.y += SPEED

	if input_vector != Vector2():
		velocity = input_vector
	else:
		velocity = Vector2()

	var collision: KinematicCollision2D = move_and_collide(velocity * delta)

	if collision:
		velocity = Vector2()
