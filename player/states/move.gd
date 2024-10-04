
func enter() -> void:
    pass

func update(_delta: float) -> void:
    if not is_on_floor():
        velocity += get_gravity() * delta * flight_modifier
    else:
        flight_modifier = 1

    input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    handle_direction_change()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)