extends Node3D
@onready var player: Node3D = $Player
@onready var player_mat: Node3D = $Player/Ball/MeshInstance3D
var golfball = preload("res://Assets/Materials/GolfBall.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_mat.set_surface_override_material(0, golfball)
