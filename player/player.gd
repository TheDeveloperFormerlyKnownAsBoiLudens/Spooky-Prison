extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var carry_point: Node3D = $CarryPoint
@onready var interactable_area: Area3D = $InteractableArea

@onready var states_map: Dictionary = {
	"idle": $States/Idle,
	"move": $States/Move
}

var states_stack: Array[State] = []
var current_state: State = null

var input_dir: Vector2
var potential_interactable: RigidBody3D
var interactable_carried: RigidBody3D
var is_carrying: bool = false;

var flight_modifier: float = 1;

func _ready() -> void:
	for state_node: Node in $States.get_children():
		state_node.finished.connect(_change_state)
	states_stack.push_front($States/Idle)
	current_state = states_stack[0]
	_change_state("idle")

func _physics_process(delta: float) -> void:
	current_state.update(delta)
	move_and_slide()
	# Add the gravity.


	move_and_slide()


func _change_state(state_name: String) -> void:
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	else:
		var new_state: State = states_map[state_name]
		states_stack[0] = new_state

	current_state = states_stack[0]
	if state_name != "previous":
		current_state.enter()
	# state_changed.emit(states_stack)
	# state_text.text = current_state.name

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
	if event.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			flight_modifier = 0.01

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
	
