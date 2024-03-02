extends CharacterBody3D

var target

var speed = 10
var acceleration = 6

func setup(target):
	self.target = Vector3(target.x, 2, target.z)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = target - global_position
	#var movement = direction * speed * delta
	velocity = direction * speed #velocity = velocity.lerp(direction * speed, acceleration * delta)
	move_and_slide()
	if (global_position - target).length() < 0.35:
		queue_free()
	pass
