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
		print("animation")
		var animation_resource_folder : String = animation_folder + "/" + key
		FileOperations.check_if_directory_exists(animation_resource_folder)
		#var dialogue_set_array : DialogueSetArray = internal_dialogues[key]
		#if !files.has(dialogue_folder + "/" + key + ".json"):
			#dialogue_set_array.save_to_json(dialogue_folder + "/" + key)

func external_setup():
	var animation_directories = ResourceLoader.list_directory("res://Characters/" + current_character + "/Sprites/Animations/")

	for animation in animation_directories:
		animation = animation.trim_suffix("/")
		_load_animations_from_path(animation)

	
func _load_animation(animation_name : String, animation_type : String) -> AnimationResource:
	var temp_anim = AnimationResource.new()
	var temp_path = "res://Characters/" + current_character + "/Sprites/Animations/"+ animation_type + "/" + animation_name
	temp_anim.spritesheet = ResourceLoader.load(temp_path)
	
	temp_anim.animation_type = current_animation
	
	var split_name = temp_path.split("/")
	
	temp_anim.file_name = split_name[split_name.size()-1]
	temp_anim.animation_name = temp_anim.file_name.get_basename()
	
	split_name = temp_anim.animation_name.split("_")
	temp_anim.frame_amount = split_name[split_name.size()-1].to_int()
	return temp_anim
	
	
func _load_animations_from_path(animation : String):
	var temp_path = "res://Characters/" + current_character + "/Sprites/Animations/"+ animation
	var files_in_directory = ResourceLoader.list_directory(temp_path)
	#print(files_in_directory)
	for file in files_in_directory:
		if(file.ends_with(".json")):
			_load_json(file)
			files_in_directory.erase(file)
			break
	
	var temp_animation_collection = AnimationResourceCollection.new() 
	for file in files_in_directory:
		if(file.ends_with(".png")):	
			temp_animation_collection.animation_data_collection.append(_load_animation(file, animation))
			
	if(!animations.get(animation)):
		animations.get_or_add(animation,temp_animation_collection)
	
	
func _load_json(json_name : String):
	var json_path = "res://Characters/" + current_character + "/Sprites/Animations/"+ current_animation+ "/" + json_name
	var data_file = FileAccess.open(json_path, FileAccess.READ)
	var parsed_result = JSON.parse_string(data_file.get_as_text())

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
	await  get_tree().create_timer(_get_animation_data_collection("Blink",0).frame_amount/6.0).timeout
	
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
