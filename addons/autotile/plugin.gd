@tool
extends EditorPlugin

var node_name : String 		= "AutoGridMap"
var gridmap : String 		= "GridMap"
var node_script : Script 	= preload("autotile_script.gd")
var icon : Texture2D 		= preload("res://addons/autotile/icon.svg")

var node_name2 : String 	= "Tilemap-3D"
var node : String 			= "Node"
var node_script2 : Script 	= preload("tilemap_3d_script.gd")
var icon2 : Texture2D 		= preload("res://addons/autotile/tileset.svg")

var node_name3 : String 	= "Tilemap-River"
var node_script3 : Script 	= preload("tilemap_2d_script.gd")
var icon3 : Texture2D 		= preload("res://addons/autotile/tileset.svg")

var node_name4 : String 	= "Tilemap-Path"
var node_script4 : Script 	= preload("tilemap_2d_script.gd")
var icon4 : Texture2D 		= preload("res://addons/autotile/tileset.svg")

var node_name5 : String 	= "Tile2D"
var node_script5 : Script 	= preload("tile2d_script.gd")
var icon5 : Texture2D 		= preload("res://addons/autotile/tileset.svg")

var node_name6 : String 	= "Tile3D"
var node_script6 : Script 	= preload("tile3d_script.gd")
var icon6 : Texture2D 		= preload("res://addons/autotile/tileset.svg")

var ui_script = preload("res://addons/autotile/ui_script.gd").new()

func _enter_tree():
	# Einzug
	add_custom_type(node_name,gridmap,node_script,icon)
	add_custom_type(node_name2,node,node_script2,icon2)
	add_custom_type(node_name3,node,node_script3,icon3)
	add_custom_type(node_name4,node,node_script4,icon4)
	add_custom_type(node_name5,node,node_script5,icon5)
	add_custom_type(node_name6,node,node_script6,icon6)
	
	add_inspector_plugin(ui_script)
	
	print("Autotileset Plugin geladen, Nodes hinzugefügt")
	pass


func _exit_tree():
	# Abzug
	remove_custom_type(node_name)
	remove_custom_type(node_name2)
	remove_custom_type(node_name3)
	remove_custom_type(node_name4)
	remove_custom_type(node_name5)
	remove_custom_type(node_name6)
	
	remove_inspector_plugin(ui_script)
	
	print("Autotileset Plugin ausgeschalten, Nodes entfernt")
	pass
