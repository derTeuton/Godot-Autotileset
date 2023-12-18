extends EditorInspectorPlugin

# Das Skript handelt nur, wenn ein 'Tile' Node Inspiziert wird
func _can_handle(object):
	return object is Node


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags, wide: bool):
	#print([object,name,type])
	if name == "save_tilemap_button":
		var button : Button
		button = Button.new()
		button.text = "Save"
		button.pressed.connect( func _on_save(): object.emit_signal("save") )
		add_custom_control(button)
		
		return true
	
	if name == "category": return true
	
	if name == "dir_true" or name == "dir_false": return true

