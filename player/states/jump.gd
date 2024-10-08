extends State

var jump_buffer: bool

func enter() -> void:
    owner.velocity.y = owner.JUMP_VELOCITY
    jump_buffer = true
    
func update(delta: float) -> void:
    if not owner.is_on_floor():
        owner.velocity += owner.get_gravity() * delta * owner.flight_modifier
        jump_buffer = false
    elif owner.is_on_floor() and jump_buffer == false:
        emit_signal("finished", "previous")
    
func player_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
        emit_signal("finished", "glide")            