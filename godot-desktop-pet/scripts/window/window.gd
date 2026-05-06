extends Window


@onready var _Camera: Camera2D = $Camera2D

var last_position: = Vector2i.ZERO
var velocity: = Vector2i.ZERO

func _ready() -> void:
	# Set the anchor mode to "Fixed top-left"
	# Easier to work with since it corresponds to the window coordinates
	_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	
	var window: Window = get_window()
	var safe_rect : Rect2i = DisplayServer.screen_get_usable_rect(0)
	print(safe_rect)
	window.size = safe_rect.size
	window.position = safe_rect.position
	
	_Camera.offset.x = -DisplayServer.screen_get_size(1).x/2 - 32
	
	#transient = true # Make the window considered as a child of the main window
	close_requested.connect(queue_free) # Actually close the window when clicking the close button

func _process(_delta: float) -> void:
	
	velocity = position - last_position
	last_position = position
	_Camera.position = get_camera_pos_from_window()

func get_camera_pos_from_window()->Vector2i:
	return position + velocity
