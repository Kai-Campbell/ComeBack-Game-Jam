extends RigidBody3D
@export var moving_force = 30
@export var jump_force = 10
var camera_speed = 10

func _ready():
	pass

func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("forward"):
		angular_velocity.x -= moving_force * delta
	if Input.is_action_pressed("backward"):
		angular_velocity.x += moving_force * delta
	if Input.is_action_pressed("left"):
		angular_velocity.z += moving_force * delta
	if Input.is_action_pressed("right"):
		angular_velocity.z -= moving_force * delta
		
	if Input.is_action_just_pressed("jump"):
		linear_velocity.y += 10
	
	$CameraRig.position = lerp($CameraRig.position, position, camera_speed * delta)
