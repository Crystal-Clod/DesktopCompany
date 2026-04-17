extends Node

@export var dialogue_dictionary : Dictionary[String,Array]

func _init() -> void:
	GameManager.character_folders_setup.connect(
		func():
			GameManager._dialogue_setup(dialogue_dictionary)
	)
