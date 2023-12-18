@tool
extends GridMap
class_name AutoGridMap

var initial_child_count : int = self.get_child_count()
var point_mesh_library : MeshLibrary

var subgridmap : Node3D
var gridmap_folder_name : String = "Gridmap-Archiv"
var air_item_name : String = "Luft"

var dir_vec 	: Array = range(6)
var dir2_vec 	: Array = range(12)
var dir3_vec 	: Array = range(8)

# Rotations Matrizen
var dir_angle 	: Array = range(4)

func set_cell_item(position: Vector3i, item: int, orientation: int = 0):
	var category : Array = range(2)
	category[0] = "3D"
	category[1] = "2D"
	for _child in self.get_children():
		if _child == subgridmap: pass
		else:
			var gridmaps : Array = subgridmap.get_children()
			if item == -1: 
				for _gridmap in subgridmap.get_children():
					_gridmap.set_cell_item(position,item)
					for _dir in dir_vec:
						var _cell : Vector3i = position + _dir
						var _item : int = self.get_cell_item(_cell)
						if _item != -1:
							self.set_cell_item(_cell,_item)
			elif item == self.mesh_library.find_item_by_name(_child.name):
				if _child.category == category[0]:
					for _gridmap in gridmaps:
						_gridmap.set_cell_item(position,-1)
					handle3d(position,_child)
				elif _child.category == category[1]:
					for _gridmap in gridmaps:
						_gridmap.set_cell_item(position,-1)
					handle2d(position,_child)
	
	pass

func handle3d( _position : Vector3i, _tilemap : Node ):
	var river_item : int 
	var path_item : int 
	var sand_item : int
	var item : int = self.mesh_library.find_item_by_name(_tilemap.name)
	
	if _tilemap.river_tilemap != null: river_item = self.mesh_library.find_item_by_name(_tilemap.river_tilemap.name)
	if _tilemap.path_tilemap != null: path_item = self.mesh_library.find_item_by_name(_tilemap.path_tilemap.name)
	if _tilemap.sand_tilemap != null: sand_item = self.mesh_library.find_item_by_name(_tilemap.sand_tilemap.name)
	
	var river_container : Array = self.get_used_cells_by_item(river_item)
	var path_container : Array = self.get_used_cells_by_item(path_item)
	var sand_container : Array = self.get_used_cells_by_item(sand_item)
	var cell_container : Array = self.get_used_cells_by_item(item)
	
	var cell_container1 : Array = [_position]
	var cell_container2 : Array 
	var cell_container3 : Array 
	
	for _dir in dir_vec	: cell_container1 += [_position + _dir]
	for _dir in dir2_vec: cell_container2 += [_position + _dir]
	for _dir in dir3_vec: cell_container3 += [_position + _dir]
	
	var gridmap : GridMap = subgridmap.find_child(_tilemap.name)
	var trash_container : Array
	var trash_container_iterate : Array
	
	for _cell in cell_container1+cell_container2+cell_container3:
		# Schalter Bibliotheken
		var dir1 : Array = check_3d(_cell,cell_container+river_container+path_container)
		var dir2 : Array = check_3d(_cell,cell_container+river_container+path_container,2)
		var dir3 : Array = check_3d(_cell,cell_container+river_container+path_container,3)
		var dir : Array = dir1 + dir2 + dir3
		trash_container_iterate = range(0)
		
		var tiles : Array 		= _tilemap.get_children()
		var mesh_count : int 	= tiles.size()
		
		# Durch alle definierten Tiles iterieren
		for i in range(mesh_count):
			# Daten des Tiles, des aktuellen Iteriervorgang
			var tile : Array 				= _tilemap.tile_data[i]
			var mesh_name : String 			= tile[0]
			var mesh_index : int			= tile[1]
			var mesh_bools_true : Array 	= tile[2]
			var mesh_bools_false : Array 	= tile[3]
			
			var check : bool = true
			
			for j in range(26):
				if mesh_bools_true[j] and not dir[j]: check = false 
				if mesh_bools_false[j] and dir[j]: check = false
			
			if _cell in cell_container and check:
				gridmap.set_cell_item(_cell,mesh_index)
			
		
	
	pass


