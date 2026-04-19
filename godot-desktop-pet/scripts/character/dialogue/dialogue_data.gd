class_name DialogueData
extends Node
@export var use_external = false

@export var dialogue_dictionary : Dictionary[String,DialogueSetArray]
@export var internal_dialogue_dictionary : Dictionary[String,DialogueSetArray]
@export var external_dialogue_dictionary : Dictionary[String,DialogueSetArray]
var character_folder : String

func _init() -> void:
	GameManager.character_files_setup.connect(
		func(character_folder : String):
			await get_tree().physics_frame
			self.character_folder = character_folder
			if use_external:
				_dialogue_external_setup()
				dialogue_dictionary = external_dialogue_dictionary.duplicate_deep()
			else:
				_dialogue_setup()
				print(internal_dialogue_dictionary)
				dialogue_dictionary = internal_dialogue_dictionary.duplicate_deep()
			
	)

func _dialogue_setup():
	var dialogue_folder = character_folder + "/Dialogue"
	
	var open_directory = DirAccess.open(dialogue_folder)
	
	if open_directory:
		#print("Directory exists: ", dialogue_folder)
		pass
	else:
		print("Directory does NOT exist: ", dialogue_folder)
		DirAccess.make_dir_absolute(dialogue_folder)
		
	var files = FileOperations.get_all_files_of_type_from_directory(dialogue_folder, "json")
	for key : String in internal_dialogue_dictionary:
		print(key)
		var dialogue_set_array : DialogueSetArray = internal_dialogue_dictionary[key]
		if !files.has(dialogue_folder + "/" + key + ".json"):
			print("Saved - " + key)
			dialogue_set_array.save_to_json(dialogue_folder + "/" + key)
		
		
		

func _dialogue_external_setup():
	
	var dialogue_folder = character_folder + "/Dialogue"
	
	#var open_directory = DirAccess.open(dialogue_folder)
	
	var files = FileOperations.get_all_files_of_type_from_directory(dialogue_folder, "json")
	#print(files)
	
	for file in files:
		var json = JsonOperations.load_json(file)
		
		print(json)
		
		var dialogue_set_array : DialogueSetArray = DialogueSetArray.new()
		dialogue_set_array.load_from_json(json)
		
		external_dialogue_dictionary.get_or_add("Intro", dialogue_set_array)
	
	

	
	
	
