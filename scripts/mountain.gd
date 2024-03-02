extends Node3D

@onready var mountain_material_01_shader = $MeshInstance3D.get_surface_override_material(1).get_next_pass()
@onready var mountain_material_00_shader = $MeshInstance3D.get_surface_override_material(0).get_next_pass()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_static_body_3d_mouse_entered():
	#mountain_material_01_shader.set_shader_parameter("strength", 0.1)
	#mountain_material_00_shader.set_shader_parameter("strength", 0.1)
	pass # Replace with function body.


func _on_static_body_3d_mouse_exited():
	#mountain_material_01_shader.set_shader_parameter("strength", 0.0)
	#mountain_material_00_shader.set_shader_parameter("strength", 0.0)
	pass # Replace with function body.
