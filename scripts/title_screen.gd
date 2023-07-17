extends Node2D


onready var any_key := $TestLabel


var fading : bool


func _ready():
	fading = true
	get_node("/root/Main/Music").stream = load("res://music/title.ogg")
	get_node("/root/Main/Music").play()


func _physics_process(_delta):
	if fading:
		any_key.modulate.a8 -= 15
	
	else:
		any_key.modulate.a8 += 15
		
	
func _input(event):
	if event is InputEventKey and event.pressed:
		get_node("/root/Main/Music").stream = load("res://music/level.ogg")
		get_node("/root/Main/Music").play()
		queue_free()


func _on_Fade_timeout():
	match fading:
		true:
			fading = false
		
		false:
			fading = true
