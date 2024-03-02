extends CharacterBody3D

@onready var navigationAgent := $NavigationAgent3D
var SPEED = 6

#@onready var playerCamera = $Camera3D2

@onready var character = $Character_04
@onready var gun = $Character_04.get_node("Luca").get_node("Gun")
@onready var timer = $Timer

var cameraPosition = 11
var shoot = false
var reloaded = true
var current_npc

var bullet = preload("res://scenes/bullet.tscn")

func _ready():
	#playerCamera.set_as_toplevel(true)
	pass

func _process(delta):
	if(navigationAgent.is_navigation_finished()):
		character.get_node("AnimationPlayer").play("Idle")
		if shoot:
			look_at(current_npc.global_position, Vector3.UP)
			if reloaded:
				shoot_enemy()
		return
	moveToPoint(delta, SPEED)
	
func _physics_process(delta):
	#camera_follows_player()
	pass
	
#func camera_follows_player():
#	var player_pos = global_transform.origin
	
#	playerCamera.global_transform.origin.x = player_pos.x
#	playerCamera.global_transform.origin.z = player_pos.z + cameraPosition
	
	#if Input.is_action_just_pressed("RotateRight"):
	#	playerCamera.rotate_y(20.0)


func faceDirection(direction):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)
	pass
func moveToPoint(delta, speed):
	#if is_instance_valid($Bullet):
	#	$Bullet.queue_free()
	var targetPos = navigationAgent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	faceDirection(targetPos)
	
	velocity = direction * speed
	character.get_node("AnimationPlayer").play("Run-Idle")
	move_and_slide()

	
func _input(event):
	if Input.is_action_just_pressed("Click"):
		if is_instance_valid($Bullet):
			$Bullet.queue_free()
		var camera = get_parent().get_child(6).get_child(0).get_child(0)
		var mousePos = get_viewport().get_mouse_position()
		var rayLength = 200
		var from = camera.project_ray_origin(mousePos)
		var to = from + camera.project_ray_normal(mousePos) * rayLength
		var space = get_world_3d().direct_space_state
		var rayQuery = PhysicsRayQueryParameters3D.new()
		rayQuery.from = from
		rayQuery.to = to
		rayQuery.collide_with_areas = true
		var result = space.intersect_ray(rayQuery)
		if result:
			navigationAgent.target_location = result.position
		
	#elif Input.is_action_just_pressed("ZoomOut"):
	#	if playerCamera.rotation.x > deg_to_rad(-40):
	#		playerCamera.rotation.x -= deg_to_rad(5)
	#		playerCamera.position.y += 1.5
	#		cameraPosition += 1

	#elif Input.is_action_just_pressed("ZoomIn"):
	#	if playerCamera.rotation.x < deg_to_rad(-25):
	#		playerCamera.rotation.x += deg_to_rad(5)
	#		playerCamera.position.y -= 1.5
	#		cameraPosition -= 1


func _on_area_3d_body_entered(body):
	if "NPC" in body.name:
		current_npc = body.get_parent()
		shoot = true

func _on_area_3d_body_exited(body):
	if "NPC" in body.name:
		shoot = false

func shoot_enemy():
	var bullet_instance = bullet.instantiate()
	bullet_instance.setup(current_npc.global_position)
	add_child(bullet_instance)
	$Bullet.position = Vector3($Bullet.position.x+0.5, 0.5, $Bullet.position.y)
	character.get_node("AnimationPlayer").play("Shoot")
	reloaded = false
	timer.start()


func _on_timer_timeout():
	reloaded = true
	pass # Replace with function body.
