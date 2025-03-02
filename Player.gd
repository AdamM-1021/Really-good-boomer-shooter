extends CharacterBody3D


const SPEED = 6.0
const SPEED_CAP = 12
const JUMP_VELOCITY = 4.5
var momentum = 0

@onready var neck := $Head
@onready var cam := $Head/Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			cam.rotate_x(-event.relative.y * 0.01)
			cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if (SPEED+momentum < SPEED_CAP):
			momentum += .5
		velocity.x = direction.x * (SPEED + momentum)
		velocity.z = direction.z * (SPEED + momentum)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED-momentum)/10)
		velocity.z = move_toward(velocity.z, 0, (SPEED-momentum)/10)
		momentum = move_toward(momentum, 0, .5)

	move_and_slide()
