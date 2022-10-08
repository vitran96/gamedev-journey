extends RigidBody2D

func _ready() -> void:
    mode = RigidBody2D.MODE_CHARACTER
    linear_velocity = Vector2(40, 0) # TODO: remove
