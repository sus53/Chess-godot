extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_pressed():
	get_tree().reload_current_scene()



func _on_exit_game_pressed():
	get_tree().quit()


func _on_back_pressed():
	self.visible=false
