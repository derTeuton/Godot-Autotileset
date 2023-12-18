# Godot-Autotileset

mit Godot 4.2 erstellt:
https://godotengine.org/download/windows/

unter zuhilfenahme des Kenney Nature Kit erstelllt:
https://kenney.nl/assets/nature-kit


Das Plugin stellt 5 neue Nodes zur Verwendung bereit
The Plugin adds 5 new Nodes

1. AutoGridMap
2. Tilemap_3D
3. Tilemap_2D
4. Tile_3D
5. Tile_2D


Das Node 'Autogridmap' erzeugt nach betreten der Szene ein Node3D als Kind in welchem für jedes Tilemap ein eigenes GridMap angelegt wird.

![image](https://github.com/derTeuton/Godot-Autotileset/assets/46108494/bc30bb05-1b3f-4838-a585-9016a63b10d4)

Als nächstes erzeugt es für jedes Tilemap (2D & 3D) das besagt GridMap.

![image](https://github.com/derTeuton/Godot-Autotileset/assets/46108494/c8cdffb3-c55f-4777-930a-c0485eb9577f)

Zu guter Letzt legt es für jedes Tilemap ein 'Mesh' im eigenem Mesh_Library an.

![image](https://github.com/derTeuton/Godot-Autotileset/assets/46108494/36bcaf06-f065-47bd-acf7-249e99deaa81)

nun kann man auf dem AutoGridMap Malen und das script platztiert die jeweiligen Meshes auf den jeweiligen Gridmaps


ein Tilemap liefert lediglich das Mesh_Library für seine Kategorie. 

ein Tile speichert die verbindungen die ein Tile haben soll und nicht haben soll.
