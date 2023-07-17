extends Node2D


#onready var transition_screen := $Player/Camera/Hud/Transition
#onready var transition_timer := $Transition
export var level : int
var in_game : bool
var explode := preload("res://scenes/explosion.tscn").instance()
var stage0 := preload("res://scenes/stage_0.tscn").instance()
var stage1 := preload("res://scenes/stage_1.tscn").instance()
var stage2 := preload("res://scenes/stage_2.tscn").instance()
var stage3 := preload("res://scenes/stage_3.tscn").instance()
var stage4 := preload("res://scenes/stage_4.tscn").instance()
var stage5 := preload("res://scenes/stage_5.tscn").instance()
var stage6 := preload("res://scenes/stage_6.tscn").instance()
var transitioning : bool


func transition(flag : bool):
	if flag:
		if not transitioning:
			transitioning = true
			level += 1
			$Player/Camera/Hud/Transition.show()
			$Transition.start()
	
	else:
		transitioning = true
		$Player/Camera/Hud/Transition.show()
		$Transition.start()


func load_level(value : int):
	if value == 0:
		stage0 = load("res://scenes/stage_0.tscn").instance()
		get_tree().get_root().add_child(stage0)
	
	elif value == 1:
		stage1 = load("res://scenes/stage_1.tscn").instance()
		get_tree().get_root().add_child(stage1)
	
	elif value == 2:
		stage2 = load("res://scenes/stage_2.tscn").instance()
		get_tree().get_root().add_child(stage2)
	
	elif value == 3:
		stage3 = load("res://scenes/stage_3.tscn").instance()
		get_tree().get_root().add_child(stage3)
	
	elif value == 4:
		stage4 = load("res://scenes/stage_4.tscn").instance()
		get_tree().get_root().add_child(stage4)
	
	elif value == 5:
		stage5 = load("res://scenes/stage_5.tscn").instance()
		get_tree().get_root().add_child(stage5)
	
	elif value == 6:
		if not get_node("/root/Main/Music").stream == load("res://music/boss.ogg"):
			get_node("/root/Main/Music").stream = load("res://music/boss.ogg")
			get_node("/root/Main/Music").play()
			
		stage6 = load("res://scenes/stage_6.tscn").instance()
		get_tree().get_root().add_child(stage6)


func _on_Hero_next_level():
	transition(true)


func _on_Transition_timeout():
	print("transitioning")
	transitioning = false
	load_level(level)
	$Player/Camera/Hud/Transition.hide()


func _on_Player_restart():
	transition(false)


func _on_TitleScreen_tree_exited():
	if not level == -1:
		load_level(0)
	else:
		level = 6
		load_level(level)

func _input(_event):
	print(level)
