extends Control

var current_page = 1
var max_pages = 2
@onready var next_page = $NextPage
@onready var prev_page = $PrevPage
@onready var levels_page_1 = $LevelsPage1
@onready var levels_page_2 = $LevelsPage2

func Start():
	current_page = 1
	PageSwitch()
	next_page.disabled = false
	prev_page.disabled = true

func PageSwitch():
	match current_page:
		1:
			levels_page_1.visible = true
			levels_page_2.visible = false
		2:
			levels_page_1.visible = false
			levels_page_2.visible = true

func _on_next_page_pressed():
	current_page += 1
	PageSwitch()
	prev_page.disabled = false
	if current_page == max_pages:
		next_page.disabled = true

func _on_prev_page_pressed():
	current_page -= 1
	PageSwitch()
	next_page.disabled = false
	if current_page == 1:
		prev_page.disabled = true
