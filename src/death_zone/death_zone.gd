extends Area2D

signal hit_death_zone

export var player_type:= PlayerTypes.PLAYER_1

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(area: PhysicsBody2D) -> void:
	if area.name == "Ball":
		emit_signal("hit_death_zone", player_type)
