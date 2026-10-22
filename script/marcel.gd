extends CharacterBody2D

@onready var hitbox : CollisionShape2D = $CollisionShape2D

var speed := 400.0
var on_control := false

func _ready() -> void:
	top_level = true

func _physics_process(delta: float) -> void:
	if  on_control:
		return
	
	var dir_x := Input.get_axis("kiri", "kanan")
	var dir_y := Input.get_axis("atas", "bawah")
	var dir = Vector2(dir_x, dir_y).normalized()
	
	if dir:
		velocity = dir * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 0.02)

	move_and_slide()

func on_remoted(pos: Vector2):
	global_position = pos
	on_control = true
	show()
	
func remote_deactived():
	on_control = false
	hide()
	velocity = Vector2.ZERO
	
