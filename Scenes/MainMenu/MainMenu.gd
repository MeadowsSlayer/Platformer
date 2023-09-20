extends Control

@onready var main_menu = $MainMenu
@onready var credits = $Credits
@onready var settings = $Settings
@onready var levels = $Levels
@onready var sub_menu_switcher = $SubMenuSwitcher
@onready var game_data = preload("res://DataFiles/GameData.tres")
@onready var title = $Title

func _ready():
	title.text = "Platformer"
	get_tree().call_group("Levels", "DetermineState", game_data.get("max_level_cleared"))

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level1/Level1.tscn")

func _on_level_menu_pressed():
	title.text = "Levels"
	main_menu.visible = false
	levels.visible = true
	levels.Start()

func _on_settings_pressed():
	pass # Replace with function body.

func _on_credit_pressed():
	title.text = "Credits"
	main_menu.visible = false
	credits.visible = true

func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	title.text = "Platformer"
	main_menu.visible = true
	credits.visible = false
	settings.visible = false
	levels.visible = false
