extends Control


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1/Level1.tscn")

func _on_level_menu_pressed():
	pass # Replace with function body.

func _on_settings_pressed():
	pass # Replace with function body.

func _on_credit_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()
