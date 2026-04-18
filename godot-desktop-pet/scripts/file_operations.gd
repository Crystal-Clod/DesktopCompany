class_name FileOperations

static func print_all_files_from_directory(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			#if dir.current_is_dir():
				#print("Found directory: " + file_name)
			#else:
				#print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

static func get_all_files_of_type_from_directory(path : String, extension : String) -> Array[String]:
	var dir = DirAccess.open(path)
	
	if !path.ends_with("/"):
		path += "/"
	
	var files : Array[String]
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if !dir.current_is_dir():
				if(file_name.ends_with("." + extension)):
					
					files.append(path+file_name)
					#print("Found file: " + file_name)
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return files

static func get_all_sub_directories(path):
	var directories : Array
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				directories.append(path+file_name)
				var sub_directories : Array = get_all_sub_directories(path+file_name+"/")
				if(len(sub_directories) > 0):
					#print("Sub-directories in " + file_name + " are " + str(sub_directories))
					directories.append_array(sub_directories)
					pass
					
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return directories
