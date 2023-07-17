extends KinematicBody2D


onready var animation := $AnimatedSprite
onready var player := get_node("/root/Main/Player")
onready var main := get_node("/root/Main")
export var fall_speed : float
export var horizontal_speed : float
export var jump_height : float
export var health : int
var velocity : Vector2
var in_control : bool
var bounce_limit : int
var dead : bool


signal next_level


func _input(_event):
	if Input.is_action_just_pressed("ui_down"):
		print(str("in_control: " + str(in_control)))
		print(str("dead: " + str(dead)))


func death():
	$Death.play()
	dead = true
	in_control = false
	animation.play("hit")
	emit_signal("next_level")


func setup(direction : bool, location : Vector2):
	bounce_limit = 0
	health = 10
	velocity = Vector2()
	animation.play("walk")
	show()
	in_control = true
	dead = false
	animation.flip_h = direction
	global_position = location
	
func _ready():
	animation.play("walk")
	hide()
	dead = true
	in_control = false


func _physics_process(_delta):
	animation.global_position = Vector2(int(global_position.x), int(global_position.y))
	if not dead and not main.transitioning and not main.level > 5:
		#print(position)
		if velocity.x > 80:
			velocity.x = 80
		
		if velocity.x < -80:
			velocity.x = -80
			
		if not is_on_floor():
			velocity.y += fall_speed
			#if in_control:
				#if not animation.animation == "jump":
					#animation.play("jump")
		
		if is_on_floor():
			bounce_limit = 0
			in_control = true
			if not animation.animation == "walk":
				animation.play("walk")
			
		if in_control:
			if animation.flip_h:
				velocity.x -= horizontal_speed
			
			elif not animation.flip_h:
				velocity.x += horizontal_speed
				
		if position.y > 192:
			if not main.level > 5:
				death()
				
			else:
				$End.start()
				get_node("/root/Main/Music").stop()
				dead = true
				in_control = false
			
		velocity = move_and_slide(velocity, Vector2.UP, true)
	
	elif not dead and not main.transitioning and main.level > 5:
		if velocity.x > 80:
			velocity.x = 80
		
		if velocity.x < -80:
			velocity.x = -80
		
		if not is_on_floor():
			velocity.y += fall_speed
			#if in_control:
				#if not animation.animation == "jump":
					#animation.play("jump")
		
		if is_on_floor():
			if player.position.y < position.y:
				velocity.y = -jump_height
				$Jump.play()
				
			bounce_limit = 0
			in_control = true
			if not animation.animation == "walk":
				animation.play("walk")
				
		if player.position.x < position.x:
			animation.flip_h = true
		
		else:
			animation.flip_h = false
			
		if in_control:
			if animation.flip_h:
				velocity.x -= horizontal_speed
			
			elif not animation.flip_h:
				velocity.x += horizontal_speed
				
		if position.y > 192:
			if not main.level > 5:
				death()
				
			else:
				$End.start()
				get_node("/root/Main/Music").stop()
				dead = true
				in_control = false
			
		velocity = move_and_slide(velocity, Vector2.UP, true)
	
	
func _on_TitleScreen_tree_exited():
	setup(true, Vector2(288, -144))


func _on_Hitbox_area_entered(area):
	if area in get_tree().get_nodes_in_group("player") and not player.is_on_floor() and (bounce_limit < 3 || main.level > 5):
		$Hit.play()
		if main.level > 5:
			health -= 1
			if health < 1:
				$End.start()
				get_node("/root/Main/Music").stop()
				dead = true
				in_control = false
		
		bounce_limit += 1
		in_control = false
		animation.play("hit")
		velocity.y = -jump_height
		$Hit.play()
		MainGlobal.explode = load("res://scenes/explosion.tscn").instance()
		get_tree().get_root().add_child(MainGlobal.explode)
		MainGlobal.explode.position = Vector2(int(position.x), int(position.y + 16))
		velocity.x = (position.x - player.position.x) * 4


func _on_Sensor_body_entered(body):
	if body in get_tree().get_nodes_in_group("jump"):
		$Jump.play()
		MainGlobal.explode = load("res://scenes/explosion.tscn").instance()
		get_tree().get_root().add_child(MainGlobal.explode)
		MainGlobal.explode.position = Vector2(int(position.x), int(position.y + 16))
		velocity.y = -jump_height
	
	if body in get_tree().get_nodes_in_group("switch"):
		match animation.flip_h:
			false:
				animation.flip_h = true
			
			true:
				animation.flip_h = false
	
	if body in get_tree().get_nodes_in_group("spikes"):
		death()


func _on_Hitbox_body_entered(body):
	if body in get_tree().get_nodes_in_group("spikes"):
		death()


func _on_Transition_timeout():
	if main.level == 0:
		setup(true, Vector2(288, -144))
	
	elif main.level == 1:
		setup(false, Vector2(-250, -106))
	
	elif main.level == 2:
		setup(true, Vector2(240, 96))
	
	elif main.level == 3:
		setup(false, Vector2(-250, 132))
	
	elif main.level == 4:
		setup(false, Vector2(-250, 90))
	
	elif main.level == 5:
		setup(false, Vector2(-272, -144))
	
	elif main.level == 6:
		setup(false, Vector2(-224, 112))
		

func _on_Player_restart():
	animation.play("walk")
	hide()
	in_control = false
