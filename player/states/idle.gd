extends State


func update(delta: float) -> void:
	var velocity: Vector3 = owner.velocity
	if not owner.is_on_floor():
		velocity += owner.get_gravity() * delta * owner.flight_modifier
	else:
		owner.flight_modifier = 1
	var move_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_dir != Vector2.ZERO:
		emit_signal("finished", "move")
	# if Input.is_action_just_pressed("dash"):
	# 	emit_signal("finished", "dash")

func player_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if owner.is_on_floor():
			emit_signal("finished", "jump")

	if event.is_action_pressed("interact"):
		if owner.interactable_carried == null and owner.potential_interactable != null:
			owner.interactable_carried = owner.potential_interactable
			owner.interactable_carried.reparent(owner.carry_point)
			owner.interactable_carried.position = Vector3.ZERO
			owner.interactable_carried.gravity_scale = 0
		elif owner.interactable_carried == null and owner.potential_interactable == null:
			pass
		else:
			owner.interactable_carried.reparent(owner.get_parent())
			owner.interactable_carried.gravity_scale = 1
			owner.interactable_carried = null
