extends Node2D

func _init() -> void:
	Events.game_changed_screens.connect(_resize_window)

func _ready():
	_resize_window(0)

func _resize_window(screen_number : int):
	var window: Window = get_window()
	var screen_size = DisplayServer.screen_get_size(screen_number)
	window.size = Vector2i(screen_size + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()
	Events.resolution_set.emit()
