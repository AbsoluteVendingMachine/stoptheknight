extends TileMap


onready var main := get_node("/root/Main")


func _physics_process(_delta):
	if main.transitioning:
		queue_free()
