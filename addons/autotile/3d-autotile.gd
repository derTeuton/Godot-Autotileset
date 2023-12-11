@tool
extends GridMap
class_name AutoGridMap

# User input
@export var environment1 : MeshLibrary
@export var environment2 : MeshLibrary
@export var river1 : MeshLibrary
@export var path1 : MeshLibrary
@export var refresh : bool = false

# Point Meshes
var air : int
var river : int
var path : int
var rock : int
var stone : int
var all_categories : Array

# Untergridmap
var sub_gridmap_environment1 : GridMap
var sub_gridmap_environment2 : GridMap
var sub_gridmap_river1 : GridMap
var sub_gridmap_path1 : GridMap
var sub_gridmaps : Array

# Gridmap Strings
var rock_name : String = "Gelände 1"
var stone_name : String = "Gelände 2"
var river_name : String = "Fluß"
var path_name : String = "Weg"

# World Meshes categorized
var river_mesh_container : Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
var path_mesh_container : Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
var rock_mesh_container : Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
var rock_cliff_mesh_container : Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
var stone_mesh_container : Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
var stone_cliff_mesh_container : Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]

# Haupthimmelsrichtungen
var north : bool = false
var north_vec : Vector3i = Vector3i(0,0,-1)
var east : bool = false
var east_vec : Vector3i = Vector3i(1,0,0)
var south : bool = false
var south_vec : Vector3i = -north_vec
var west : bool = false
var west_vec : Vector3i = -east_vec
var up : bool = false
var up_vec : Vector3i = Vector3i(0,1,0)
var down : bool = false
var down_vec : Vector3i = -up_vec

# Rotation as Matrix
var north_angle : Basis = Basis( Vector3(1,0,0), Vector3(0,1,0), Vector3(0,0,1) )
var east_angle : Basis = Basis( Vector3(0,0,1), Vector3(0,1,0), Vector3(-1,0,0) )
var south_angle : Basis = Basis( Vector3(-1,0,0), Vector3(0,1,0), Vector3(0,0,-1) )
var west_angle : Basis = Basis( Vector3(0,0,-1), Vector3(0,1,0), Vector3(1,0,0) )

# Nebenhimmelsrichtungen
var northeast : bool = false
var northeast_vec : Vector3i = north_vec + east_vec
var southeast : bool = false
var southeast_vec : Vector3i = south_vec + east_vec
var southwest : bool = false
var southwest_vec : Vector3i = south_vec + west_vec
var northwest : bool = false
var northwest_vec : Vector3i = north_vec + west_vec
var northup : bool = false
var northup_vec : Vector3i = Vector3i(0,0,-1) + up_vec
var eastup : bool = false
var eastup_vec : Vector3i = Vector3i(1,0,0) + up_vec
var southup : bool = false
var southup_vec : Vector3i = up_vec - north_vec
var westup : bool = false
var westup_vec : Vector3i = up_vec - east_vec
var northdown : bool = false
var northdown_vec : Vector3i = Vector3i(0,0,-1) + down_vec
var eastdown : bool = false
var eastdown_vec : Vector3i = Vector3i(1,0,0) + down_vec
var southdown : bool = false
var southdown_vec : Vector3i = down_vec - north_vec
var westdown : bool = false
var westdown_vec : Vector3i = down_vec - east_vec

# Eckenhrichtungen
var northeastup : bool = false
var northeastup_vec : Vector3i = north_vec + east_vec + up_vec
var southeastup : bool = false
var southeastup_vec : Vector3i = south_vec + east_vec + up_vec
var southwestup : bool = false
var southwestup_vec : Vector3i = south_vec + west_vec + up_vec
var northwestup : bool = false
var northwestup_vec : Vector3i = north_vec + west_vec + up_vec
var northeastdown : bool = false
var northeastdown_vec : Vector3i = north_vec + east_vec + down_vec
var southeastdown : bool = false
var southeastdown_vec : Vector3i = south_vec + east_vec + down_vec
var southwestdown : bool = false
var southwestdown_vec : Vector3i = south_vec + west_vec + down_vec
var northwestdown : bool = false
var northwestdown_vec : Vector3i = north_vec + west_vec + down_vec

var dir : Array 		= [ north, east, south, west, up, down ]
var dir_vec : Array 	= [ north_vec, east_vec, south_vec, west_vec, up_vec, down_vec ]
var dir_angle : Array 	= [ north_angle, east_angle, south_angle, west_angle ]

