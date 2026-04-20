extends Sprite2D
@export var rigid_body_2d: RigidBody2D
@export var character : Character

@export var dialogue_resource_test : DialogueResource
@onready var dialogue_box_position: Node2D = %DialogueBoxPosition

signal character_clicked
signal character_right_clicked

const SPEED:int = 50

var mouse_offset:Vector2
var click_position:Vector2

var is_running : bool

enum  Status {
	None,
	Selected,
	Dragging
}

var is_mouse_hovering : bool = false
var is_yapping : bool = false

var sprite_status : Status
@export var drag_offset: float = 0.5

var current_scale_step : Vector2 = Vector2(1.0,1.0)
var current_animation : AnimationResource
func _init() -> void:
	Events.pointer_changed_screens.connect(
		func():
			if sprite_status == Status.Dragging:
				DisplayServer.window_set_current_screen(DisplayServer.SCREEN_WITH_MOUSE_FOCUS)
				Events.game_changed_screens.emit()
	)
	Events.resolution_set.connect(
		func():
			var max_iterations: int = 5
			var current_iteration: int = 0
			while get_viewport_rect().size.x/(texture.get_size().x*current_iteration) > 10:
				if(current_iteration >= max_iterations):
					return
				current_iteration += 1
				
			character._set_scale_instantly(Vector2.ONE * current_iteration)
			)
			
func  _ready():
	var dialogue_position = Vector2((texture.get_size().x/2) * scale.x, 0.0)
	dialogue_box_position.position = dialogue_position
	pass
	
func _input(_event):
	if is_pixel_opaque(get_local_mouse_position()):
		is_mouse_hovering = true
	elif sprite_status == Status.None:
		is_mouse_hovering = false
		
		
func _process(_delta):
	if Input.is_action_just_released("click"):
		if sprite_status == Status.Selected:
			var dialogue : DialogueResource = character.get_random_dialogue_from_rarity_set("Intro")
			DialogueManager._dialogue(dialogue, 
			dialogue_box_position)
		if sprite_status == Status.Dragging:
			character.emit_signal("dragging_state", false)
			
		sprite_status = Status.None
			
	if !is_mouse_hovering:
		return
		
	if Input.is_action_just_pressed("click"):
		character_clicked.emit()
		sprite_status = Status.Selected
		click_position = position - get_global_mouse_position()
		
	
	
	if sprite_status == Status.Selected:
		if click_position.distance_to(position - get_global_mouse_position()) > drag_offset:
			mouse_offset = global_position - get_global_mouse_position()
			sprite_status = Status.Dragging
		
	if sprite_status == Status.Dragging:
		#FIX THIS LATER SO IT DRAGS BEHIND NICELY
		#global_position = global_position.lerp(get_global_mouse_position(), SPEED*delta)
		#global_position = get_global_mouse_position() + mouse_offset
		character.emit_signal("dragging_state", true)
		rigid_body_2d.position = get_global_mouse_position() + mouse_offset
		
	
	if Input.is_action_just_pressed("right_click"):
		character_right_clicked.emit()
		
		
	if Input.is_action_just_pressed("scroll_up"):
		character.increase_scale()
			
	elif Input.is_action_just_pressed("scroll_down"):
		character.decrease_scale()
		
	if Input.is_action_just_released("quit"):
		get_tree().quit()

func  _tween_scale():
	var tween = get_tree().create_tween()
	tween.tween_property($".","scale", current_scale_step, 0.2)

	
func _animate_via_code():
	await  get_tree().create_timer(1.0/6.0).timeout
	if(frame >= hframes -1):
		frame = 0
	else:
		frame += 1
	
	_animate_via_code()	
	
	
###CHECK FOR TRANSPARENCY IF I EVER WANT GRIDS
#@export var texture_to_test: Texture2D
#@onready var image = texture_to_test.get_image()
#func is_full_transparent(area: Rect2D) -> boolean:
	#for x in range(area.position.x, area.end.x):
		#for y in range(area.position.y, area.end.y):
			#if Color.TRANSPARENT != image.get_pixel(x, y): return false
		#return true
func _on_character_change_scale(current_scale: Vector2) -> void:
	current_scale_step = current_scale
	_tween_scale()

func _on_animation_data_play_animation(animation_data: AnimationResource) -> void:
	if animation_data == current_animation:
		return
	
	current_animation = animation_data
	frame = 0
	texture = animation_data.spritesheet
	hframes = animation_data.frame_count
	if(!is_running):
		is_running = true
		_animate_via_code()


func _on_character_set_scale_instantly(scale_relative_to_initial_scale: Vector2) -> void:
	current_scale_step = scale_relative_to_initial_scale
	scale = scale_relative_to_initial_scale
