extends Node

@onready var click_player: AudioStreamPlayer = $ClickPlayer

func play_click():
	click_player.play()


func _on_visuals_character_clicked() -> void:
	play_click()