var dir2 : Array 		= [ northeast, southeast, southwest, northwest, northup, eastup, southup, westup, northdown, eastdown, southdown, westdown ]
var dir2_vec : Array 	= [ northeast_vec, southeast_vec, southwest_vec, northwest_vec, northup_vec, eastup_vec, southup_vec, westup_vec, northdown_vec, eastdown_vec, southdown_vec, westdown_vec ]

var dir3 : Array 		= [ northeastup, southeastup, southwestup, northwestup, northeastdown, southeastdown, southwestdown, northwestdown ]
var dir3_vec : Array 	= [ northeastup_vec, southeastup_vec, southwestup_vec, northwestup_vec, northeastdown_vec, southeastdown_vec, southwestdown_vec, northwestdown_vec ]


# Listen für die Zellenkontrolle 2D
var first_check_2D : Array = [ north_vec, east_vec, south_vec, west_vec ]
var second_check_2D : Array = [ northeast_vec, southeast_vec, southwest_vec, northwest_vec ]

# Listen für die Zellenkontrolle 3D
var first_check_3D : Array = [ north_vec, east_vec, south_vec, west_vec, up_vec, down_vec ]
var second_check_3D : Array = [ northeast_vec, southeast_vec, southwest_vec, northwest_vec, northup_vec, eastup_vec, southup_vec, westup_vec, northdown_vec, eastdown_vec, southdown_vec, westdown_vec ]
var third_check_3D : Array = [ northeastup_vec, southeastup_vec, southwestup_vec, northwestup_vec, northeastdown_vec, southeastdown_vec, southwestdown_vec, northwestdown_vec ]


# Erhält die Indexierung der pointmesh Bibliothek
func _handle_variables():
	air = self.mesh_library.find_item_by_name("Luft")
	river = self.mesh_library.find_item_by_name("Fluß")
	rock = self.mesh_library.find_item_by_name("Gelände")
	path = self.mesh_library.find_item_by_name("Weg")
	stone = self.mesh_library.find_item_by_name("Gestein")
	all_categories = [air, river, path, rock, stone]
	_handle_mesh_container()
	print("Variablen aktualisiert")
	pass

# Erzeugt die Untergridmap
func _handle_subgridmap( sub_gridmap : GridMap, mesh_library_3d : MeshLibrary, _name : String ):
	if sub_gridmap == null:
		sub_gridmap = GridMap.new()
		sub_gridmap.name = _name
		sub_gridmap.cell_size = Vector3(1,1,1)
		sub_gridmap.mesh_library = mesh_library_3d
		self.add_child(sub_gridmap)
		sub_gridmap.set_owner(get_tree().edited_scene_root)
		pass

# Wird aufgerufen sobald die AutoGridMap der Szene hinzugefügt wird
func _enter_tree():
	self.cell_size = Vector3(1,1,1)
	self.changed.connect(_handle_variables)
	
	pass


func _process(delta):
	for library in [ environment1,environment2,river1,path1,self.mesh_library ]:
		if library == null:
			return
	
	#_handle_variables()
	
	sub_gridmap_environment1 = get_node_or_null(rock_name)
	sub_gridmap_environment2 = get_node_or_null(stone_name)
	sub_gridmap_river1 = get_node_or_null(river_name)
	sub_gridmap_path1 = get_node_or_null(path_name)
	
	sub_gridmaps = [ sub_gridmap_environment1, sub_gridmap_environment2, sub_gridmap_river1, sub_gridmap_path1 ]
	
	if sub_gridmap_environment1 == null:
		_handle_subgridmap(sub_gridmap_environment1,environment1,rock_name)
	if sub_gridmap_environment2 == null:
		_handle_subgridmap(sub_gridmap_environment2,environment2,stone_name)
	if sub_gridmap_river1 == null:
		_handle_subgridmap(sub_gridmap_river1,river1,river_name)
	if sub_gridmap_path1 == null:
		_handle_subgridmap(sub_gridmap_path1,path1,path_name)
	
	if refresh:
		_handle_categories(all_categories)
		pass
	
	pass

func _handle_mesh_container():
	_handle_river1_mesh()
	_handle_path1_mesh()
	_handle_environment1_mesh()
	_handle_environment2_mesh()
	
	pass

