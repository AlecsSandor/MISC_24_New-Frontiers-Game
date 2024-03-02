extends Node3D

var ground_scene = preload("res://scenes/ground.tscn")
var water_scene = preload("res://scenes/water_ground.tscn")
var pond_scene = preload("res://scenes/pond_ground.tscn")
var static_ground_scene = preload("res://scenes/static_ground.tscn")

var cliff_scene = preload("res://scenes/cliff.tscn")
var mountain_scene = preload("res://scenes/mountain.tscn")
var mountain_square_scene = preload("res://scenes/mountainSquare.tscn")
var pine_scene = preload("res://scenes/pine.tscn")
var pine_scene2 = preload("res://scenes/pine2.tscn")
var pine_scene3 = preload("res://scenes/pine3.tscn")
var nativeCamp_scene = preload("res://scenes/nativeCamp.tscn")
var irishHouse_scene = preload("res://scenes/irishHouse.tscn")
var irishHouse2_scene = preload("res://scenes/irishHouse2.tscn")
var irishHouse3_scene = preload("res://scenes/irishHouse3.tscn")
var church_scene = preload("res://scenes/church.tscn")


var stone_wall_1side_01_scene = preload("res://scenes/stone_wall_1side_01.tscn")
var stone_wall_1side_02_scene = preload("res://scenes/stone_wall_1side_02.tscn")
var bush_wall_1side_01_scene = preload("res://scenes/bush_wall_1side_01.tscn")
var bush_wall_1side_02_scene = preload("res://scenes/bush_wall_1side_02.tscn")
var structure_trees_rocks_scene = preload("res://scenes/structure_trees&rocks.tscn")
var flowers_scene = preload("res://scenes/flowers.tscn")

var npc_scene = preload("res://scenes/npc.tscn")
var sheeps = preload("res://scenes/sheeps.tscn")

var pine_shader_material = preload("res://materials/pineWind.tres") 
var outline_material = preload("res://materials/outlineShaderMaterial.tres")

var numberOfBuidlings = 2

@onready var player = $Player
#@onready var player_position = $Player.position
@onready var ground = $Node3D

const MAX_HEIGHT = 5
	
var noise = FastNoiseLite.new()
var chunk_noise = FastNoiseLite.new()
	
var matrix_size_z = 7
var matrix_size_x = 7
var distance = 14.0#5

var first_z = true
var first_x = true

var map = Node.new()

var add_distance_north = 7.0#25
var add_distance_south = -7.0#25
var add_distance_west = 7.0#25
var add_distance_est = -7.0#25

var row_number_north = 7
var row_number_south = -1
var column_number_west = 7
var column_number_est = -1

var i_for_z = 0
var i_for_x = 0

var global_noise_seed = randi()

# Dictionary containing information regarding what structures are placed, rotation and color for every chunk
# eg. { "0,0": { "structure": 0, "rotation": PI/2, "color": #ffffff } }
var chunk_properties = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
	noise.set_frequency(0.03)
	noise.set_domain_warp_amplitude(50)
	noise.set_fractal_lacunarity(2)
	noise.set_fractal_gain(3.5)
	noise.set_fractal_octaves(2)
	noise.seed = global_noise_seed
	
	chunk_noise.set_noise_type(FastNoiseLite.TYPE_PERLIN)
	chunk_noise.set_frequency(0.02)
	chunk_noise.set_domain_warp_amplitude(50)
	chunk_noise.set_fractal_lacunarity(2)
	chunk_noise.set_fractal_gain(3.5)
	chunk_noise.set_fractal_octaves(2)
	chunk_noise.seed = randi()
	
	chunk_properties[str(0)+','+str(0)] = {
			"structure" = 0,
			"rotation" = 0,
			"seed" = 0
		}
	
	for i in range(matrix_size_x):
		var map_row = Node.new()
		for j in range(matrix_size_x):
			# Calculate the position of the square's origin
			var y = (i - matrix_size_x / 2) * distance
			var x = (j - matrix_size_x / 2) * distance
			var chunk = _createChunk(noise, MAX_HEIGHT, x, y)
			chunk.position = Vector3(x, 0, y)
			map_row.add_child(chunk)
			#noise.seed += 1
		map.add_child(map_row)
	add_child(map)
	#add_row(matrix_size, distance, noise, MAX_HEIGHT)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	check_for_movement_and_update_chunks()
	follow_player()

