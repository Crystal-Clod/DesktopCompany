extends CollisionPolygon2D

var current_scale_step : Vector2 = Vector2(1.0,1.0)

@onready var visuals : Sprite2D = $Pet/RigidBody2D/Visuals

func _ready() -> void:
	var pet : Pet = get_node("Pet")
	pet.change_scale.connect(_on_pet_change_scale)
	

func _on_pet_change_scale(current_scale: Vector2) -> void:
	print("works")
	current_scale_step = current_scale
	_tween_scale()

func  _tween_scale():
	var tween = get_tree().create_tween()
	tween.tween_property($".","scale", current_scale_step, 0.2)
	await tween.finished
	position = visuals.position - visuals.texture.get_size()/2.0