func _handle_river1_mesh():
	river_mesh_container[0] 		= river1.find_item_by_name("0-way-river")
	river_mesh_container[1] 		= river1.find_item_by_name("1-way-river")
	river_mesh_container[2] 		= river1.find_item_by_name("2-way-curve-river")
	river_mesh_container[3] 		= river1.find_item_by_name("2-way-straight-river")
	river_mesh_container[4] 		= river1.find_item_by_name("3-way-corner-river")
	river_mesh_container[5] 		= river1.find_item_by_name("3-way-cross-river")
	river_mesh_container[6] 		= river1.find_item_by_name("4-way-river")
	river_mesh_container[7] 		= river1.find_item_by_name("4-way-mirror-river")
	river_mesh_container[8] 		= river1.find_item_by_name("5-way-edge-river")
	river_mesh_container[9] 		= river1.find_item_by_name("4-way-cross-river")
	river_mesh_container[10] 		= river1.find_item_by_name("5-way-river")
	river_mesh_container[11] 		= river1.find_item_by_name("6-way-river")
	river_mesh_container[12] 		= river1.find_item_by_name("6-way-opposite-river")
	river_mesh_container[13] 		= river1.find_item_by_name("7-way-river")
	river_mesh_container[14] 		= river1.find_item_by_name("8-way-river")
	
	pass

func _handle_path1_mesh():
	path_mesh_container[0] 			= path1.find_item_by_name("0-way-path")
	path_mesh_container[1] 			= path1.find_item_by_name("1-way-path")
	path_mesh_container[2] 			= path1.find_item_by_name("2-way-curve-path")
	path_mesh_container[3] 			= path1.find_item_by_name("2-way-straight-path")
	path_mesh_container[4] 			= path1.find_item_by_name("3-way-corner-path")
	path_mesh_container[5] 			= path1.find_item_by_name("3-way-cross-path")
	path_mesh_container[6] 			= path1.find_item_by_name("4-way-path")
	path_mesh_container[7] 			= path1.find_item_by_name("4-way-mirror-path")
	path_mesh_container[8] 			= path1.find_item_by_name("5-way-edge-path")
	path_mesh_container[9] 			= path1.find_item_by_name("4-way-cross-path")
	path_mesh_container[10] 		= path1.find_item_by_name("5-way-path")
	path_mesh_container[11] 		= path1.find_item_by_name("6-way-path")
	path_mesh_container[12] 		= path1.find_item_by_name("6-way-opposite-path")
	path_mesh_container[13] 		= path1.find_item_by_name("7-way-path")
	path_mesh_container[14] 		= path1.find_item_by_name("8-way-path")
	
	pass

