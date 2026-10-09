extends  CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_anim: AnimatedSprite2D = $AnimatedSprite2D
var current_horizon := 1
var speed := 400.0
var jump := -470
enum State{
	IDLE,
	RUN,
	JUMP,
	ATTACK
}
var state = State.IDLE

func _ready() -> void:
	change_state(State.IDLE)
	
	
func change_state(new_state):
	state = new_state
	
	match state:
		State.IDLE:
			animation_player.play("idle_anim")
		State.RUN:
			animation_player.play("run_anim")
			
				
			
func _physics_process(delta: float) -> void:
	
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
		
	if velocity.x != 0:
		change_state(State.RUN)
	elif velocity.x == 0:
		change_state(State.IDLE)
	
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = jump
		
	#flip current_horizon
	if current_horizon >= 1:
		sprite_anim.flip_h = false
	elif current_horizon <= -1:
		sprite_anim.flip_h = true
	
	move_and_slide()
	
