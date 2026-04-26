@tool
extends RigidBody2D

@onready var sprite = $Visuals

@export var snap_distance : float = 1

@export var enable_physics : bool = false

@export_tool_button("Generate Polygon")
var button = _sprite_to_polygon
@export_tool_button("Clear All Polygons")
var clear_button = _clear_polygons

var previous_position : Vector2

var initialized : bool = false

func _init() -> void:
	#maybe move event to here later
	Events.resolution_set.connect(
	func():
		if !initialized:
			initialized = true
			position = get_viewport_rect().get_center()
		)
	pass

func _ready() -> void:
	#UNCOMMENT THIS TO SEE COLLISIONS
	#get_tree().debug_collisions_hint = true

	if Engine.is_editor_hint():
		return
		
	_clear_polygons()
	_sprite_to_polygon()
	pass
	
func _clear_polygons():
	var polygons_removed : int = 0
	for child in get_children():
		if child is CollisionPolygon2D:
			polygons_removed += 1
			child.queue_free()
	if(polygons_removed > 0):
		print("Removed: " + str(polygons_removed)  + " polygons")

func _sprite_to_polygon() -> void:
	var data = sprite.texture.get_image()
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(data)
	
	var polys = bitmap.opaque_to_polygons(
		Rect2(
			Vector2.ZERO,
			sprite.texture.get_size()
		),
		1 #How detailed, lower number = more detailed
	)
	
	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		
		if snap_distance > 0:
			poly = _clean_polygon(poly)
			
		collision_polygon.polygon = poly
		
		
		add_child(collision_polygon)
		collision_polygon.owner = owner
		collision_polygon.set_script(CollisionShapeScaling)
		collision_polygon._initialize($"..", sprite)
		
		# Generated polygon will not take into account the half-width and half-height offset
		# of the image when "centered" is on. So move it backwards by this amount so it lines up.
		if sprite.centered:
			collision_polygon.position -= bitmap.get_size()/2.0
			
func _clean_polygon(points : PackedVector2Array) -> PackedVector2Array:
		var cleaned = []
	
		#This is basically Blender merge by distance, with "snap distance" being that distance
		for p in points:
			if cleaned.size() == 0 or cleaned[-1].distance_to(p) > snap_distance:
				cleaned.append(p)
		#Remove last point if duplicate
		if cleaned.size() > 1 and cleaned[0].distance_to(cleaned[-1]) < snap_distance:
			cleaned.pop_back()
		return PackedVector2Array(cleaned)
			

func _on_companion_dragging_state(is_dragging: bool) -> void:
	if !enable_physics:
		return
		
	freeze = is_dragging
	
	if !freeze:
		var throw_vector : Vector2 = get_global_mouse_position() - previous_position
		var mouse_distance = previous_position.distance_to(get_global_mouse_position())
		
		linear_velocity = throw_vector.normalized() * (mouse_distance * 25)
	
	previous_position = get_global_mouse_position()
