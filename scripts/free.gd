extends AnimatedSprite


func _on_Free_timeout():
	queue_free()


func _on_Explosion_animation_finished():
	queue_free()


func _on_Explosion_tree_entered():
	if name == "Explosion":
		play("anim")
