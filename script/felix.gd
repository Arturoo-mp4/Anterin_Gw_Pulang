extends  CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_anim: AnimatedSprite2D = $AnimatedSprite2D
var current_horizon := 1
var speed := 400.0
var jump := -670
var energy := 100.0

@onready var marcel: CharacterBody2D = $Marcel
var controller := false
var remote_skill_pressed := false
var max_energy := 100.0

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
	print(position)
	if controller:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("kanan"):
		velocity.x = speed
		current_horizon = 1
	elif Input.is_action_pressed("kiri"):
		velocity.x = -speed
		current_horizon = -1
	else:
		velocity.x = move_toward(velocity.x,0,speed)
		
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
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
	
	move_and_slide()
	
	
	if Input.is_action_just_pressed("remote_control"):
		remote_skill_pressed = !remote_skill_pressed
		print(remote_skill_pressed)
		
	if remote_skill_pressed:
		controller = true
		energy = max_energy
		marcel.on_remoted(global_position)
	if controller:
		energy -= delta
		
	
	if energy >= 0 or not remote_skill_pressed:
		controller = false
		marcel.remote_deactived()
		velocity = Vector2.ZERO
		global_position = marcel.global_position