func _tileToPosition(tileX, tileY): 
	return Vector2((tileX + (tileY % 2) * 0.5) * 2, tileY * 2)

func _getIncrementedRotation():
	const angleArray = [PI/2, PI, PI * 1.5]
	return(angleArray[int(randf() * angleArray.size())])
	
func _getRandomColor():
	var color_array = ['#186F65'] # the color of the rocks #43873D or #5e7535
	return(color_array[int(randf() * color_array.size())])

func _createChunk( noise, MAX_HEIGHT, x, y):
	var block_position_noise = chunk_noise.get_noise_2d(x/14, y/14) + 1 * 0.45
	var chunk_parent_node = Node3D.new()
	var inner_structure = randi() % 10 + 1
	var chunk_ground
	var chunk_structure_number = generate_structure_number(block_position_noise)
	if chunk_structure_number == -1:
		chunk_ground = water_scene.instantiate()
	else:
		chunk_ground = static_ground_scene.instantiate()
	var random_chunk_rotation = _getIncrementedRotation()
	if chunk_properties.has(str(x)+','+str(y)):
		chunk_structure_number = chunk_properties[str(x)+','+str(y)]["structure"]
		random_chunk_rotation = chunk_properties[str(x)+','+str(y)]["rotation"]
		noise.seed = chunk_properties[str(x)+','+str(y)]["seed"]
	else:
		noise.seed = global_noise_seed
		chunk_properties[str(x)+','+str(y)] = {
				"structure" = chunk_structure_number,
				"rotation" = random_chunk_rotation,
				"seed" = global_noise_seed
			}
		global_noise_seed += 1
		
	if chunk_structure_number == 0:
		var rand = randi() % 30
		if rand >= 27:
			if rand >= 29:
				chunk_parent_node.add_child(stone_wall_1side_02_scene.instantiate())
				chunk_parent_node.add_child(sheeps.instantiate())
			elif rand >= 28:
				chunk_parent_node.add_child(bush_wall_1side_02_scene.instantiate())
			else:
				chunk_parent_node.add_child(flowers_scene.instantiate())
	
	if chunk_structure_number == 1:
		for i in range(-2, 2):
			for j in range(-2, 2):
				var myNoise = (noise.get_noise_2d(i, j) + 1 ) * 0.45
				var position = _tileToPosition(i, j)
			
				var randomScale = randf() * (1.3 - 0.6) + 0.6
				#var randomDistort = randf() * (1.5 - 0.9) + 0.9
				var randomDistort = randf() * (2.1 - 0.9) + 0.9
			
				if myNoise < 0.3:
					myNoise = 0.6
				var myPine = pine_scene3.instantiate()
				myPine.scale = Vector3(myNoise * 1.5, myNoise * 1.5, myNoise * 1.5)
				myPine.position = Vector3(position.x * randomDistort, 0, position.y * randomDistort)
				myPine.rotation.y = randomScale * 40
				#myPine.get_child(2).set_material_override(_create_pine_material())
				#myPine.get_child(2).get_surface_override_material(0).set_next_pass(outline_material)
				chunk_parent_node.add_child(myPine)
				chunk_parent_node.position = Vector3(1, 0, 1)
			
	if chunk_structure_number == 2:
		for i in range(-2, 2):
			for j in range(-2, 2):
				var myNoise = (noise.get_noise_2d(i, j) + 1 ) * 0.45
				var position = _tileToPosition(i, j)
			
				var randomScale = randf() * (1.3 - 0.6) + 0.6
				var randomDistort = randf() * (1.5 - 0.9) + 0.9
				
				if (position.length() <= 10 ):
					if myNoise > 0.7:
						var myCliff = mountain_scene.instantiate()
						myCliff.scale = Vector3(myNoise * 3, myNoise * 5, myNoise * 3)
						myCliff.position = Vector3(position.x * randomDistort, 0, position.y * randomDistort)
						myCliff.rotation.y = randomScale * 40
						chunk_parent_node.add_child(myCliff)
						chunk_parent_node.position = Vector3(1, 0, 1)
					else:
						var myCliff = mountain_scene.instantiate()
						myCliff.scale = Vector3(myNoise * 2.5, myNoise * 2.5, myNoise * 2.5)
						myCliff.position = Vector3(position.x * randomDistort, 0, position.y * randomDistort)
						myCliff.rotation.y = randomScale * 40
						chunk_parent_node.add_child(myCliff)
						chunk_parent_node.position = Vector3(1, 0, 1)
						
	if chunk_structure_number == 3:
		var random_house_nr = randi() % 20
		var irishHouse
		if random_house_nr > 0 and random_house_nr < 6:
			var npc_peasant = npc_scene.instantiate()
			npc_peasant.position = Vector3(0, 0, 0)
			irishHouse = irishHouse_scene.instantiate()
			irishHouse.get_node('Path3D').get_node('PathFollow3D').add_child(npc_peasant)
		elif random_house_nr >= 6 and random_house_nr < 12:
			irishHouse = irishHouse2_scene.instantiate()
		elif random_house_nr >= 12 and random_house_nr < 18:
			irishHouse = irishHouse3_scene.instantiate()
		else:
			irishHouse = church_scene.instantiate()
		#irishHouse.rotate. =  _getIncrementedRotation()
		#irishHouse.get_child(2).get_child(2).set_material_override(_create_pine_material())
		#irishHouse.get_child(3).get_child(2).set_material_override(_create_pine_material())
		#irishHouse.get_child(4).get_child(2).set_material_override(_create_pine_material())
		
		#var npc_peasant = npc_scene.instantiate()
		#npc_peasant.position = Vector3(0, 0, 0)
		#chunk_parent_node.add_child(npc_peasant)
		
		chunk_parent_node.add_child(irishHouse)
		if inner_structure > 5:
			if inner_structure > 8:
				chunk_parent_node.add_child(stone_wall_1side_01_scene.instantiate())
				chunk_parent_node.add_child(structure_trees_rocks_scene.instantiate())
			else:
				chunk_parent_node.add_child(bush_wall_1side_01_scene.instantiate())
				chunk_parent_node.add_child(structure_trees_rocks_scene.instantiate())	
		elif inner_structure <= 5:
			if inner_structure > 3:
				chunk_parent_node.add_child(stone_wall_1side_01_scene.instantiate())
			elif inner_structure < 2:
				chunk_parent_node.add_child(structure_trees_rocks_scene.instantiate())	
		
		chunk_parent_node.position = Vector3(0, 0, 0)
			
	chunk_ground.position = Vector3(0, 0, 0)
	chunk_ground.add_child(chunk_parent_node)
	chunk_ground.rotation = Vector3(0, random_chunk_rotation, 0)
	return chunk_ground
	
