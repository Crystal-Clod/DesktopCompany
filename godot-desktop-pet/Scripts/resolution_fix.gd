extends Node2D

func _init() -> void:
	Events.game_changed_screens.connect(_resize_window)

func _ready():
	_resize_window()

func _resize_window():
	var window: Window = get_window()
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()
	Events.resolution_set.emit()
