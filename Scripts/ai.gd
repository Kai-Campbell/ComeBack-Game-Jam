extends Node3D

enum STATE {Wander, Run, Wait, Shoot, Idle}
var state : STATE = STATE.Wander
var idle_timer = 0.3

@export var home : bool
@onready var shirt: MeshInstance3D = $CharacterBody3D/Shirt
@export var shirt_color : StandardMaterial3D = preload("res://Assets/Materials/Red.tres")
@onready var navigation_agent_3d: NavigationAgent3D = $CharacterBody3D/NavigationAgent3D

'BasketBall Variables'
var shoot_strength = 40
var arc_strength = 10
var move_speed = 4
var close = false
var in_arc = false
var has_ball = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shirt.set_material_override(shirt_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !has_ball:
		match state:
			STATE.Idle:
				idle(delta)
			STATE.Wander:
				wander()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		has_ball = true
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
			body.apply_central_impulse((random_hoop_pos - global_position).normalized() * shoot_strength * 0.8)
		elif abs(global_position.z - random_hoop_pos.z) > 110:
			body.apply_central_impulse((random_hoop_pos - global_position).normalized() * shoot_strength * 1.7)
			body.apply_impulse(global_basis.y * arc_strength * 2)
		else:
			body.apply_central_impulse((random_hoop_pos - global_position).normalized() * shoot_strength)
			body.apply_impulse(global_basis.y * arc_strength)
		Global.point.emit(in_arc)
		has_ball = false
		
		#grabbed.emit()
		#$Head.position


func idle(delta):
	$CharacterBody3D.velocity = Vector3.ZERO
	idle_timer -= delta
	if idle_timer <= 0.0:
		navigation_agent_3d.target_position = get_random_spot()
		state = STATE.Wander

func wander():
	var current_pos = global_position
	var next_pos = navigation_agent_3d.get_next_path_position()
	var direction = (next_pos - current_pos).normalized()
	$CharacterBody3D.velocity = direction * move_speed
	

func _on_navigation_agent_3d_target_reached() -> void:
	state = STATE.Idle

func get_random_spot():
	var x = randi_range(-50, 50)
	var z = randi_range(-15, 15)
	return Vector3(global_position.x - x, global_position.y, global_position.z - z)
