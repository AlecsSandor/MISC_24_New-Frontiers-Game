extends CharacterBody3D

var speed = 2
var acceleration = 4

var current_state = state.MOVE
var dir

var start_pos
var go_to_postion = Vector3(0, 0, 0)

enum state {
	IDLE,
	MOVE
}

@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var npc_target = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Player")

var follow = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#start_pos = global_position
	#dir = Vector3(start_pos.x + 4, start_pos.y + 4, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	'''
	match current_state:
		IDLE:
			pass
		MOVE:
			move(delta)
			
	if follow:
		var direction = Vector3()
		nav.target_position = npc_target.global_position
		direction = nav.get_next_path_position() - global_position
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		move_and_slide()
	'''

func _on_area_3d_body_entered(body):
	pass
	'''
	if "Player" in body.name:
		var global_position_npc = global_position
		var new_parent = get_parent().get_parent().get_parent().get_parent().get_parent()
		get_parent().remove_child(self)
		new_parent.add_child(self)
		global_position = global_position_npc
		follow = true
	'''
func move(delta):
	pass

func choose(array):
	array.shuffle()
	return array.front()

func _on_timer_timeout():
	$Timer.wait_time = choose([2.0, 2.5, 1.0])
	current_state = choose([state.IDLE, state.MOVE])
