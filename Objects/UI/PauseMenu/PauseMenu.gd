extends Control

func Pause():
	self.visible = true
	get_tree().paused = true

func _on_continue_pressed():
	get_tree().paused = false
	self.visible = false

func _on_settings_pressed():
	pass # Replace with function body.

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_to_level_menu_pressed():
	get_tree().paused = false

func _on_to_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
