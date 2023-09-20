extends Control

var level_file
var max_coins = 0
var time_min_ac = 0
var time_sec_ac = 0
var time_min_nac = 0
var time_sec_nac = 0

var time_sec = 0
var time_min = 0
var new_record = false

@export var level_num = 0

@onready var time = $Time
@onready var timer = $Timer
@onready var coins_text = $Coins
@onready var new_record_ui = $"New Record"
@onready var game_data = preload("res://DataFiles/GameData.tres")

func _ready():
	level_file = load(str("res://DataFiles/LevelFiles/Level", level_num, ".tres"))
	max_coins = level_file.get("max_coins_on_a_level")
	time_min_ac = level_file.get("min_time_min_all_coins")
	time_sec_ac = level_file.get("min_time_sec_all_coins")
	time_min_nac = level_file.get("min_time_min_not_all_coins")
	time_sec_nac = level_file.get("min_time_sec_not_all_coins")

func FinishLevel(coins):
	timer.stop()
	self.visible = true
	game_data.MaxLevelOverwrite(level_num)
	if coins != max_coins:
		coins_text.text = str(coins, " coins collected out of ", max_coins)
		new_record = SaveTimeNotAllCoins(coins)
	else:
		coins_text.text = "All coins are collected!"
		new_record = SaveTimeAllCoins()
	
	new_record_ui.visible = new_record
	
	time.text = str(TimeFix(time_min), ":", TimeFix(time_sec))

func SaveTimeNotAllCoins(coins):
	if (time_min == time_min_nac and time_sec < time_sec_nac) or (time_min < time_min_nac):
		level_file.NewNotAllCoinsTimeRecordSave(time_min, time_sec, coins)
		return true
	
	return false

func SaveTimeAllCoins():
	if (time_min == time_min_ac and time_sec < time_sec_ac) or (time_min < time_min_ac):
		level_file.NewAllCoinsTimeRecordSave(time_min, time_sec)
		return true
	
	return false

func TimeFix(time_value):
	if time_value < 10:
		return str("0", time_value)
	else:
		return str(time_value)

func _on_timer_timeout():
	time_sec += 1
	if time_sec == 60:
		time_min += 1
		time_sec = 0

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
