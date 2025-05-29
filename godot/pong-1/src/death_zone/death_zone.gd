extends Area2D

signal hit_death_zone

export var player_type:= PlayerTypes.PLAYER_1

onready var audio = $Audio

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(area: PhysicsBody2D) -> void:
	if area.name == "Ball":
		audio.play()
		emit_signal("hit_death_zone", player_type)
