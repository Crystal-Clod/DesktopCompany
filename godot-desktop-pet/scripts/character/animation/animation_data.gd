extends Node
var rng = RandomNumberGenerator.new()
signal play_animation (animation_data:AnimationResource)

@export var current_character : String
@export var current_animation : String

@export var use_external : bool
@export var overwrite_files : bool = false

@export var animations: Dictionary[String,AnimationResourceSet]

@export var internal_animations : Dictionary[String,AnimationResourceSet]
@export var external_animations : Dictionary[String,AnimationResourceSet]

@onready var animation_state_machine : AnimationStateMachine = %AnimationStateMachine

var character_folder : String
var animation_folder : String
var can_blink = true
var blink_is_running = false

func _ready():
	animation_state_machine.init()
	
	GameManager.character_files_setup.connect(
		func(character_folder : String):
			await get_tree().physics_frame
			self.character_folder = character_folder
			animation_folder = character_folder + "/Animation"
			
			_save_internal_to_files()
			_load_external_from_files()
			
			if use_external:
				animations = external_animations.duplicate_deep()
			else:
				animations = internal_animations.duplicate_deep()
			_blink()
	)
	
	DialogueManager.finished_dialogue.connect(_finished_dialogue)
	DialogueManager.finished_displaying.connect(_finished_dialogue)
	
	DialogueManager.talking_starts.connect(_start_talking)
	
func _save_internal_to_files():
	FileOperations.check_if_directory_exists(animation_folder)
		
	for key : String in internal_animations:
		var animation_resource_folder : String = animation_folder + "/" + key
		FileOperations.check_if_directory_exists(animation_resource_folder)
		var animation_resource_collection : AnimationResourceSet = internal_animations[key]
		var files = FileOperations.get_all_files_of_type_from_directory(animation_resource_folder + "/", "json")
		if !files.has(animation_resource_folder + "/" + key + ".json"):
			animation_resource_collection.save_to_json(animation_resource_folder + "/" + key)
		
		var animation_resources : Array[AnimationResource] = animation_resource_collection.animation_resources
		for resource : AnimationResource in animation_resources:
			if overwrite_files:
				resource.spritesheet.get_image().save_png(animation_resource_folder + "/" + resource.animation_name + ".png")
		
		
		
func _load_external_from_files():
	var directories = FileOperations.get_all_sub_directories(animation_folder + "/")
	for directory : String in directories:
		var json = JsonOperations.load_json(directory + "/" + directory.trim_prefix(animation_folder + "/") + ".json" )	
		var animation_resource_set : AnimationResourceSet = AnimationResourceSet.new()
		animation_resource_set.load_from_json(json)
		
			
		var image_files = FileOperations.get_all_files_of_type_from_directory(directory + "/", "png")
		for file : String in image_files:
			for resource in animation_resource_set.animation_resources:
				if resource.animation_name == file.trim_prefix(directory + "/").trim_suffix(".png"):
					var image : Image = Image.new()
					image.load(file)
					var texture = ImageTexture.new()
					texture = ImageTexture.create_from_image(image)
					resource.spritesheet = texture
					
		
		
		external_animations.get_or_add(directory.trim_prefix(animation_folder + "/"), animation_resource_set)
	
	print(external_animations)

func _blink():
	blink_is_running = true
	if(!can_blink):
		blink_is_running = false
		return
		
	animation_state_machine.play_animation("Idle")
	play_animation.emit(_get_animation_data_collection("Idle",0))
	
	
	
	await  get_tree().create_timer(rng.randf_range(0.5,3)).timeout
	if(!can_blink):
		blink_is_running = false
		return
	
	animation_state_machine.play_animation("Blink")
	play_animation.emit(_get_animation_data_collection("Blink",0))
	
	
	await  get_tree().create_timer(_get_animation_data_collection("Blink",0).frame_count/6.0).timeout
	
	_blink()

func _get_animation_data_collection(animation_name : String, which_collection : int):
	#print(animations)
	return animations.get(animation_name).animation_resources[which_collection]

func  _finished_dialogue():
	can_blink = true
	if(!blink_is_running):
		_blink()
	
	

func _start_talking(animation_name : String):
	if animation_name == "":
		animation_name = "Yap"
	
	animation_state_machine.play_animation("Yap")
	play_animation.emit(animations.get(animation_name).animation_resources[0])
	can_blink = false
