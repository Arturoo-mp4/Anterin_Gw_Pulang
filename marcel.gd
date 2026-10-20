extends CharacterBody2D

var current_horizon := 1.0
var speed := 100.0
var active := true

func _physics_process(delta: float) -> void:
	
	if not active:
		return
	if Input.is_action_pressed("atas"):
		velocity.y -= speed
	if Input.is_action_pressed("bawah"):
		velocity.y += speed
	if Input.is_action_pressed("kanan"):
		velocity.x += speed
	if Input.is_action_pressed("kiri"):
		velocity.x -= speed
	
	move_and_slide()
