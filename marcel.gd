extends CharacterBody2D

var current_horizon := 1.0
var speed := 660.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	

	# Handle jump.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("kanan"):
		velocity.x = speed
		current_horizon = 1
	elif Input.is_action_pressed("kiri"):
		velocity.x = -speed
		current_horizon = -1
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 0.07)

	move_and_slide()
