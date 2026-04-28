extends AudioStreamPlayer

@export var music = preload("res://Assets/Music/ShoveThisInaGameJamGame.mp3")

func _play_music():
	if playing:
		return
	
	stream = music
	play()

func _stop_music():
	stop()
	
func is_on():
	return playing
