extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var carry_point: Node3D = $CarryPoint
@onready var interactable_area: Area3D = $InteractableArea

var input_dir: Vector2
var potential_interactable: RigidBody3D
var interactable_carried: RigidBody3D
var is_carrying: bool = false;

func _ready() -> void:
	print(get_parent())

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	handle_direction_change()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func handle_direction_change() -> void:
	if velocity.x > 0:
		interactable_area.position.x = 1
		carry_point.position.x = 0.85
	# 	player_sprite.flip_h = true
	elif velocity.x < 0:
		interactable_area.position.x = -1
		carry_point.position.x = -0.85
	# 	player_sprite.flip_h = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interactable_carried == null and potential_interactable != null:
			interactable_carried = potential_interactable
			interactable_carried.reparent(carry_point)
			interactable_carried.position = Vector3.ZERO
			interactable_carried.gravity_scale = 0
		elif interactable_carried == null and potential_interactable == null:
			pass
		else:
			interactable_carried.reparent(self.get_parent())
			interactable_carried.gravity_scale = 1
			interactable_carried = null

	
func _on_area_3d_body_entered(interactable:Node3D) -> void:
	potential_interactable = interactable

func _on_area_3d_body_exited(_interactable:Node3D) -> void:
	potential_interactable = null
	
