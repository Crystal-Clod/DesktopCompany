extends Sprite2D

signal pet_clicked
signal pet_right_clicked

var rng = RandomNumberGenerator.new()

const SPEED:int = 50

var has_mouse:bool = false
var is_dragging:bool = false

var is_running : bool

var current_scale_step : Vector2 = Vector2(4.0,4.0)

func  _ready():
	_tween_scale()
	pass
func _input(event):
	if is_pixel_opaque(get_local_mouse_position()):
		has_mouse = true
	elif !is_dragging:
		has_mouse = false
		
	#if event.is_action_pressed("click"):
		#if has_mouse:
		#if is_pixel_opaque(get_local_mouse_position()):
func _process(delta):
	if !has_mouse:
		is_dragging = false
		return
		
	if Input.is_action_pressed("click"):
		pet_clicked.emit()
		is_dragging = true
		global_position = global_position.lerp(get_global_mouse_position(), SPEED*delta)
	
	if Input.is_action_just_pressed("right_click"):
		pet_right_clicked.emit()
		
	if Input.is_action_just_pressed("scroll_up"):
		print("Scrolling up")
		if(current_scale_step.x > 0.25):
			current_scale_step = current_scale_step/2
			_tween_scale()
			#scale = current_scale_step
	elif Input.is_action_just_pressed("scroll_down"):
		print("Scrolling down")
		if(current_scale_step.x < 16):
			current_scale_step = current_scale_step*2
			_tween_scale()
			#scale = current_scale_step

func  _tween_scale():
	var tween = get_tree().create_tween()
	tween.tween_property($".","scale", current_scale_step, 0.2)

	
func animate_via_code():
	await  get_tree().create_timer(1.0/6.0).timeout
	if(frame >= hframes -1):
		frame = 0
	else:
		frame += 1
	
	animate_via_code()	
	
	
###CHECK FOR TRANSPARENCY IF I EVER WANT GRIDS
#@export var texture_to_test: Texture2D
#@onready var image = texture_to_test.get_image()
#func is_full_transparent(area: Rect2D) -> boolean:
	#for x in range(area.position.x, area.end.x):
		#for y in range(area.position.y, area.end.y):
			#if Color.TRANSPARENT != image.get_pixel(x, y): return false
		#return true


func _on_animations_play_animation(animation_data):
	frame = 0
	texture = animation_data.spritesheet
	hframes = animation_data.frame_amount
	if(!is_running):
		is_running = true
		animate_via_code()
