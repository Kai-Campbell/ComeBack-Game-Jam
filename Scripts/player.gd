extends RigidBody3D
@export var moving_force = 400
@export var jump_force = 10
@export var friction = 1.2
@export var air_movement_speed = 10

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
		linear_velocity.y += 40
		
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
	
	
