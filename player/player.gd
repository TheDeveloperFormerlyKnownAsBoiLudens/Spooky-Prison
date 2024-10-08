extends CharacterBody3D

signal state_changed(states_stack: Array[State])

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var carry_point: Node3D = $CarryPoint
@onready var interactable_area: Area3D = $InteractableArea

@onready var states_map: Dictionary = {
	"idle": $States/Idle,
	"move": $States/Move,
	"jump": $States/Jump,
	"glide": $States/Glide
}

var states_stack: Array[State] = []
var current_state: State = null
var previous_state: State


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

func _input(event: InputEvent) -> void:
	current_state.player_input(event)

func _change_state(state_name: String) -> void:
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front()
	elif state_name in ["jump"]:
		states_stack.push_front(states_map[state_name])
	else:
		var new_state: State = states_map[state_name]
		states_stack[0] = new_state

	current_state = states_stack[0]
	if state_name != "previous":
		current_state.enter()
	state_changed.emit(states_stack)

func _on_area_3d_body_entered(interactable:Node3D) -> void:
	potential_interactable = interactable

func _on_area_3d_body_exited(_interactable:Node3D) -> void:
	potential_interactable = null
	
