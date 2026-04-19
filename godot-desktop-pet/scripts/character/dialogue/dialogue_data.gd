class_name DialogueData
extends Node
@export var use_external = false
@export var save_animations_to_files = false

@export var dialogues : Dictionary[String,DialogueSetArray]
@export var internal_dialogues : Dictionary[String,DialogueSetArray]
@export var external_dialogues : Dictionary[String,DialogueSetArray]
var character_folder : String

func _init() -> void:
	GameManager.character_files_setup.connect(
		func(character_folder : String):
			await get_tree().physics_frame
			self.character_folder = character_folder
			
			if save_animations_to_files:
				_save_internal_to_files()
			
			_load_external_from_files()
			
			if use_external:
				dialogues = external_dialogues.duplicate_deep()
			else:
				dialogues = internal_dialogues.duplicate_deep()
			
	)



func _save_internal_to_files():
	var dialogue_folder = character_folder + "/Dialogue"
	
	FileOperations.check_if_directory_exists(dialogue_folder)
		
	var files = FileOperations.get_all_files_of_type_from_directory(dialogue_folder, "json")
	for key : String in internal_dialogues:
		var dialogue_set_array : DialogueSetArray = internal_dialogues[key]
		if !files.has(dialogue_folder + "/" + key + ".json"):
			dialogue_set_array.save_to_json(dialogue_folder + "/" + key)
		
		
		

func _load_external_from_files():
	
	var dialogue_folder = character_folder + "/Dialogue"
	
	#var open_directory = DirAccess.open(dialogue_folder)
	
	var files = FileOperations.get_all_files_of_type_from_directory(dialogue_folder, "json")
	
	for file in files:
		var json = JsonOperations.load_json(file)
		
		print(json)
		
		var dialogue_set_array : DialogueSetArray = DialogueSetArray.new()
		dialogue_set_array.load_from_json(json)
		
		external_dialogues.get_or_add("Intro", dialogue_set_array)
	
	

	
	
	
