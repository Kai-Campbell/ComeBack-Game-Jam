extends Control
@onready var time: Label = $Time
@onready var timer: Timer = $Timer
@onready var home: Label = $Home
@onready var away: Label = $Away
var timedelta : float = 0.0
var time_done = false

var homescore = 0
var awayscore = 0

func _ready() -> void:
	homescore += randi_range(50, 115)
	awayscore = homescore + randi_range(-2, 2)
	timer.start()
	Global.scored_home.connect(increase_home)
	Global.scored_away.connect(increase_away)
	update_score_away()
	update_score_home()



func time_left_buzzer():
	var mils = 1000 - fmod(timedelta, 1) * 1000
	var secs = 10 - fmod(timedelta, 60)
	
	return  [secs, mils]
	'''
	var time_left = timer.time_left
	var seconds = int(time_left) % 60
	var milli = time_left / 100
	return [seconds, milli]
	'''

func _process(delta: float) -> void:
	timedelta += delta
	time.text = "%02d:%02d" % time_left_buzzer()
	if time_done == true:
		time.text = "00:00"
	

func increase_home(points : int):
	homescore += points
	update_score_home()

func update_score_home():
	home.text = str(homescore)

func increase_away(points : int):
	awayscore += points
	update_score_away()

func update_score_away():
	away.text = str(awayscore)


func _on_timer_timeout() -> void:
	time.set("theme_override_colors/font_color", Color("red"))
	time_done = true
	
