extends Node3D

#@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	#navigation_region.map_set_use_edge_connection(map, enabled)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	#camera_follows_player()
	pass
	
func camera_follows_player():
	var player = global_transform.origin
	global_transform.origin.x = player.x
	global_transform.origin.y = player.y
