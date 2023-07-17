extends Camera2D


var zoomed : bool


func _ready():
	$Hud.hide()


func _on_TitleScreen_tree_exited():
	current = true
	$Hud.show()

func _input(_event):
	if Input.is_action_just_pressed("camera"):
		match zoomed:
			false:
				zoomed = true
				#zoom = Vector2(0.25, 0.25)
			
			true:
				zoomed = false
				#zoom = Vector2(0.5, 0.5)

func _physics_process(_delta):
	if zoomed:
		if zoom.x > 0.25:
			zoom /= 1.05
		
		if zoom.x < 0.25:
			zoom = Vector2(0.25, 0.25)
			
	else:
		if zoom.x < 0.5:
			zoom *= 1.05
		
		if zoom.x > 0.5:
			zoom = Vector2(0.5, 0.5)
