extends Node2D

func _init() -> void:
	Events.game_changed_screens.connect(_resize_window)

func _ready():
	_resize_window(1)

func _resize_window(screen_number : int):
	var window: Window = get_window()
	var safe_rect : Rect2i = DisplayServer.screen_get_usable_rect(screen_number)
	print(safe_rect)
	window.size = safe_rect.size
	window.position = safe_rect.position
	
	print(DisplayServer.get_window_list())
	
	Events.resolution_set.emit()