func _handle_environment1_mesh():
	rock_mesh_container[0] 			= environment1.find_item_by_name("0-way-rock")
	rock_cliff_mesh_container[0] 	= environment1.find_item_by_name("0-way-cliff-rock")
	rock_mesh_container[1] 			= environment1.find_item_by_name("1-way-rock")
	rock_cliff_mesh_container[1] 	= environment1.find_item_by_name("1-way-cliff-rock")
	rock_mesh_container[2] 			= environment1.find_item_by_name("2-way-straight-rock")
	rock_cliff_mesh_container[2] 	= environment1.find_item_by_name("2-way-straight-cliff-rock")
	rock_mesh_container[3] 			= environment1.find_item_by_name("2-way-curve-rock")
	rock_cliff_mesh_container[3] 	= environment1.find_item_by_name("2-way-curve-cliff-rock")
	rock_mesh_container[4] 			= environment1.find_item_by_name("3-way-edge-rock")
	rock_cliff_mesh_container[4] 	= environment1.find_item_by_name("3-way-edge-cliff-rock")
	rock_mesh_container[5] 			= environment1.find_item_by_name("5-way-rock")
	rock_cliff_mesh_container[5] 	= environment1.find_item_by_name("5-way-cliff-rock")
	rock_mesh_container[6] 			= environment1.find_item_by_name("5-way-right-cliff-rock")
	rock_cliff_mesh_container[6] 	= environment1.find_item_by_name("ground")
	rock_mesh_container[7] 			= environment1.find_item_by_name("5-way-left-cliff-rock")
	rock_cliff_mesh_container[7] 	= environment1.find_item_by_name("")
	rock_mesh_container[8] 			= environment1.find_item_by_name("1-way-diagonal-rock")
	rock_cliff_mesh_container[8] 	= environment1.find_item_by_name("1-way-diagonal-cliff-rock")
	rock_mesh_container[9] 			= environment1.find_item_by_name("2-way-diagonal-rock")
	rock_cliff_mesh_container[9] 	= environment1.find_item_by_name("2-way-diagonal-cliff-rock")
	rock_mesh_container[10] 		= environment1.find_item_by_name("5-way-diagonal-rock")
	rock_cliff_mesh_container[10] 	= environment1.find_item_by_name("5-way-diagonal-cliff-rock")
	rock_mesh_container[11] 		= environment1.find_item_by_name("4-way-diagonal-left-rock")
	rock_cliff_mesh_container[11] 	= environment1.find_item_by_name("4-way-diagonal-left-cliff-rock")
	rock_mesh_container[12] 		= environment1.find_item_by_name("4-way-diagonal-right-rock")
	rock_cliff_mesh_container[12] 	= environment1.find_item_by_name("4-way-diagonal-right-cliff-rock")
	rock_mesh_container[13] 		= environment1.find_item_by_name("3-way-cross-rock")
	rock_cliff_mesh_container[13] 	= environment1.find_item_by_name("3-way-cross-cliff-rock")
	rock_mesh_container[14] 		= environment1.find_item_by_name("3-way-cross-diagonal-rock")
	rock_cliff_mesh_container[14] 	= environment1.find_item_by_name("3-way-cross-diagonal-cliff-rock")
	rock_mesh_container[15] 		= environment1.find_item_by_name("4-way-cross-diagonal-rock")
	rock_cliff_mesh_container[15] 	= environment1.find_item_by_name("4-way-cross-diagonal-cliff-rock")
	rock_mesh_container[16] 		= environment1.find_item_by_name("6-way-diagonal-rock")
	rock_cliff_mesh_container[16] 	= environment1.find_item_by_name("6-way-diagonal-cliff-rock")
	
	pass

func _handle_environment2_mesh():
	stone_mesh_container[0] 		= environment2.find_item_by_name("")
	
	pass

# Verwaltet die einzelnen Tilesets
func _handle_categories( _categorie_container : Array ):
	for categorie in _categorie_container:
		var air_container : Array = self.get_used_cells_by_item(air)
		var river1_container : Array = self.get_used_cells_by_item(river)
		var path1_container : Array = self.get_used_cells_by_item(path)
		var rock_container : Array = self.get_used_cells_by_item(rock)
		var stone_container : Array = self.get_used_cells_by_item(stone)
		if categorie == air:
			_handle_air(air_container)
		elif categorie == river:
			river1_container
			_handle_2d( river1_container,river_mesh_container,sub_gridmap_river1 )
			pass
		elif categorie == path:
			_handle_2d( path1_container,path_mesh_container,sub_gridmap_path1 )
			pass
		elif categorie == rock:
			_handle_3d( rock_container,river1_container,path1_container,rock_mesh_container,rock_cliff_mesh_container,sub_gridmap_environment1 )
			
			pass
		elif categorie == stone:
#			_handle_environment_cell(rock_container, cliff_rock_mesh_container, rock_mesh_container)
			pass
		pass
	pass

# löscht die Zellen die mit Luft gefüllt worden sind
func _handle_air( _cells : Array ):
	for gridmaps in sub_gridmaps:
		for cell in _cells:
			gridmaps.set_cell_item(cell, -1)
			pass
		pass
	pass

# Bestimmt die Himmelsrichtung die ein gegebener normierter Vektor hat 
func _get_orientation( _dir_vec : Vector3i, _bool : bool = true ):
	# 1
	for index in [0,1,2,3,4,5]:
		if _dir_vec == dir_vec[index]:
			dir[index] = _bool
	
	# 2
	for index in [0,1,2,3,4,5,6,7,8,9,10,11]:
		if _dir_vec == dir2_vec[index]:
			dir2[index] = _bool
	
	# 3
	for index in [0,1,2,3,4,5,6,7]:
		if _dir_vec == dir3_vec[index]:
			dir3[index] = _bool
	pass

# Platziert eine Zelle
func _place_cell( gridmap : GridMap, _position : Vector3i, _mesh : int, _orientation : Basis = north_angle ):
	for gridmaps in sub_gridmaps:
		if gridmaps != gridmap:
			gridmaps.set_cell_item( _position, -1 )
			pass
		pass
	gridmap.set_cell_item( _position, _mesh, get_orthogonal_index_from_basis(_orientation) ) 
	pass
