extends Node
var rng = RandomNumberGenerator.new()
signal play_animation (animation_data:AnimationResource)

@export var current_character : String
@export var current_animation : String

@export var use_external : bool

@export var animations: Dictionary[String,AnimationResourceCollection]

@export var internal_animations : Dictionary[String,AnimationResourceCollection]
@export var external_animations : Dictionary[String,AnimationResourceCollection]

@onready var animation_state_machine: AnimationStateMachine = %AnimationStateMachine

var character_folder : String
var can_blink = true
var blink_is_running = false

func _ready():
	animation_state_machine.init()
	
	GameManager.character_files_setup.connect(
		func(character_folder : String):
			await get_tree().physics_frame
			self.character_folder = character_folder
			
			_save_internal_to_files()
			
			if use_external:
				print("External")
			else:
				animations = internal_animations.duplicate_deep()
			_blink()
	)
	
	DialogueManager.finished_dialogue.connect(_finished_dialogue)
	DialogueManager.finished_displaying.connect(_finished_dialogue)
	
	DialogueManager.talking_starts.connect(_start_talking)
	
func _save_internal_to_files():
	var animation_folder = character_folder + "/Animation"
	
	FileOperations.check_if_directory_exists(animation_folder)
		
	#var sub_directories = FileOperations.get_all_sub_directories(animation_folder)
		
	
	for key : String in internal_animations:
		var animation_resource_folder : String = animation_folder + "/" + key
		FileOperations.check_if_directory_exists(animation_resource_folder)
		var animation_resource_collection : AnimationResourceCollection = internal_animations[key]
		var files = FileOperations.get_all_files_of_type_from_directory(animation_resource_folder + "/", "json")
		if !files.has(animation_resource_folder + "/" + key + ".json"):
			animation_resource_collection.save_to_json(animation_resource_folder + "/" + key)
		
		var animation_resources : Array[AnimationResource] = animation_resource_collection.animation_data_collection
		for resource : AnimationResource in animation_resources:
			resource.spritesheet.get_image().save_png(animation_resource_folder + "/" + resource.animation_name + ".png")
		
		
		
func external_setup():
	#var animation_directories = ResourceLoader.list_directory("res://Characters/" + current_character + "/Sprites/Animations/")
#
	#for animation in animation_directories:
		#animation = animation.trim_suffix("/")
	pass

	

	
	
func _load_json(json_name : String):
	pass
	

func _blink():
	blink_is_running = true
	if(!can_blink):
		blink_is_running = false
		return
	play_animation.emit(_get_animation_data_collection("Idle",0))
	
	#animation_state_machine.play_animation("Idle")
	
	await  get_tree().create_timer(rng.randf_range(0.5,3)).timeout
	if(!can_blink):
		blink_is_running = false
		return
	play_animation.emit(_get_animation_data_collection("Blink",0))
	
	#animation_state_machine.play_animation("Blink")
	await  get_tree().create_timer(_get_animation_data_collection("Blink",0).frame_count/6.0).timeout
	
	_blink()

func _get_animation_data_collection(collection : String, which_collection : int):
	return animations.get(collection).animation_data_collection[which_collection]

func  _finished_dialogue():
	can_blink = true
	if(!blink_is_running):
		_blink()
	
	

func _start_talking(animation_name : String):
	if animation_name == "":
		animation_name = "Yap"
	
	animation_state_machine.play_animation("Yap")
	play_animation.emit(animations.get(animation_name).animation_data_collection[0])
	can_blink = false
