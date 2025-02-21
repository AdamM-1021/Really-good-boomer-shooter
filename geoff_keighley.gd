extends CharacterBody3D


var SPEED = 2.5
var t = 0

func _process(delta):
	t += delta
	if t >= 1:
		t = 0
		SPEED *= -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = SPEED
	velocity.z = 0


	move_and_slide()
