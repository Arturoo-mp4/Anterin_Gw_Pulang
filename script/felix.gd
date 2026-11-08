extends  CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_anim: AnimatedSprite2D = $AnimatedSprite2D
var current_horizon := 1
var speed := 400.0
var jump := -670
var energy := 100.0

@onready var marcel: CharacterBody2D = $Marcel
var controller := false

var max_energy := 100.0
var last_valid_pos := Vector2.ZERO

@export var energy_bar := Node


enum State{
	IDLE,
	RUN,
	JUMP,
	ATTACK,
	FALL
}

var state = State.IDLE

func _ready() -> void:
	animation_player.play("idle_anim")
	add_collision_exception_with(marcel)
	marcel.add_collision_exception_with(self)
	
	
	
func change_state(new_state):
	
	if state == new_state:
		return
	
	state = new_state
	
	match state:
		
			State.IDLE:
				animation_player.play("idle_anim")
			State.RUN:
				animation_player.play("run_anim")
			State.JUMP:
				animation_player.play("jump_anim")
			State.FALL:
				animation_player.play("fall_anim")
				
			
func _physics_process(delta: float) -> void:
	energy_bar.value = energy
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if controller:
		velocity.x = 0
	else:
		if Input.is_action_pressed("kanan"):
			velocity.x = speed
			current_horizon = 1
		elif Input.is_action_pressed("kiri"):
			velocity.x = -speed
			current_horizon = -1
		else:
			velocity.x = move_toward(velocity.x,0,speed)
			
		if Input.is_action_pressed("ui_accept") and is_on_floor() and not controller:
				velocity.y = jump
	
#state
	if not is_on_floor():
		if velocity.y < 0:
			change_state(State.JUMP)
		else:
			change_state(State.FALL)
		
	elif velocity.x != 0:
		change_state(State.RUN)
	else:
		change_state(State.IDLE)
	
	#flip current_horizon
	sprite_anim.flip_h = current_horizon < 0
	
	
#remote
	if Input.is_action_just_pressed("remote_control"):
		controller = !controller
		if controller:
			start_remote()
			last_valid_pos = global_position
		else:
			end_remote()
	if controller:
		velocity.x = 0
		energy -= delta
		if energy <= 0:
			end_remote()
	else:
		energy += 0.2
		if energy >= 100:
			energy = 100
	move_and_slide()
	
#skill remote_control
func start_remote():
	if energy <= 0:
		end_remote()
		return
	controller = true
	marcel.remote_active(global_position)
	
	
func end_remote():
	controller = false
	global_position = marcel.global_position
	if marcel.get_stuck:
		global_position = last_valid_pos
		felix_get_stuck_modulate()
	velocity = Vector2.ZERO
	marcel.remote_deactived()


func felix_get_stuck_modulate():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.DARK_RED, 0.4)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.4)