func _create_pine_material():
	
	var unique_material = pine_shader_material.duplicate() #StandardMaterial3D.new()
	#unique_material.albedo_texture = _getRandomTexture()
	#unique_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	unique_material.set_shader_parameter('main_color', Color(_getRandomColor()))
	return unique_material

func follow_player():
	pass
	var player_pos = player.global_transform.origin
	ground.global_transform.origin.x = player_pos.x
	ground.global_transform.origin.z = player_pos.z

func getChunkNoiseSeed(x, y):

	if x == y and x >= 0:  # Center of the spiral
		return (2 * x + 1) ** 2

	var k = max(abs(x), abs(y))  # Distance from center
	var base_value = (2 * k + 1) ** 2  # Value at the bottom-right corner of the current square

	if x == k and y != -k:  # Right side of the square
		return base_value - (k - y)
	elif y == -k:  # Bottom side of the square
		return base_value - 2 * k - (k - x)
	elif x == -k:  # Left side of the square
		return base_value - 4 * k - (k + y)
	elif y == k:  # Top side of the square
		return base_value - 6 * k - (k + x)

func add_row_north(matrix_size_z, distance, noise, MAX_HEIGHT):
	var map_row = Node.new()
	for i in range(i_for_z, 7 + i_for_z):
		# Calculate the position of the square's origin
		var x = (i - matrix_size_z / 2) * distance
		var y = (row_number_north - matrix_size_z / 2) * distance
		var chunk_content_number = randi()%6+0
		var chunk = _createChunk(noise, MAX_HEIGHT, x, y)
		chunk.position = Vector3(x, 0, y)
		map_row.add_child(chunk)
		#noise.seed += 1
	map.add_child(map_row)
	row_number_north += 1
	row_number_south += 1
	#removing the north most row
	map.get_child(0).queue_free()
	i_for_x += 1