func handle2d( _position : Vector3i, _tilemap : Node ):
	var item : int = self.mesh_library.find_item_by_name(_tilemap.name)
	var cell_container : Array = self.get_used_cells_by_item(item)
	var cell_container1 : Array = [_position]
	var cell_container2 : Array 
	for _dir in dir_vec	: cell_container1 += [_position + _dir]
	for _dir in dir2_vec: cell_container2 += [_position + _dir]
	
	cell_container1.remove_at(6)
	cell_container1.remove_at(5)
	cell_container2.remove_at(11)
	cell_container2.remove_at(10)
	cell_container2.remove_at(9)
	cell_container2.remove_at(8)
	cell_container2.remove_at(7)
	cell_container2.remove_at(6)
	cell_container2.remove_at(5)
	cell_container2.remove_at(4)
	
	var gridmap : GridMap = subgridmap.find_child(_tilemap.name)
	var trash_container : Array
	var trash_container_iterate : Array
	
	for _cell in cell_container1+cell_container2:
		# Schalter Bibliotheken
		var dir1 : Array = check_2d(_cell,cell_container)
		var dir2 : Array = check_2d(_cell,cell_container,2)
		var dir : Array = dir1 + dir2
		trash_container_iterate = range(0)
		
		var tiles : Array 		= _tilemap.get_children()
		var mesh_count : int 	= tiles.size()
		
		# Durch alle definierten Tiles iterieren
		for i in range(mesh_count):
			# Daten des Tiles, des aktuellen Iteriervorgang
			var tile : Array 				= _tilemap.tile_data[i]
			var mesh_name : String 			= tile[0]
			var mesh_index : int			= tile[1]
			var mesh_bools_true : Array 	= tile[2]
			var mesh_bools_false : Array 	= tile[3]
			
			var check : bool = true
			
			for j in range(8):
				if mesh_bools_true[j] and not dir[j]: check = false 
				if mesh_bools_false[j] and dir[j]: check = false
			
			if _cell in cell_container and check: 
				gridmap.set_cell_item(_cell,mesh_index)
				print([gridmap,mesh_index,_cell,mesh_name])
		
		pass
	
	pass


func _enter_tree():
	# Einzug
	point_mesh_library 	= MeshLibrary.new()
	point_mesh_library.create_item(0)
	point_mesh_library.set_item_name(0,air_item_name)
	self.mesh_library 	= point_mesh_library
	self.cell_size = Vector3(1,1,1)
	
	subgridmap = get_node_or_null(gridmap_folder_name)
	
	if subgridmap == null:
		subgridmap 			= Node3D.new()
		subgridmap.name 	= gridmap_folder_name
		self.add_child(subgridmap) 
		subgridmap.set_owner(get_tree().edited_scene_root)
		print("Gridmap Archiv wurde neu erstellt")
	
	
	declare_variables()
	
	pass

# Definiert die Richtungsvektoren und die Winkel
func declare_variables():
	var north 	: Vector3i = Vector3i(0,0,-1)
	var east 	: Vector3i = Vector3i(1,0,0)
	var up 		: Vector3i = Vector3i(0,1,0)
	# Rotationsmatrizen
	dir_angle[0] = Basis( east, up, -north )
	dir_angle[1] = Basis( east, up, north )
	dir_angle[2] = Basis( -east, up, north )
	dir_angle[3] = Basis( -east, up, -north )
	# 1
	dir_vec[0] = north
	dir_vec[1] = east
	dir_vec[2] = -north
	dir_vec[3] = -east
	dir_vec[4] = up
	dir_vec[5] = -up
	# 2
	dir2_vec[0] = dir_vec[0] + dir_vec[1]
	dir2_vec[1] = dir_vec[1] + dir_vec[2]
	dir2_vec[2] = dir_vec[2] + dir_vec[3]
	dir2_vec[3] = dir_vec[3] + dir_vec[0]
	dir2_vec[4] = dir_vec[0] + dir_vec[4]
	dir2_vec[5] = dir_vec[1] + dir_vec[4]
	dir2_vec[6] = dir_vec[2] + dir_vec[4]
	dir2_vec[7] = dir_vec[3] + dir_vec[4]
	dir2_vec[8] = dir_vec[0] + dir_vec[5]
	dir2_vec[9] = dir_vec[1] + dir_vec[5]
	dir2_vec[10] = dir_vec[2] + dir_vec[5]
	dir2_vec[11] = dir_vec[3] + dir_vec[5]
	# 3
	dir3_vec[0] = dir_vec[0] + dir_vec[1] + dir_vec[4]
	dir3_vec[1] = dir_vec[1] + dir_vec[2] + dir_vec[4]
	dir3_vec[2] = dir_vec[2] + dir_vec[3] + dir_vec[4]
	dir3_vec[3] = dir_vec[3] + dir_vec[0] + dir_vec[4]
	dir3_vec[4] = dir_vec[0] + dir_vec[1] + dir_vec[5]
	dir3_vec[5] = dir_vec[1] + dir_vec[2] + dir_vec[5]
	dir3_vec[6] = dir_vec[2] + dir_vec[3] + dir_vec[5]
	dir3_vec[7] = dir_vec[3] + dir_vec[0] + dir_vec[5]
	
	pass

