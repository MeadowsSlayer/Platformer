extends Button

@export var level = 1
@onready var label = $Label
@onready var color_rect = $ColorRect
@onready var state = $State
@onready var dialogue_window_levels = $"../../../DialogueWindowLevels"

var level_info

func DetermineState(max_level):
	if max_level + 1 == level:
		color_rect.visible = true
		state.visible = true
		state.text = "NEW"
		level_info = load(str("res://DataFiles/LevelFiles/Level", level, ".tres"))
		label.text = str(level, " - ", level_info.get("level_name"))
	elif max_level >= level:
		level_info = load(str("res://DataFiles/LevelFiles/Level", level, ".tres"))
		label.text = str(level, " - ", level_info.get("level_name"))
	elif max_level < level:
		self.disabled = true
		color_rect.visible = true
		state.visible = true
		label.text = str(level, " - ???")

func _on_pressed():
	dialogue_window_levels.ShowInfo(level_info)
