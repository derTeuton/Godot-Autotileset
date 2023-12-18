@tool
extends Node
class_name Tile2D

var index_name : String = self.name

func _enter_tree():
	#self.property_list_changed.connect(update_variables)
	if not self.renamed.is_connected(on_renamed):
		self.renamed.connect(on_renamed)

func update_variables():
	dir_true = get_true_bools()
	dir_false = get_false_bools()
	self.get_parent().emit_signal("child_property_list_changed")
	#print("tile variables updated")



func _process(delta):
	update_variables()
	#print(dir_true)



func on_renamed():
	self.name = index_name

@export var mesh_name : String = "Mesh-Name"

func get_true_bools() -> Array:
	var true_bools : Array = range(8)
	
	true_bools[0] = north1
	true_bools[1] = east1
	true_bools[2] = south1
	true_bools[3] = west1
	
	true_bools[4] = northeast1
	true_bools[5] = southeast1
	true_bools[6] = southwest1
	true_bools[7] = northwest1
	
	return true_bools

func get_false_bools() -> Array:
	var false_bools : Array = range(8)
	
	false_bools[0] = north2
	false_bools[1] = east2
	false_bools[2] = south2
	false_bools[3] = west2
	
	false_bools[4] = northeast2
	false_bools[5] = southeast2
	false_bools[6] = southwest2
	false_bools[7] = northwest2
	
	return false_bools

@export var dir_true : Array
@export var dir_false : Array

@export_group("Wahre Richtungen")
@export_subgroup("Haupthimmelsrichtungen")
@export var north1 : bool 
@export var east1 : bool 
@export var south1 : bool 
@export var west1 : bool 
@export_subgroup("Nebenhimmelsrichtungen")
@export var northeast1 : bool 
@export var southeast1 : bool 
@export var southwest1 : bool 
@export var northwest1 : bool 
@export_group("Flasche Richtungen")
@export_subgroup("Haupthimmelsrichtungen")
@export var north2 : bool 
@export var east2 : bool 
@export var south2 : bool 
@export var west2 : bool 
@export_subgroup("Nebenhimmelsrichtungen")
@export var northeast2 : bool 
@export var southeast2 : bool 
@export var southwest2 : bool 
@export var northwest2 : bool 
