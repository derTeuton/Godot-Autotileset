@tool
extends EditorPlugin

var node_name : String = "AutoGridMap"
var type : String = "GridMap"
var node_script : Script = preload("3d-autotile.gd")
var icon : Texture2D = preload("res://addons/autotile/icon.svg")

func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type(node_name,type,node_script,icon)
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type(node_name)
	pass
