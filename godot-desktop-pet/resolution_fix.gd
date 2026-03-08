extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var window: Window = get_window()
	window.size = Vector2i(DisplayServer.screen_get_size() + Vector2i(1, 1))
	window.position = DisplayServer.screen_get_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
