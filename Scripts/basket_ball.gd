extends Node3D
@onready var player: Node3D = $Player
@onready var player_mat: Node3D = $Player/Ball/MeshInstance3D
@onready var basket_ball_ui: Control = $"BasketBall UI"

var basketball = preload("res://Assets/Materials/BasketBall.tres")
var inside_arc = false
var can_score = true

func _ready() -> void:
	player_mat.set_surface_override_material(0, basketball)
	Global.away_basket = $AwayBasket.position
	Global.home_basket = $HomeBasket.position
	Global.pass_in_spot = $PassInSpot.position
	Global.point.connect(set_inside)


func _process(_delta: float) -> void:
	end_game()

func set_inside(yesorno):
	inside_arc = yesorno


func end_game(): #this method doesn't work rn
	if !Global.in_play and Global.time_up:
		if (Global.home_score > Global.away_score and Global.team_to_win == "red") or (Global.away_score > Global.home_score and Global.team_to_win == "green"):
			print("you win")
		else:
			print("you lose")

func _on_home_close_body_entered(body: Node3D) -> void:
	if body.is_in_group("HomeTeam"):
		body.close = true

func _on_home_close_body_exited(body: Node3D) -> void:
	if body.is_in_group("HomeTeam"):
		body.close = false

func _on_home_scored_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and can_score:
		if body.touched:
			if inside_arc:
				Global.scored_home.emit(2) 
			else:
				Global.scored_home.emit(3)
	can_score = false
	await get_tree().create_timer(3).timeout #this makes it so the score doesnt ramp up
	can_score = true


func _on_inside_arc_body_entered(body: Node3D) -> void:
	if body.is_in_group("HomeTeam"):
		body.in_arc = true


func _on_inside_arc_body_exited(body: Node3D) -> void:
	if body.is_in_group("HomeTeam"):
		body.in_arc = false




func _on_away_scored_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and can_score:
		if body.touched:
			if inside_arc:
				Global.scored_away.emit(2) 
			else:
				Global.scored_away.emit(3)
	can_score = false
	await get_tree().create_timer(3).timeout #this makes it so the score doesnt ramp up
	can_score = true


func _on_inside_arc_aw_body_entered(body: Node3D) -> void:
	if body.is_in_group("AwayTeam"):
		body.in_arc = true


func _on_inside_arc_aw_body_exited(body: Node3D) -> void:
	if body.is_in_group("AwayTeam"):
		body.in_arc = false

'throw in guy'
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		body.freeze = true
		await get_tree().create_timer(1).timeout
		body.freeze = false
		body.apply_impulse(($PassInSpot.position - %ThrowInGuy.position).normalized() * 30) 
		await get_tree().create_timer(2).timeout
		%ThrowInGuy.visible = false
