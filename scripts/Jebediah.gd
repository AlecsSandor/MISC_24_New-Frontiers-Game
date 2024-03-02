extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#$AnimationPlayer.play('Idle')
	#change_animation()
	pass
	
func change_animation():
	if Input.is_action_just_pressed("Click"):
		$AnimationPlayer.play('Run')
		print("Run ")
	else:
		print("Idle")
		$AnimationPlayer.play('Idle')
