class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

@onready var player = get_tree().get_first_node_in_group("player")

var corn_plant_scene = preload("res://scenes/objects/plants/corn.tscn")
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn")
 
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _unhandled_input(event: InputEvent) -> void:
	get_cell_under_mouse()

			
func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
