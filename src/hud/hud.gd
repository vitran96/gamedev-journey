extends CanvasLayer

func set_score_text(player_type: int, score: int):
	match player_type:
		PlayerTypes.PLAYER_1:
			$HBoxContainer/Score1.text = String(score)
		PlayerTypes.PLAYER_2:
			$HBoxContainer/Score2.text = String(score)
