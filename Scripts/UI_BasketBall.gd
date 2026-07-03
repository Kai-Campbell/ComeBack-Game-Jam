extends Control
@onready var time: Label = $Time
@onready var time_milli: Label = $TimeMilli
@onready var team: Label = $Team

@onready var timer: Timer = $Timer
@onready var home: Label = $Home
@onready var away: Label = $Away
var timedelta : float = 0.0
var time_done = false
var first_start = false

var homescore = 0
var awayscore = 0

func _ready() -> void:
	first_start = false
	time_done = false
	Global.start_timer.connect(start_process)
	Global.stop_timer.connect(stop_process)
	set_process(false)
	Global.time_up = false
	homescore += randi_range(50, 115)
	awayscore = homescore + randi_range(-2, 2)
	Global.scored_home.connect(increase_home)
	Global.scored_away.connect(increase_away)
	update_score_away()
	update_score_home()
	time.text = "10"
	if Global.team_to_win == "red":
		team.text = "RED"
		team.set("theme_override_colors/font_color", Color("red"))
	else:
		team.text = "GREEN"
		team.set("theme_override_colors/font_color", Color("green"))



func time_left_buzzer():
	var secs = 10 - fmod(timedelta, 60)
	return secs

func time_left_milli():
	var mils = 1000 - fmod(timedelta, 1) * 1000
	return mils

func start_process():
	if time_done == false:
		set_process(true)
	if first_start == false:
		timer.start()
		first_start = true

func stop_process():
	set_process(false)
	timer.stop()


func _process(delta: float) -> void:
	timedelta += delta
	time.text = "%02d" % time_left_buzzer()
	time_milli.text = "%03d" % time_left_milli()

func increase_home(points : int):
	homescore += points
	update_score_home()

func update_score_home():
	home.text = str(homescore)
	Global.home_score = homescore

func increase_away(points : int):
	awayscore += points
	update_score_away()

func update_score_away():
	away.text = str(awayscore)
	Global.away_score = awayscore


func _on_timer_timeout() -> void:
	stop_process()
	time.text = "00"
	time_milli.text = "000"
	time.set("theme_override_colors/font_color", Color("red"))
	time_milli.set("theme_override_colors/font_color", Color("red"))
	time_done = true
	Global.time_up = true
	Global.game_done.emit()
