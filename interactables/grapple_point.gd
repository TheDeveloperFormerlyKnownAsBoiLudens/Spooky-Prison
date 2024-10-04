extends Node3D

@onready var grapple_user: Node3D = $GrappleUser
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_area_body_entered(body:Node3D) -> void:
	body.reparent(grapple_user)
	body.position = Vector3.ZERO
	anim_player.play("swing")
