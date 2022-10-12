extends RigidBody2D

export var move_vector := Vector2(0, 0)

func _ready() -> void:
	mode = RigidBody2D.MODE_CHARACTER
	apply_central_impulse(move_vector)
