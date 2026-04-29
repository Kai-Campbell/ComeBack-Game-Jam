extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	await $Timer.timeout
	$AudioStreamPlayer2D.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/goal_screen.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_meu.tscn")
