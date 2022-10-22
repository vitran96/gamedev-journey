extends RigidBody2D

export var speed := 450
export var direction := 0.0

func _ready() -> void:
	linear_damp = 0
	friction = 0
	var move_vector := Vector2(speed, 0)
	move_vector = move_vector.rotated(direction)
	if not Engine.editor_hint:
		apply_central_impulse(move_vector)
