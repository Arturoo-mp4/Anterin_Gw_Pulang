extends CharacterBody2D

@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var collision_deteksi_stuck: CollisionShape2D = $If_collision/CollisionShape2D
var get_stuck := false
var was_stuck := false
var speed := 400.0
var on_control := false
var blink_tween : Tween

func _ready() -> void:
	top_level = true
	remote_deactived()
	collision.set_deferred("disabled", true)

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
		
	
	update_stuck_blink()
	
	move_and_slide()

func remote_active(pos: Vector2):
	
	global_position = pos
	
	on_control = false
	show()
	
	
func remote_deactived():
	on_control = true
	hide()
	velocity = Vector2.ZERO
	
	




func _on_if_collision_body_entered(body: Node2D) -> void:
	if body.name != "Felix":
		get_stuck = true
	else:
		get_stuck = false


func _on_if_collision_body_exited(body: Node2D) -> void:
	get_stuck = false
	modulate = Color.WHITE
	
func update_stuck_blink():
	if get_stuck == was_stuck:
		return 
	was_stuck = get_stuck
	print("stuck berubah jadi: ", get_stuck)
	if blink_tween:
		blink_tween.kill()
		blink_tween = null
	if get_stuck:
		blink_tween = create_tween().set_loops()
		blink_tween.tween_property(self, "modulate", Color.DARK_RED, 0.5)
		blink_tween.tween_property(self, "modulate", Color.WHITE, 0.5)
		
		
	else:
		blink_tween = create_tween()
		blink_tween.tween_property(self, "modulate", Color.WHITE, 0.8)
		
		
		
		
		
