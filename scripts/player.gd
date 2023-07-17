extends KinematicBody2D


onready var player_sprite := $Sprite
onready var animation := $AnimationPlayer
onready var cursor := $Cursor
onready var main := get_node("/root/Main")
onready var camera := $Camera
onready var hud := $Camera/Hud
export var horizontal_speed : float
export var jump_height : float
export var fall_speed : float
var velocity : Vector2
var can_jump_buffer : bool
var jump_buffer_active : bool
var dead : bool


signal restart


func _ready():
	dead = true


func level(value : int):
	showcursor()
	dead = false
	if value == 0:
		position = Vector2(0, 8)
		
	elif value == 1:
		position = Vector2(0, 128)
	
	elif value == 2:
		position = Vector2(240, -72)
	
	elif value == 3:
		position = Vector2(272, 132)
	
	elif value == 4:
		position = Vector2(256, 90)
	
	elif value == 5:
		position = Vector2(-144, 104)
	
	elif value == 6:
		position = Vector2(224, 112)


func showcursor():
	cursor.show()
	cursor.play("anim")


func _physics_process(_delta):
	if not dead:
		player_sprite.global_position = Vector2(int(global_position.x), int(global_position.y))
		camera.global_position = Vector2(int(global_position.x), int(global_position.y))
		if position.y > 192:
			velocity.y = -jump_height * 1.5
			
		if Input.is_action_just_pressed("restart"):
			dead = true
			emit_signal("restart")
			
		if velocity.x > 100:
			velocity.x = 100
		
		if velocity.x < -100:
			velocity.x = -100
		
		if velocity.y > 200:
			velocity.y = 200
			
		if Input.is_action_pressed("ui_right"):
			player_sprite.flip_h = false
			velocity.x += horizontal_speed
		
		if Input.is_action_pressed("ui_left"):
			player_sprite.flip_h = true
			velocity.x -= horizontal_speed
		
		if Input.is_action_just_pressed("ui_left"):
			if velocity.x > 5:
				velocity.x /= 2
				
		if Input.is_action_just_pressed("ui_right"):
			if velocity.x < -5:
				velocity.x /= 2
		
		if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_right"):
			velocity.x *= 0.85
		
		if is_on_floor():
			if jump_buffer_active:
				if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_select"):
					velocity.y = -jump_height
					$Jump.play()
				
				else:
					velocity.y = -jump_height / 2
					$Jump.play()
				jump_buffer_active = false
				
			if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
				velocity.x *= 0.85
				animation.play("idle")
			
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				animation.play("walk")
				
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
				velocity.y = -jump_height
				$Jump.play()
		
		if not is_on_floor():
			velocity.y += fall_speed
			
			if velocity.y > 0:
				animation.play("jump_down")
			
			elif velocity.y < 0:
				animation.play("jump_up")
			
			if Input.is_action_just_released("ui_accept") or Input.is_action_just_released("ui_select"):
				if velocity.y < 0:
					velocity.y /= 2
			
			if can_jump_buffer:
				if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_select"):
					jump_buffer_active = true
			
		velocity = move_and_slide(velocity, Vector2.UP, true)


func _on_JumpBuffer_body_entered(body):
	if body in get_tree().get_nodes_in_group("tiles"):
		can_jump_buffer = true


func _on_JumpBuffer_body_exited(body):
	if body in get_tree().get_nodes_in_group("tiles"):
		can_jump_buffer = false


func _on_TitleScreen_tree_exited():
	level(0)


func _on_Cursor_animation_finished():
	cursor.hide()


func _on_Hitbox_area_entered(area):
	if area in get_tree().get_nodes_in_group("hero"):
		if not dead:
			hud.deaths += 1
		dead = true
		$Death.play()
		emit_signal("restart")
	
	if area in get_tree().get_nodes_in_group("hero2"):
		velocity.y *= -1


func _on_Transition_timeout():
	velocity = Vector2()
	level(main.level)


func _on_End_timeout():
	dead = true
