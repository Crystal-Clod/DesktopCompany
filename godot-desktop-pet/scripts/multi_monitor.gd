extends Node

var current_pointer_screen = 0

func _ready() -> void:
	current_pointer_screen = DisplayServer.window_get_current_screen(0)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_MOUSE_EXIT:
			Events.pointer_changed_screens.emit()
	
