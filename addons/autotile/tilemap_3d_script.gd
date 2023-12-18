@tool
extends Node
class_name Tilemap_3D

signal save
signal child_property_list_changed(tile)

@export var save_tilemap_button : Button 
@export var tile_data : Array 
var tile_script : Script = preload("res://addons/autotile/tile3d_script.gd")

@export 	var category : String = "3D"
@export 	var mesh_library3D : MeshLibrary
@export 	var tile_count : int
@export 	var river_tilemap : Tilemap_2D
@export 	var path_tilemap : Tilemap_2D
@export 	var sand_tilemap : Tilemap_2D

func _enter_tree():
	if not self.child_entered_tree.is_connected(_on_child_enter_tree):
		self.child_entered_tree.connect(_on_child_enter_tree)
	if not self.child_exiting_tree.is_connected(_on_child_exit_tree):
		self.child_exiting_tree.connect(_on_child_exit_tree)
	if not self.child_property_list_changed.is_connected(update_tile_library):
		self.child_property_list_changed.connect(update_tile_library)
	if not self.save.is_connected(_save_tilemap):
		self.save.connect(_save_tilemap)
	
	category = "3D"
	
	pass

func _on_child_enter_tree( node : Node ):
	if not node.renamed.is_connected(_on_child_rename.bind(node)):
		node.renamed.connect(_on_child_rename.bind(node))
	
	pass

func _on_child_exit_tree( node : Node ):
	
	pass

func _on_child_rename( node : Node ):
	
	pass

func _save_tilemap():
	print("Die Speicherfunktion ist noch nicht ausgereift")
	var scene = PackedScene.new()
	scene.pack(self)
	
	
	print(scene)
	pass



func _process(delta):
	create_tile_childs()
	update_tile_library()
	
	return



# Bestimmt die angaben des Nutzers der Tiles 
func update_tile_library():
	if mesh_library3D == null: return
	tile_data = range(tile_count)
	var children : Array = self.get_children()
	for _child in children:
		var tile : Array = range(4)
		var i : int = extract_number_from_name(_child.name)
		tile[0] = _child.mesh_name
		tile[1] = mesh_library3D.find_item_by_name(tile[0])
		tile[2] = _child.dir_true
		tile[3] = _child.dir_false
		tile_data[i] = tile

# Wenn der Nutzer die Tile Anzahl erhöht werden automatisch neue Tiles erstellt
func create_tile_childs():
	var children : Array 	= self.get_children()
	var child_count : int 	= children.size()
	if	 	child_count == tile_count: pass
	elif 	child_count <= tile_count: 
		var start 	: int = children.size()
		var length 	: int = tile_count - children.size()
		var index 	: int = start
		for i in range(length):
			index = start + i
			if index != tile_count:
				var tile : Tile3D
				tile = Tile3D.new()
				tile.name = "Tile" + str(index)
				tile.set_script(tile_script)
				self.add_child(tile)
				tile.set_owner(get_tree().edited_scene_root)
	
	elif 	child_count > tile_count: 
		var to_much : int = child_count - tile_count
		var string1 : String = "Bitte lösche "
		var string2 : String = " Tile oder erhöhe die Tile-anzahl um entsprechend viele"
		print(string1+str(to_much)+string2)
	
	
	pass


# Manipuliert den String so, dass lediglich alle Zahlem im String in ihrer 
# Reihenfolge übrig bleiben und gibt diesen als Ganzzahl aus.
func extract_number_from_name( _node_name: String ) -> int:
	var number_str: String = ""
	
	# Durchlaufe jeden Buchstaben im Namen
	for _char in _node_name:
		# Überprüfe, ob der Buchstabe eine Ziffer ist
		if _char.is_valid_int():
			# Füge die Ziffer zum String hinzu
			number_str += _char
	
	# Konvertiere den resultierenden String in eine ganze Zahl
	var number: int = int(number_str)
	
	return number
