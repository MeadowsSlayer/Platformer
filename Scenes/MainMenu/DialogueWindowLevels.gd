extends Control

@onready var title = $"../Title"
@onready var levels = $"../Levels"
@onready var time_all_coins = $TimeAllCoins
@onready var time_not_all_coins = $TimeNotAllCoins
@onready var coins_text = $Coins
@onready var level_title = $Title

var level_num

func ShowInfo(level_info):
	title.text = "Level Info"
	self.visible = true
	levels.visible = false
	level_num = level_info.get("level_num")
	level_title.text = str(level_num, " - ", level_info.get("level_name"))
	if level_info.get("min_time_min_all_coins") != 10000:
		time_all_coins.text = str(level_info.get("min_time_min_all_coins"), ":", level_info.get("min_time_sec_all_coins"))
	else:
		time_all_coins.text = "NONE"
	
	if level_info.get("min_time_min_not_all_coins") != 10000:
		time_not_all_coins.text = str(level_info.get("min_time_min_not_all_coins"), ":", level_info.get("min_time_sec_not_all_coins"))
		coins_text.text = str(level_info.get("coins_min_time_not_all_coins"), " coins")
	else:
		time_not_all_coins.text = "NONE"

func _on_back_pressed():
	self.visible = false
	levels.visible = true

func _on_play_pressed():
	get_tree().change_scene_to_file(str("res://Scenes/Levels/Level", level_num, "/Level", level_num, ".tscn"))