#
## Platziert eine Zelle für 3D Tiles
#func _place_cell_3d( gridmap : GridMap, _position : Vector3i, _cell_container : Array, _mesh1 : int, _mesh2 : int, _mesh_container : Array, _cliff_mesh_container : Array, _orientation : Basis = north_angle ):
#	var k : int = 0
#	var iterate : bool = true
#	var _mesh : int
#
#	for gridmaps in sub_gridmaps:
#		while iterate:
#			if _position + k * down_vec in _cell_container:
#				if gridmaps == gridmap:
#					if k == 0:
#						_mesh = _mesh1
#					else:
#						_mesh = _mesh2
#						_handle_3d(_cell_container,_mesh_container,_cliff_mesh_container,gridmap)
#						pass
#					gridmap.set_cell_item( _position + k * down_vec, _mesh, get_orthogonal_index_from_basis(_orientation) )
#					pass
#				else:
#					gridmaps.set_cell_item( _position + k * down_vec, -1 )
#					pass
#				k += 1
#				pass
#			else:
#				iterate = false
#				pass
#			pass
#		pass
#	pass

func _handle_3d( _cell_container : Array, _river_cell_container : Array, _path_cell_container : Array, _mesh_container : Array, _cliff_mesh_container : Array, _gridmap : GridMap ):
	for _cell in _cell_container:
		_false_variables()
		var cell_container : Array = _river_cell_container + _path_cell_container
		_check_variables(_cell,_cell_container,cell_container)
		#print([dir, _cell])
		
		if dir[4]: pass # dir[4] = up
		else: _place_cell( _gridmap, _cell,_cliff_mesh_container[6] ) # Boden
		
		for i in [0,1,2,3]:
			# die vier Himmelsrichtungen
			var index1 : int = (i+0) % 4
			var index2 : int = (i+1) % 4
			var index3 : int = (i+2) % 4
			var index4 : int = (i+3) % 4
			
			# 0-way
			if not dir[index1] and not dir[index2] and not dir[index3] and not dir[index4]:
				#print([_cell, dir2[0], dir2[1], dir2[2], dir2[3], dir[4]])
				# 0-way
				if not dir2[index1] and not dir2[index2] and not dir2[index3] and not dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[0], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[0], dir_angle[index1]  ) 
				# 1-way-diagonal
				elif dir2[index1] and not dir2[index2] and not dir2[index3] and not dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[8], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[8], dir_angle[index1]  ) 
				# 2-way-diagonal
				elif dir2[index1] and not dir2[index2] and dir2[index3] and not dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[9], dir_angle[index1]  )
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[9], dir_angle[index1]  )
				# 2-way-curve-diagonal
				elif dir2[index1] and dir2[index2] and not dir2[index3] and not dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[-1], dir_angle[index1]  )
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[-1], dir_angle[index1]  ) 
				# 3-way-diagonal
				elif dir2[index1] and dir2[index2] and dir2[index3] and not dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[-1], dir_angle[index1]  )
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[-1], dir_angle[index1]  ) 
				# 4-way-diagonal
				elif dir2[index1] and dir2[index2] and dir2[index3] and dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[15], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[15], dir_angle[index1]  ) 
			 
			# 1-way
			elif dir[index1] and not dir[index2] and not dir[index3] and not dir[index4]:
				if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[1], dir_angle[index1]  ) # Wand
				else: _place_cell( _gridmap, _cell, _cliff_mesh_container[1], dir_angle[index1]  ) # Klippe
			
			# 2-way-straight
			elif dir[index1] and not dir[index2] and dir[index3] and not dir[index4]:
				if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[2], dir_angle[index1]  ) # Wand-Kante
				else: _place_cell( _gridmap, _cell, _cliff_mesh_container[2], dir_angle[index1]  ) # Klippe-Kante
			
			
			elif dir[index1] and dir[index2] and not dir[index3] and not dir[index4]:
				# 2-way-curve
				if not dir2[index1]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[3], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[3], dir_angle[index1]  )
				# 3-way-edge
				elif dir2[index1] and not dir2[index2] and not dir2[index3] and not dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[4], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[4], dir_angle[index1]  ) 
				# 5-way-diagonal 
				elif dir2[index1] and dir2[index2] and not dir2[index3] and dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[10], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[10], dir_angle[index1]  ) 
				# 4-way-diagonal-left
				elif dir2[index1] and not dir2[index2] and dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[11], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[11], dir_angle[index1]  ) 
				# 4-way-diagonal-right
				elif dir2[index1] and dir2[index2] and not dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[12], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[12], dir_angle[index1]  ) 
				# 3-way-cross-diagonal
				if not dir2[index1] and dir2[index3]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[14], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[14], dir_angle[index1]  ) 
				#print([_cell, dir2[0], dir2[1], dir2[2], dir2[3]])
				# 6-way-diagonal 
				if dir2[index1] and dir2[index2] and dir2[index3] and dir2[index4]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[16], dir_angle[index1]  ) 
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[16], dir_angle[index1]  ) 
				
			
			
			elif  dir[index1] and dir[index2] and dir[index3] and not dir[index4]:
				# 5-way (half)
				if dir[4] and dir2[4+index1] and dir2[4+index3]: 
					_place_cell( _gridmap, _cell, _mesh_container[5], dir_angle[index1]  )
				elif dir[4] and not dir2[4+index1] and dir2[4+index3]: 
					_place_cell( _gridmap, _cell, _mesh_container[6], dir_angle[index1]  )
				elif dir[4] and dir2[4+index1] and not dir2[4+index3]: 
					_place_cell( _gridmap, _cell, _mesh_container[7], dir_angle[index1]  ) 
				elif not dir[4]: _place_cell( _gridmap, _cell, _cliff_mesh_container[5], dir_angle[index1]  ) 
				
				# 3-way-cross
				if not dir2[index1] and not dir2[index2]:
					if dir[4]: _place_cell( _gridmap, _cell, _mesh_container[13], dir_angle[index1]  )
					else: _place_cell( _gridmap, _cell, _cliff_mesh_container[13], dir_angle[index1]  )
			
			pass
			pass
		
		pass
	pass

