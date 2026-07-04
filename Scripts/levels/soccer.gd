extends Node3D
@onready var player: Node3D = $Player
@onready var player_mat: Node3D = $Player/Ball/MeshInstance3D
var soccer = preload("res://Assets/Materials/SoccerBall.tres")


func _ready() -> void:
	player_mat.set_surface_override_material(0, soccer)
