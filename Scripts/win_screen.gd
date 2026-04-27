extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/goal_screen.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_meu.tscn")
