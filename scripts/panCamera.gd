extends Node3D

@export var target: NodePath

@export var rotation_speed = PI/2

# mouse properties
@export var mouse_control = true
@export var mouse_sensitivity = 0.005
@export var invert_y = false
@export var invert_x = false

# zoom settings
@export var max_zoom = 2.0
@export var min_zoom = 0.6
@export var zoom_speed = 0.09

var zoom = 0.6

@onready var player = get_parent().get_child(7)

func _unhandled_input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if event.is_action_pressed("cam_zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("cam_zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)
	if mouse_control and event is InputEventMouseMotion:
		print(event)
		if event.relative.x != 0:
			var dir = 1 if invert_x else -1
			rotate_object_local(Vector3.UP, dir * event.relative.x * mouse_sensitivity)
		if event.relative.y != 0:
			var dir = 1 if invert_y else -1
			var y_rotation = clamp(event.relative.y, -30, 30)
			$InnerGimbal.rotate_object_local(Vector3.RIGHT, dir * y_rotation * mouse_sensitivity)

func get_input_keyboard(delta):
	# Rotate outer gimbal around y axis
	var y_rotation = 0
	if Input.is_action_pressed("cam_right"):
		y_rotation += 1
	if Input.is_action_pressed("cam_left"):
		y_rotation += -1
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	# Rotate inner gimbal around local x axis
	var x_rotation = 0
	if Input.is_action_pressed("cam_up"):
		x_rotation += -1
	if Input.is_action_pressed("cam_down"):
		x_rotation += 1
	x_rotation = -x_rotation if invert_y else x_rotation
	$InnerGimbal.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)

func _process(delta):
	update_position_of_innerGimbal()
	if !mouse_control:
		get_input_keyboard(delta)
	$InnerGimbal.rotation.x = clamp($InnerGimbal.rotation.x, -1.4, -0.01)
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	if target:
		global_transform.origin = get_node(target).global_transform.origin
		
func update_position_of_innerGimbal():
	position = player.position
