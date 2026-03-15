@tool
extends RigidBody2D

@onready var sprite = $Visuals

@export var snap_distance : float = 1

@export_tool_button("Generate Polygon")
var button = _sprite_to_polygon
@export_tool_button("Clear All Polygons")
var clear_button = _clear_polygons


func _ready() -> void:
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
		collision_polygon.owner = self.get_parent()
		
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
			
