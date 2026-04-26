extends RigidBody3D
@export var moving_force = 1000
@export var jump_force = 20
@export var air_jump_force = 1.2
@export var friction = 1.1
@export var air_movement_speed = 50
@export var gravity = 0.4
var touched = false
var inside_arc = false

@onready var camera_gimbal: Node3D = $"../CameraGimbal"

func _ready():
	Global.scored_away.connect(no_touch)
	Global.scored_home.connect(no_touch)

func _physics_process(delta: float) -> void:
	linear_velocity += get_gravity() * delta
	var input_direction = Input.get_vector("left", "right", "forward", "backward");
	var direction = (Vector3(input_direction.x, 0, input_direction.y).normalized())
	direction = direction.rotated(Vector3.UP, $"../CameraGimbal/SpringArm3D/Camera3D".global_rotation.y)
	if direction:
		angular_velocity.x = direction.z * moving_force * delta
		angular_velocity.z = -direction.x * moving_force * delta
	else:
		angular_velocity /= friction
		#angular_velocity.x = move_toward(direction.z, 0, moving_force * delta)
		#angular_velocity.z = move_toward(-direction.x, 0, moving_force * delta)
	
	if Input.is_action_just_pressed("jump"):
		linear_velocity.y = jump_force
		if global_position.y > 10:
			linear_velocity.y += air_jump_force
	
	if global_position.y > 3:
		var forward = $"../CameraGimbal/SpringArm3D/Camera3D".global_basis.z
		var right = $"../CameraGimbal/SpringArm3D/Camera3D".global_basis.x
		var move_direction = forward * input_direction.y + right * input_direction.x
		move_direction.y = 0.0
		move_direction = move_direction.normalized()
		
		linear_velocity = linear_velocity.move_toward(move_direction * air_movement_speed, 20 * delta)
		linear_velocity.y -= gravity  #this is hard coded gravity I know it sucks it's just the best thing I could find
	
	
	if global_position.y <= -17:
		touched = false
	
	if !touched and Global.time_up:
		Global.in_play = false

func no_touch(_num):
	print("this is working")
	await get_tree().create_timer(2).timeout
	touched = false

	'''
	if Input.is_action_pressed("forward"):
		angular_velocity.x -= moving_force * delta
	if Input.is_action_pressed("backward"):
		angular_velocity.x += moving_force * delta
	if Input.is_action_pressed("left"):
		angular_velocity.z += moving_force * delta
	if Input.is_action_pressed("right"):
		angular_velocity.z -= moving_force * delta
		
	
		
	angular_velocity /= friction
	
	linear_velocity += get_gravity() * delta
	
	if global_position.y >= 20:
		if Input.is_action_pressed("forward"):
			global_position.z -= air_movement_speed * delta
		if Input.is_action_pressed("backward"):
			global_position.z += air_movement_speed * delta
		if Input.is_action_pressed("left"):
			global_position.x -= air_movement_speed * delta
		if Input.is_action_pressed("right"):
			global_position.x += air_movement_speed * delta
	'''
	
	
