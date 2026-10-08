extends  CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
			animation_player.play("walk_anim")
