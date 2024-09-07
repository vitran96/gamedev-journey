extends Node
class_name Player


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_width(w: int) -> void:
	$ColorRect.rect_size.x = w

func set_height(h: int) -> void:
	$ColorRect.rect_size.y = h
