extends Node2D

onready var dirt_tilemap = $DirtPathTileMap
onready var wall_tilemap = $DirtClifTileMap

var rng = RandomNumberGenerator.new()

var CellSize = Vector2(16, 16)
var width = 1024/CellSize.x
var height = 1024/CellSize.y
var grid = []

var Tiles = {
	"empty": -1,
	"wall": 0,
	"floor": 0,
}

func _init_grid():
	grid = []
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(-1)

func GetRandomDirection():
	var directions = [[-1, 0], [1,0], [0,1], [0, -1]]
	var direction = directions[rng.randi()%4]
	return Vector2(direction[0], direction[1])

func _create_random_path():
	var max_iterations = 1000
	var itr = 0
	
	var walker = Vector2.ZERO
	
	while itr < max_iterations:
		
		# Perform random walk
		# 1- choose random direction
		# 2- check that direction is in bounds
		# 3- move in that direction
		var random_direction = GetRandomDirection()
		if (walker.x + random_direction.x >= 0 and
			walker.x + random_direction.x < width and
			walker.y + random_direction.y >= 0 and
			walker.y + random_direction.y < height):
				
				walker += random_direction
				grid[walker.x][walker.y] = Tiles.floor
				itr += 1

func _spawn_tiles():
	for x in width:
		for y in height:
			match grid[x][y]:
				Tiles.empty:
					pass
				Tiles.floor:
					dirt_tilemap.set_cellv(Vector2(x,y), 0)
				Tiles.wall:
					pass
	# Needed to update the autotiling
	dirt_tilemap.update_bitmask_region()
	wall_tilemap.update_bitmask_region()

func _clear_tilemaps():
	for x in width:
		for y in height:
			dirt_tilemap.clear()
			wall_tilemap.clear()
	
	dirt_tilemap.update_bitmask_region()
	wall_tilemap.update_bitmask_region()

func _ready():
	rng.randomize()
	_init_grid()
	_clear_tilemaps()
	_create_random_path()
	_spawn_tiles()

func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		_init_grid()
		_clear_tilemaps()
		_create_random_path()
		_spawn_tiles()