# Erstellt den Luftpinsel für das Autogridmap
func create_air_item():
	point_mesh_library.create_item(0)
	point_mesh_library.set_item_name(0,"Luft")
	pass


func _ready():
	self.child_entered_tree.connect(_child_entered_tree)
	self.child_exiting_tree.connect(_child_exiting_tree)
	
	pass

# Erzeugt ein Gridmap, falls ein neues Tileset definiert wird
func _child_entered_tree( _child : Node ):
	print([_child,_child.name])
	if _child == subgridmap: return
	else:
		var check : bool = true
		for _gridmap in subgridmap.get_children():
			if _child.name == _gridmap.name: check = false
			
		if check:
			var new_gridmap : GridMap = GridMap.new()
			new_gridmap.name = _child.name
			new_gridmap.cell_size = Vector3(1,1,1)
			new_gridmap.mesh_library = _child.mesh_library3D
			subgridmap.add_child(new_gridmap)
			new_gridmap.set_owner(get_tree().edited_scene_root)
			
		var i = point_mesh_library.get_last_unused_item_id()
		point_mesh_library.create_item(i)
		point_mesh_library.set_item_name(i,_child.name)
		
		if not _child.is_connected("renamed",_child_renamed.bind(_child)):
			_child.renamed.connect(_child_renamed.bind(_child))
			
		
		pass
	
	pass

# Entfernt die zugehörige Gridmap, falls ein Tileset gelöscht wird
func _child_exiting_tree( _child : Node ):
	if _child == subgridmap: print("Das hätte nicht passieren sollen :/")
	else:
		var tilemap_name : String 	= _child.name
		var gridmap : GridMap 		= subgridmap.find_child(tilemap_name)
		#gridmap.free() # Überdenken
		var index : int = point_mesh_library.find_item_by_name(tilemap_name)
		point_mesh_library.remove_item(index)
		
		pass
	
	pass

# Funktioniert nicht
func _gridmap_renamed( _gridmap : GridMap ):
	for _child in self.get_children():
		if _child == subgridmap: pass
		else:
			if _child.mesh_library3D == _gridmap.mesh_library:
				var output : String = "Name vom Tileset wurde an Gridmap angepasst, von und zu: " + String(_child.name) + " -> " + String(_gridmap.name)
				print(output)
				_child.name = _gridmap.name

# Gleicht den Namen des zugehörigen Gridmaps an, falls ein Tileset umgetauft wird
func _child_renamed( _child : Node ):
	for _gridmap in subgridmap.get_children():
		if _gridmap.mesh_library == _child.mesh_library3D:
			if _gridmap.name == _child.name: pass
			else:
				var output : String = "Name vom Gridmap wurde an Tileset angepasst, von und zu: " + String(_gridmap.name) + " -> " + String(_child.name)
				var index : int = point_mesh_library.find_item_by_name(_gridmap.name)
				point_mesh_library.set_item_name(index,_child.name)
				print(_gridmap.name)
				print(output)
				_gridmap.name = _child.name


func _process(delta):
	for _gridmaps in subgridmap.get_children():
		for _child in self.get_children():
			if _gridmaps.name == _child.name:
				_gridmaps.mesh_library = _child.mesh_library3D

# Verwaltet das platztieren von Luft
func handle_air( _cell_container : Array ):
	for _gridmap in self.subgridmap.get_children():
		for _cell in _cell_container:
			_gridmap.set_cell_item(_cell, -1)
			pass	
		pass
	pass

# Überprüft die Nachbarzellen für die 2D-Kategorie
func check_2d( _cell : Vector3i, _cell_container : Array, _count : int = 1 ) -> Array:
	var output : Array
	
	if _count 		== 1: 
		output = range(4)
		for i in range(4):
			if _cell + dir_vec[i] in _cell_container: 	output[i] = true
			else: 										output[i] = false
		output
	
	elif _count 	== 2:
		output = range(4)
		for i in range(4):
			if _cell + dir2_vec[i] in _cell_container: 	output[i] = true
			else: 										output[i] = false
		
	
	return output
	pass

# Überprüft die Nachbarzellen für die 3D-Kategorie
func check_3d( _cell : Vector3i, _cell_container : Array, _count : int = 1 ) ->Array:
	var output : Array
	
	if _count 		== 1:
		output = range(6)
		for i in range(6):
			if _cell + dir_vec[i] in _cell_container: 	output[i] = true
			else: 										output[i] = false
		
	
	elif _count 	== 2: 
		output = range(12)
		for i in range(12):
			if _cell + dir2_vec[i] in _cell_container: 	output[i] = true
			else: 										output[i] = false
		
	
	elif _count 	== 3: 
		output = range(8)
		for i in range(8):
			if _cell + dir3_vec[i] in _cell_container: 	output[i] = true
			else: 										output[i] = false
		
	
	return output
	pass
