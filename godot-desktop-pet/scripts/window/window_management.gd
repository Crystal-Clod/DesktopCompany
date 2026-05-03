extends Node

@onready var main_window : Window = get_window()
@onready var sub_window : Window = $Window

func _ready() -> void:
	sub_window.world_2d = main_window.world_2d
