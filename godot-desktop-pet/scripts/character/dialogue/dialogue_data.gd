class_name DialogueData
extends Node
@export var use_external = false
@export var overwrite_files = false

@export var dialogues : Dictionary[String,DialogueSetArray]
@export var internal_dialogues : Dictionary[String,DialogueSetArray]
@export var external_dialogues : Dictionary[String,DialogueSetArray]
var character_folder : String
var dialogue_folder : String

func _init() -> void:
	GameManager.character_files_setup.connect(
		func(_character_folder : String):
			await get_tree().physics_frame
			character_folder = _character_folder
			dialogue_folder = character_folder + "/Dialogue"
			
			_save_internal_to_files()
			
			_load_external_from_files()
			
			if use_external:
				dialogues = external_dialogues.duplicate_deep()
			else:
				dialogues = internal_dialogues.duplicate_deep()
			
	)



func _save_internal_to_files():
	
	FileOperations.check_if_directory_exists(dialogue_folder)
		
	var files = FileOperations.get_all_files_of_type_from_directory(dialogue_folder, "json")
	for key : String in internal_dialogues:
		var dialogue_set_array : DialogueSetArray = internal_dialogues[key]
		if overwrite_files:
			dialogue_set_array.save_to_json(dialogue_folder + "/" + key)
		else:
			if !files.has(dialogue_folder + "/" + key + ".json"):
				dialogue_set_array.save_to_json(dialogue_folder + "/" + key)
		
		
		

func _load_external_from_files():
	
	var files = FileOperations.get_all_files_of_type_from_directory(dialogue_folder, "json")
	
	for file in files:
		var json = JsonOperations.load_json(file)
		
		var dialogue_set_array : DialogueSetArray = DialogueSetArray.new()
		dialogue_set_array.load_from_json(json)
		
		external_dialogues.get_or_add("Intro", dialogue_set_array)
	
	

	
	
	
