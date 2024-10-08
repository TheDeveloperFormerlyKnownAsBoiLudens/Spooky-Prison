extends State

var speed: float
var input_dir: Vector2
var interactable_area: Area3D
var carry_point: Node3D

func enter() -> void:
	speed = owner.SPEED
	interactable_area = owner.interactable_area
	carry_point = owner.carry_point

func update(delta: float) -> void:
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
		
func handle_direction_change(velocity: Vector3) -> void:
	if velocity.x > 0:
		interactable_area.position.x = 1
		carry_point.position.x = 0.85
	# 	player_sprite.flip_h = true
	elif velocity.x < 0:
		interactable_area.position.x = -1
		carry_point.position.x = -0.85
	# 	player_sprite.flip_h = false

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

