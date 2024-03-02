extends Node3D
#var texture = preload("res://textures/grass_squared.jpg")

var totalTime = 5
var currTime
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
@onready var animationPlayer = $AnimationPlayer
func _ready():
	animationPlayer.play("Wind_simple")
	
	currTime = totalTime
	#var mesh_instance = self.get_child(0).mesh
	#var material1 = mesh_instance.surface_get_material(0) # leaves texture
	#var material2 = mesh_instance.surface_get_material(1)
	
	#var unique_material = StandardMaterial3D.new()
	#unique_material.albedo_texture = texture
	#unique_material.shading_mode = 2
	#unique_material.albedo_color = Color(_getRandomColor())
	
	#material1.albedo_texture = texture
	#mesh_instance.surface_set_material(0, unique_material)
	#mesh_instance.surface_get_material(0).material_override = unique_material
	#material1.albedo_color = Color(_getIncrementedRotation())
	#print(material1.albedo_color)
	
	#material2.albedo_color = Color("#906125")
	
	#print(unique_material.albedo_color)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if currTime <= 0:
		#treeChopped()
'''
func _on_chopping_area_body_entered(body):
	if "Player" in body.name:
		start_chopping()

func _on_chopping_area_body_exited(body):
	if "Player" in body.name:
		timer.stop()
	
func start_chopping():
	timer.start()
	
func treeChopped():
	animationPlayer.play("fall")
	
func _on_timer_timeout():
	currTime -= 1

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'fall':
		queue_free()
'''
