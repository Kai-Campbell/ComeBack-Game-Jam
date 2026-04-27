extends Control
@onready var win_text: Label = $WinText


func _ready() -> void:
	var rand = randi_range(1, 2)
	if rand == 1:
		win_text.text = "RED"
		Global.team_to_win = "red"
	else:
		win_text.text = "GREEN"
		Global.team_to_win = "green"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/basket_ball.tscn")