func add_row_south(matrix_size_z, distance, noise, MAX_HEIGHT):
	var map_row = Node.new()
	for i in range(i_for_z, 7 + i_for_z):
		# Calculate the position of the square's origin
		var x = (i - matrix_size_z / 2) * distance
		var y = (row_number_south - matrix_size_z / 2) * distance
		var chunk_content_number = randi()%6+0
		var chunk = _createChunk(noise, MAX_HEIGHT, x, y)
		chunk.position = Vector3(x, 0, y)
		map_row.add_child(chunk)
		#noise.seed += 1
	map.add_child(map_row)
	map.move_child(map_row, 0)
	row_number_south -= 1
	row_number_north -= 1
	#removing the south most row
	map.get_child(map.get_child_count() - 1).queue_free()
	i_for_x -= 1

func add_column_west(matrix_size_x, distance, noise, MAX_HEIGHT):
	for i in range(7):
		var y = (i+i_for_x - matrix_size_x / 2) * distance
		var x = (column_number_west - matrix_size_x / 2) * distance
		var chunk_content_number = randi()%6+0
		var chunk = _createChunk(noise, MAX_HEIGHT, x, y)
		chunk.position = Vector3(x, 0, y)
		map.get_child(i).add_child(chunk)
		map.get_child(i).get_child(0).queue_free()
	column_number_west += 1
	column_number_est += 1
	i_for_z += 1
	
func add_column_est(matrix_size_x, distance, noise, MAX_HEIGHT):
	for i in range(7):
		var y = (i+i_for_x - matrix_size_x / 2) * distance
		var x = (column_number_est - matrix_size_x / 2) * distance
		var chunk_content_number = randi()%6+0
		var chunk = _createChunk(noise, MAX_HEIGHT, x, y)
		chunk.position = Vector3(x, 0, y)
		map.get_child(i).add_child(chunk)
		map.get_child(i).move_child(chunk, 0)
		map.get_child(i).get_child(map.get_child_count()).queue_free()
	column_number_est -= 1
	column_number_west -= 1
	i_for_z -= 1

func check_for_movement_and_update_chunks():
	var player_position_z = player.position.z
	var player_position_x = player.position.x
	if player_position_z > add_distance_north:
		add_row_north(matrix_size_z, distance, noise, MAX_HEIGHT)
		if first_z:
			add_distance_north += add_distance_north * 2
			add_distance_south = +7.0#25
			first_z = false
			#print("northFirst")
		else:
			add_distance_north += 14.0#5
			add_distance_south += 14.0#5
			#print("north")
			
	elif player_position_z < add_distance_south:
		add_row_south(matrix_size_z, distance, noise, MAX_HEIGHT)
		if first_z:
			add_distance_south = -21.0#75
			add_distance_north -= add_distance_north * 2
			first_z = false
			#print("southFirst")
		else:
			add_distance_south -= 14.0#5
			add_distance_north -= 14.0#5
			#print("south")
			
	elif player_position_x > add_distance_west:
		add_column_west(matrix_size_x, distance, noise, MAX_HEIGHT)
		if first_x:
			add_distance_west += add_distance_west * 2
			add_distance_est += +14.0#5
			first_x = false
			#print("westFirst")
		else:
			add_distance_west += 14.0#5
			add_distance_est += 14.0#5
			#print("west")
			
	elif player_position_x < add_distance_est:
		add_column_est(matrix_size_x, distance, noise, MAX_HEIGHT)
		if first_x:
			add_distance_est = -21.0#75
			add_distance_west -= add_distance_west * 2
			first_x = false
			#print("estFirst")
		else:
			add_distance_est -= 14.0#5
			add_distance_west -= 14.0#5
			#print("est")

func generate_structure_number(noise):
	var probabilities = {
		0: 0.71,   # Nothing
		1: 0.1,   # Tree
		2: 0.05,   # Rock
		3: 0.04    # House
	}
	
	if 0.4 < noise and noise <= 0.7:
		# Increase the chance of trees
		probabilities[1] = 0.6
		probabilities[0] = 0.4
	#elif 0.2 < noise and noise <= 0.4:
	elif 0.14 < noise and noise <= 0.18:
		# Increase the chance of houses
		probabilities[3] = 0.6
	elif noise > 0.9:
		probabilities[2] = 0.6
	elif noise < 0.1:
		return -1
	
	var structure_number = weighted_random_choice(probabilities)
	return structure_number

func weighted_random_choice(probabilities):
	
	var total = 0
	for key in probabilities.keys():
		total += probabilities[key]
		
	var rand_value = randf() * (total - 0) + 0
	var cumulative_probability = 0.0

	for structure_type in probabilities.keys():
		cumulative_probability += probabilities[structure_type]

		if rand_value <= cumulative_probability:
			return structure_type
