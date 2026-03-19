extends Sprite2D
@export var rigid_body_2d: RigidBody2D
@export var pet: Pet

@export var dialogue_resource_test : DialogueResource

signal pet_clicked
signal pet_right_clicked

var rng = RandomNumberGenerator.new()

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
var current_animation : AnimationData

#var dialogue_set : DialogueSet

func  _ready():
	#var dialogue_set_data = JsonOperations.load_json(
			#"res://Characters/Donqui/Resources/Dialogue/Intro/DialogueSetTest.json")
	#dialogue_set = DialogueSet.new()
	#dialogue_set.load_from_json(dialogue_set_data)
	var dialogue_position = Vector2((texture.get_size().x/2) * scale.x, 0.0)
	get_node("DialogueBoxPosition").position = dialogue_position
	pass
	
func _input(_event):
	if is_pixel_opaque(get_local_mouse_position()):
		is_mouse_hovering = true
	elif sprite_status == Status.None:
		is_mouse_hovering = false
		
		
func _process(_delta):
	
	if Input.is_action_just_released("click"):
		if sprite_status == Status.Selected:
			var dialogue : DialogueResource = pet.get_random_dialogue_from_set("Intro")
			DialogueManager._dialogue(dialogue, 
			get_node("DialogueBoxPosition"))
			#DialogueManager._dialogue(dialogue_resource_test, 
			#get_node("DialogueBoxPosition"))
		if sprite_status == Status.Dragging:
			pet.emit_signal("dragging_state", false)
			
		sprite_status = Status.None
			
	if !is_mouse_hovering:
		return
		
	if Input.is_action_just_pressed("click"):
		pet_clicked.emit()
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
		pet.emit_signal("dragging_state", true)
		rigid_body_2d.position = get_global_mouse_position() + mouse_offset
		
	
	if Input.is_action_just_pressed("right_click"):
		pet_right_clicked.emit()
		
		
	if Input.is_action_just_pressed("scroll_up"):
		pet._increase_scale()
			
	elif Input.is_action_just_pressed("scroll_down"):
		pet._decrease_scale()

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

func _on_animations_play_animation(animation_data):
	if animation_data == current_animation:
		return
	
	current_animation = animation_data
	frame = 0
	texture = animation_data.spritesheet
	hframes = animation_data.frame_amount
	if(!is_running):
		is_running = true
		_animate_via_code()


func _on_pet_change_scale(current_scale: Vector2) -> void:
	current_scale_step = current_scale
	_tween_scale()
