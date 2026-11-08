extends CharacterBody2D

@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var stuck_area: Area2D = $If_collision
var get_stuck := false
var was_stuck := false
var speed := 400.0
var on_control := false
var blink_tween : Tween
var grace_frames := 0


func _ready() -> void:
	top_level = true
	remote_deactived()
	collision.set_deferred("disabled", true)

func _physics_process(delta: float) -> void:
	if  on_control:
		return
	print(grace_frames)
	var dir_x := Input.get_axis("kiri", "kanan")
	var dir_y := Input.get_axis("atas", "bawah")
	var dir = Vector2(dir_x, dir_y).normalized()
	
	if dir:
		velocity = dir * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 0.02)
	
	move_and_slide()
	
	if grace_frames > 0:
		grace_frames -= 1
	else:
		get_stuck = is_overlapping_wall()
	update_stuck_blink()
	

func remote_active(pos: Vector2):
	
	global_position = pos
	_reset_stuck()
	grace_frames = 2
	on_control = false
	show()
	
	
func remote_deactived():
	on_control = true
	hide()
	velocity = Vector2.ZERO
	_reset_stuck()
	





	
func update_stuck_blink():
	if get_stuck == was_stuck:
		return 
	was_stuck = get_stuck
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
		
		
		
		
		
func is_overlapping_wall() -> bool:
	for body in stuck_area.get_overlapping_bodies():
		if body != get_parent():
			return true
	return false
func _reset_stuck():
	get_stuck = false
	was_stuck = false
	if blink_tween:
		blink_tween.kill()
		blink_tween = null
	modulate = Color.WHITE