func _check_variables( _cell : Vector3i, _cell_container : Array, _ignore_cell_container : Array ):
	var check_container : Array = _cell_container + _ignore_cell_container
	for index in [0,1,2,3,4,5]:
		if _cell + dir_vec[index] in check_container:
			dir[index] = true
	for index in [0,1,2,3,4,5,6,7,8,9,10,11]:
		if _cell + dir2_vec[index] in check_container:
			dir2[index] = true
	for index in [0,1,2,3,4,5,6,7]:
		if _cell + dir3_vec[index] in check_container:
			dir3[index] = true
	pass

# Regelt alle Tiles die 2D funktionieren sollen
func _handle_2d( _cell_container : Array, _mesh_container : Array, _gridmap : GridMap ):
	for _cell in _cell_container:
		_false_variables()
		_check_variables(_cell,_cell_container,[  ])
		
		for i in [0,1,2,3]:
			# die vier Himmelsrichtungen
			var index1 : int = (i+0) % 4
			var index2 : int = (i+1) % 4
			var index3 : int = (i+2) % 4
			var index4 : int = (i+3) % 4
			# 0-way
			if not dir[index1] and not dir[index2] and not dir[index3] and not dir[index4]:
				_place_cell(_gridmap,_cell,_mesh_container[0])
				pass
			# 1-way
			elif dir[index1] and not dir[index2] and not dir[index3] and not dir[index4]:
				_place_cell(_gridmap,_cell,_mesh_container[1],dir_angle[index1])
			# 2-way-straight
			elif dir[index1] and not dir[index2] and dir[index3] and not dir[index4]:
				_place_cell(_gridmap,_cell,_mesh_container[3],dir_angle[index1])
			
			elif dir[index1] and dir[index2] and not dir[index3] and not dir[index4]:
				# 2-way-curve
				if not dir2[index1]:
					_place_cell(_gridmap,_cell,_mesh_container[2],dir_angle[index1])
				# 3-way-corner
				elif dir2[index1]:
					_place_cell(_gridmap,_cell,_mesh_container[4],dir_angle[index1])
			
			elif dir[index1] and dir[index2] and dir[index3] and not dir[index4]:
				# 3-way-cross
				if not dir2[index1] and not dir2[index2]:
					_place_cell(_gridmap,_cell,_mesh_container[5],dir_angle[index1])
				# 4-way
				elif dir2[index1] and not dir2[index2]:
					_place_cell(_gridmap,_cell,_mesh_container[6],dir_angle[index1])
				# 4-way-mirror
				elif not dir2[index1] and dir2[index2]:
					_place_cell(_gridmap,_cell,_mesh_container[7],dir_angle[index1])
				# 5-way-edge
				elif dir2[index1] and dir2[index2]:
					_place_cell(_gridmap,_cell,_mesh_container[8],dir_angle[index1])
			
			elif dir[index1] and dir[index2] and dir[index3] and dir[index4]:
				# 4-way-cross
				if not dir2[index1] and not dir2[index2] and not dir2[index3] and not dir2[index4]:
					_place_cell(_gridmap,_cell,_mesh_container[9],dir_angle[index1])
				# 5-way
				elif dir2[index1] and not dir2[index2] and not dir2[index3] and not dir2[index4]:
					_place_cell(_gridmap,_cell,_mesh_container[10],dir_angle[index1])
				# 6-way
				elif dir2[index1] and dir2[index2] and not dir2[index3] and not dir2[index4]:
					_place_cell(_gridmap,_cell,_mesh_container[11],dir_angle[index1])
				# 6-way-opposite
				elif dir2[index1] and not dir2[index2] and dir2[index3] and not dir2[index4]:
					_place_cell(_gridmap,_cell,_mesh_container[12],dir_angle[index1])
				# 7-way
				elif dir2[index1] and dir2[index2] and dir2[index3] and not dir2[index4]:
					_place_cell(_gridmap,_cell,_mesh_container[13],dir_angle[index1])
				# 8-way
				elif dir2[index1] and dir2[index2] and dir2[index3] and dir2[index4]:
					_place_cell(_gridmap,_cell,_mesh_container[14],dir_angle[index1])
		pass
	pass
