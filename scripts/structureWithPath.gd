extends Node3D

@onready var path_follow = $Path3D.get_child(0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if path_follow.get_child_count() > 0:
		var npc = path_follow.get_child(0)
		if npc.current_state == npc.state.MOVE:
			const speed := 2.0
			path_follow.progress += speed * delta
