extends State

var speed: float
var input_dir: Vector2
var interactable_area: Area3D
var carry_point: Node3D

func enter() -> void:
    owner.flight_modifier = 0.05
    owner.velocity.y = 0
    speed = owner.SPEED
    interactable_area = owner.interactable_area
    carry_point = owner.carry_point
    
func update(delta: float) -> void:
    
    if not owner.is_on_floor():
        owner.velocity += owner.get_gravity() * delta * owner.flight_modifier
    elif owner.is_on_floor():
        emit_signal("finished", "previous")
    var velocity: Vector3 = owner.velocity
	# Add the gravity.
    if not owner.is_on_floor():
        velocity += owner.get_gravity() * delta * owner.flight_modifier
    else:
        owner.flight_modifier = 1
    input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction: Vector3 = (owner.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    handle_direction_change(velocity)
    if direction:
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)
    owner.velocity = velocity
    
# func player_input(event: InputEvent) -> void:
    # if event.is_action_pressed("jump"):
        # owner.flight_modifier = 0.05
            
func handle_direction_change(velocity: Vector3) -> void:
    if velocity.x > 0:
        interactable_area.position.x = 1
        carry_point.position.x = 0.85
	# 	player_sprite.flip_h = true
    elif velocity.x < 0:
        interactable_area.position.x = -1
        carry_point.position.x = -0.85
	# 	player_sprite.flip_h = false