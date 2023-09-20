class_name GameData
extends Resource

@export var volume = 0
@export var max_level_cleared = 0

func MaxLevelOverwrite(level):
	if level > max_level_cleared:
		max_level_cleared = level
	Save()

func Save():
	ResourceSaver.save(self, str("res://DataFiles/GameData.tres"))
