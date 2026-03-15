extends Node2D

func _ready():
	var window: Window = get_window()
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()
