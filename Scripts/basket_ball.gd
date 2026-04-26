extends Node3D
@onready var player: Node3D = $Player
@onready var player_mat: Node3D = $Player/Ball/MeshInstance3D
var basketball = preload("res://Assets/Materials/BasketBall.tres")
var inside_arc = false

func _ready() -> void:
	player_mat.set_surface_override_material(0, basketball)
	Global.away_basket = $AwayBasket.position
	Global.home_basket = $HomeBasket.position
	Global.point.connect(set_inside)

func set_inside(yesorno):
	inside_arc = yesorno

func _on_home_close_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("HomeTeam"):
		body.owner.close = true

func _on_home_close_body_exited(body: Node3D) -> void:
	if body.owner.is_in_group("HomeTeam"):
		body.owner.close = false

func _on_home_scored_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		if inside_arc:
			Global.scored_home.emit(2) 
		else:
			Global.scored_home.emit(3)
	await get_tree().create_timer(3).timeout #this makes it so the score doesnt ramp up


func _on_inside_arc_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("HomeTeam"):
		body.owner.in_arc = true


func _on_inside_arc_body_exited(body: Node3D) -> void:
	if body.owner.is_in_group("HomeTeam"):
		body.owner.in_arc = false




func _on_away_scored_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("Player"):
		if inside_arc:
			Global.scored_away.emit(2) 
		else:
			Global.scored_away.emit(3)
	await get_tree().create_timer(3).timeout #this makes it so the score doesnt ramp up


func _on_inside_arc_aw_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("AwayTeam"):
		body.owner.in_arc = true


func _on_inside_arc_aw_body_exited(body: Node3D) -> void:
	if body.owner.is_in_group("AwayTeam"):
		body.owner.in_arc = false
