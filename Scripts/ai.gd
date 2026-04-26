extends CharacterBody3D

enum STATE {Wander, Run, Wait, Shoot, Idle}
var state : STATE = STATE.Idle
var wait_timer = 0.5
var wait_timer_count = 0.0
var time_till_reset = 6.0
var reset_timer = 0.0

@export var home : bool
@onready var shirt: MeshInstance3D = $Shirt
@export var shirt_color : StandardMaterial3D = preload("res://Assets/Materials/Red.tres")
@onready var navigation_agent_3d: NavigationAgent3D = $Feet/NavigationAgent3D

'BasketBall Variables'
var shoot_strength = 25
var arc_strength = 5
var move_speed = 20
var close = false
var in_arc = false
var has_ball = false
var ball_close = false
@export var ball_path : NodePath
var ball
var start_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shirt.set_material_override(shirt_color)
	ball = get_node(ball_path)
	start_pos = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	
	match state:
		STATE.Idle:
			idle()
		STATE.Wait:
			wait(delta)
		STATE.Wander:
			wander()
		STATE.Run:
			run()
	
	move_and_slide()


func idle():
	reset_timer = time_till_reset
	velocity = Vector3.ZERO
	wait_timer_count = wait_timer
	state = STATE.Wait
	

func wait(delta):
	reset_timer -= delta
	wait_timer_count -= delta
	if wait_timer_count <= 0.0:
		var target = get_random_spot()
		var nav_map = navigation_agent_3d.get_navigation_map()
		var safe_target = NavigationServer3D.map_get_closest_point(nav_map, target)
		navigation_agent_3d.target_position = safe_target
		state = STATE.Wander
	if time_till_reset <= 0.0:
		state = STATE.Idle


func wander():
	var current_pos = global_position
	var next_pos = navigation_agent_3d.get_next_path_position()
	var direction = (next_pos - current_pos).normalized()
	velocity = direction * move_speed
	if ball_close:
		state = STATE.Run

func run():
	var current_pos = global_position
	if ball == null:
		state = STATE.Idle
	navigation_agent_3d.target_position = ball.global_position
	var next_pos = navigation_agent_3d.get_next_path_position()
	var direction = (next_pos - current_pos).normalized()
	velocity = direction * move_speed

func _on_navigation_agent_3d_target_reached() -> void:
	if ball_close:
		state = STATE.Run
	else:
		state = STATE.Idle

func get_random_spot():
	var x = randi_range(-50, 50)
	var z = randi_range(-15, 15)
	return Vector3(start_pos.x - x, start_pos.y, start_pos.z - z)

func _on_ball_detection_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		ball = body
		ball_close = true

func _on_ball_detection_body_exited(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		ball_close = false

func _on_shoot_box_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		shoot_ball(body)

func shoot_ball(body):
	state = STATE.Idle
	has_ball = true
	body.touched = true
	var random_hoop_pos
	var rand_x = randi_range(-25, 25)
	var rand_y = randi_range(30, 40)
	body.freeze = true
	body.global_position = $Head.global_position
	if home:
		random_hoop_pos = Vector3(Global.away_basket.x + rand_x, (Global.away_basket.y + rand_y), Global.away_basket.z)
	else:
		random_hoop_pos = Vector3(Global.home_basket.x + rand_x, (Global.home_basket.y + rand_y), Global.home_basket.z)
	await get_tree().create_timer(0.5).timeout
	body.freeze = false
	if close:
		print("close")
		body.apply_central_impulse((random_hoop_pos - global_position).normalized() * shoot_strength * 1.1)
	elif abs(global_position.z - random_hoop_pos.z) > 140:
		body.apply_central_impulse((random_hoop_pos - global_position).normalized() * shoot_strength * 1.7)
		body.apply_impulse(global_basis.y * arc_strength * 2)
	else:
		body.apply_central_impulse((random_hoop_pos - global_position).normalized() * shoot_strength)
		body.apply_impulse(global_basis.y * arc_strength)
	Global.point.emit(in_arc)
	has_ball = false
