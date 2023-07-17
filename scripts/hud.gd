extends CanvasLayer


onready var time_text := $Time/Label
onready var death_text := $Deaths/Label
onready var message_text := $Message/Label
onready var message_fade := $Message/Close
onready var end := $End
onready var main := get_node("/root/Main")
export var deaths : int
var time : int


func instructions():
	$Time/Tick.start()
	message("hit the hero from below into danger!")


func final_fight():
	$Time/Tick.start()
	message("it's time to fight! hit the hero from below!")


func message(item : String):
	message_text.text = item
	message_fade.start()


func _ready():
	pass # Replace with function body.


func _physics_process(_delta):
	if time - (floor(time / 60) * 60) < 10:
		time_text.text = "time | " + str(floor(time / 60)) + ":0" + str(time - (floor(time / 60) * 60))
	
	elif time - (floor(time / 60) * 60) >= 10:
		time_text.text = "time | " + str(floor(time / 60)) + ":" + str(time - (floor(time / 60) * 60))
		
	death_text.text = "deaths: " + str(deaths)

func _on_TitleScreen_tree_exited():
	instructions()


func _on_Tick_timeout():
	time += 1


func _on_Close_timeout():
	message_text.text = ""


func _on_Transition_timeout():
	if main.level < 6:
		instructions()
	
	else:
		final_fight()


func _on_End_timeout():
	end.show()
