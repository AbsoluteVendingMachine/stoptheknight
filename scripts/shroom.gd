extends AnimatedSprite


var dead : bool
var velocity : Vector2
var rng = RandomNumberGenerator.new()
onready var sfx := get_node("/root/Main/Shroom") as AudioStreamPlayer


func _on_Hitbox_area_entered(area):
	if area in get_tree().get_nodes_in_group("hero") or area in get_tree().get_nodes_in_group("hero2"):
		sfx.play()
		sfx.pitch_scale = rng.randf_range(0.25,3)
		play("hit")
		$Free.start()
		rng.randomize()
		velocity = Vector2(rng.randf_range(-4, 4), rng.randf_range(-4, -1))
		dead = true


func _physics_process(_delta):
	if dead:
		position += velocity
		position = Vector2(int(position.x), int(position.y))
		velocity.y += 0.1
	


func _on_Free_timeout():
	MainGlobal.explode = load("res://scenes/explosion.tscn").instance()
	get_tree().get_root().add_child(MainGlobal.explode)
	MainGlobal.explode.position = Vector2(int(position.x), int(position.y))
	queue_free()


func _on_Shroom_tree_entered():
	#rng.randomize()
	#modulate.r = rng.randi_range(0, 255)
	#modulate.g = rng.randi_range(0, 255)
	#modulate.b = rng.randi_range(0, 255)
	pass
