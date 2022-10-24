tool
extends CanvasLayer

onready var score_1_node := $HBoxContainer/Score1
onready var score_2_node := $HBoxContainer/Score2

func set_score_text(player_type: int, score: int):
	match player_type:
		PlayerTypes.PLAYER_1:
			score_1_node.text = String(score)
		PlayerTypes.PLAYER_2:
			score_1_node.text = String(score)
