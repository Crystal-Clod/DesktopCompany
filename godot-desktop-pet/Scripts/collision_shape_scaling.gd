extends CollisionPolygon2D

class_name CollisionShapeScaling

var current_scale_step : Vector2 = Vector2(1.0,1.0)

var visuals : Sprite2D

func _initialize(character: Character, vis : Sprite2D) -> void:
	visuals = vis
	character.change_scale.connect(_on_character_change_scale)
	set_process(true)
	
func _process(_delta: float) -> void:
	if scale == visuals.scale:
		return
		
	scale = visuals.scale
	position = visuals.position - (visuals.texture.get_size()/2.0)*visuals.scale
	

func _on_character_change_scale(current_scale: Vector2) -> void:
	current_scale_step = current_scale
	
