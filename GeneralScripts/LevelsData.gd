class_name LevelsData
extends Resource

# General Info
@export var level_num = 0
@export var level_name = "The Start"
@export var level_cleared = false
@export var max_coins_collected = 0
@export var max_coins_on_a_level = 0

# When all coins are collected and time record is made
@export var min_time_min_all_coins = 10000
@export var min_time_sec_all_coins = 60

# When not all coins are collected and time record is made
@export var min_time_min_not_all_coins = 10000
@export var min_time_sec_not_all_coins = 60
@export var coins_min_time_not_all_coins = 0

func NewAllCoinsTimeRecordSave(time_min, time_sec):
	min_time_min_all_coins = time_min
	min_time_sec_all_coins = time_sec
	BaseInfoSave(max_coins_on_a_level)

func NewNotAllCoinsTimeRecordSave(time_min, time_sec, coins):
	min_time_min_not_all_coins = time_min
	min_time_sec_not_all_coins = time_sec
	coins_min_time_not_all_coins = coins
	BaseInfoSave(coins)

func BaseInfoSave(coins):
	level_cleared = true
	if coins > max_coins_collected:
		max_coins_collected = coins
	
	ResourceSaver.save(self, str("res://DataFiles/LevelFiles/Level", level_num, ".tres"))
