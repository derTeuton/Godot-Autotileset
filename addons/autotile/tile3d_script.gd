@tool
extends Node
class_name Tile3D

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
	var true_bools : Array = range(26)
	
	true_bools[0] = north1
	true_bools[1] = east1
	true_bools[2] = south1
	true_bools[3] = west1
	true_bools[4] = up1
	true_bools[5] = down1
	
	true_bools[6] = northeast1
	true_bools[7] = southeast1
	true_bools[8] = southwest1
	true_bools[9] = northwest1
	true_bools[10] = northup1
	true_bools[11] = eastup1
	true_bools[12] = southup1
	true_bools[13] = westup1
	true_bools[14] = northdown1
	true_bools[15] = eastdown1
	true_bools[16] = southdown1
	true_bools[17] = westdown1
	
	true_bools[18] = northeastup1
	true_bools[19] = southeastup1
	true_bools[20] = southwestup1
	true_bools[21] = northwestup1
	true_bools[22] = northeastdown1
	true_bools[23] = southeastdown1
	true_bools[24] = southwestdown1
	true_bools[25] = northwestdown1
	
	return true_bools

func get_false_bools() -> Array:
	var false_bools : Array = range(26)
	
	false_bools[0] = north2
	false_bools[1] = east2
	false_bools[2] = south2
	false_bools[3] = west2
	false_bools[4] = up2
	false_bools[5] = down2
	
	false_bools[6] = northeast2
	false_bools[7] = southeast2
	false_bools[8] = southwest2
	false_bools[9] = northwest2
	false_bools[10] = northup2
	false_bools[11] = eastup2
	false_bools[12] = southup2
	false_bools[13] = westup2
	false_bools[14] = northdown2
	false_bools[15] = eastdown2
	false_bools[16] = southdown2
	false_bools[17] = westdown2
	
	false_bools[18] = northeastup2 
	false_bools[19] = southeastup2
	false_bools[20] = southwestup2
	false_bools[21] = northwestup2
	false_bools[22] = northeastdown2
	false_bools[23] = southeastdown2
	false_bools[24] = southwestdown2
	false_bools[25] = northwestdown2
	
	return false_bools

@export var dir_true : Array
@export var dir_false : Array

@export_group("Wahre Richtungen")
@export_subgroup("Haupthimmelsrichtungen")
@export var north1 : bool 
@export var east1 : bool 
@export var south1 : bool 
@export var west1 : bool 
@export var up1 : bool 
@export var down1 : bool 
@export_subgroup("Nebenhimmelsrichtungen")
@export var northeast1 : bool 
@export var southeast1 : bool 
@export var southwest1 : bool 
@export var northwest1 : bool 
@export var northup1 : bool 
@export var eastup1 : bool 
@export var southup1 : bool 
@export var westup1 : bool 
@export var northdown1 : bool 
@export var eastdown1 : bool 
@export var southdown1 : bool 
@export var westdown1 : bool 
@export_subgroup("Eckrichtungenrichtungen")
@export var northeastup1 : bool
@export var southeastup1 : bool
@export var southwestup1 : bool 
@export var northwestup1 : bool
@export var northeastdown1 : bool
@export var southeastdown1 : bool 
@export var southwestdown1 : bool 
@export var northwestdown1 : bool

@export_group("Flasche Richtungen")
@export_subgroup("Haupthimmelsrichtungen")
@export var north2 : bool 
@export var east2 : bool 
@export var south2 : bool 
@export var west2 : bool 
@export var up2 : bool 
@export var down2 : bool 
@export_subgroup("Nebenhimmelsrichtungen")
@export var northeast2 : bool 
@export var southeast2 : bool 
@export var southwest2 : bool 
@export var northwest2 : bool 
@export var northup2 : bool 
@export var eastup2 : bool 
@export var southup2 : bool 
@export var westup2 : bool 
@export var northdown2 : bool 
@export var eastdown2 : bool 
@export var southdown2 : bool 
@export var westdown2 : bool 
@export_subgroup("Eckrichtungenrichtungen")
@export var northeastup2 : bool
@export var southeastup2 : bool
@export var southwestup2 : bool 
@export var northwestup2 : bool
@export var northeastdown2 : bool
@export var southeastdown2 : bool 
@export var southwestdown2 : bool 
@export var northwestdown2 : bool