#
## Frägt die Nachbar Zellen kategorien ab
#func _neighbour_check( _cell : Vector3i, _cell_container : Array, _level : int = 0, _3d : bool = true) -> Vector3i:
	#var way1 : int = 0
	#var way2 : int = 0
	#var way3 : int = 0
	#if _3d:
		#if _level == 0:
			#for dir in first_check_3D:
				#if _cell + dir in _cell_container:
					#_get_orientation(dir)
					#way1 += 1
					#pass
				#pass
			#for dir in second_check_3D:
				#if _cell + dir in _cell_container:
					#_get_orientation(dir)
					#way2 += 1
					#pass
				#pass
			#for dir in third_check_3D:
				#if _cell + dir in _cell_container:
					#_get_orientation(dir)
					#way3 += 1
					#pass
				#pass
			#pass
		#elif _level == 1:
			#for dir in first_check_2D:
				#if _cell + dir + down_vec  in _cell_container:
					#way1 += 1
					#pass
				#pass
			#for dir in second_check_2D:
				#if _cell + dir + down_vec in _cell_container:
					#way2 += 1
					#pass
				#pass
			#pass
		#elif _level == 2:
			#for dir in first_check_2D:
				#if _cell + dir  in _cell_container:
					#way1 += 1
					#pass
				#pass
			#for dir in second_check_2D:
				#if _cell + dir in _cell_container:
					#way2 += 1
					#pass
				#pass
			#pass
		#elif _level == 3:
			#for dir in first_check_2D:
				#if _cell + dir + up_vec in _cell_container:
					#way1 += 1
					#pass
				#pass
			#for dir in second_check_2D:
				#if _cell + dir + up_vec in _cell_container:
					#way2 += 1
					#pass
				#pass
			#pass
		#pass
	#else:
		#for dir in first_check_2D:
			#if _cell + dir in _cell_container:
				#_get_orientation(dir)
				#way1 += 1
				#pass
			#pass
		#for dir in second_check_2D:
			#if _cell + dir in _cell_container:
				#_get_orientation(dir)
				#way2 += 1
				#pass
			#pass
		#pass
	#
	#return Vector3i(way1,way2,way3)
	#pass

# Setzt alle 26 Schalter auf false
func _false_variables():
	# Haupthimmelsrichtungen
	for index in [0,1,2,3,4,5]:
		dir[index] = false
	#Nebenhimmelsrichtunen
	for index in [0,1,2,3,4,5,6,7,8,9,10,11]:
		dir2[index] = false
	#Eckenrichtungen
	for index in [0,1,2,3,4,5,6,7]:
		dir3[index] = false
	pass
