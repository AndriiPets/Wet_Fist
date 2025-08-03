extends State
class_name StatePlayerIdle

func _enter_state() -> void:
	anim.play("idle")
	body.velocity = Vector2.ZERO

func _physics_update(_delta: float) -> void:
	if Input.get_vector("LEFT", "RIGHT", "UP", "DOWN") != Vector2.ZERO:
		fsm.change_state("Walk")

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ATTACK"):
		fsm.change_state("Attack")
	if event.is_action_pressed("JUMP"):
		fsm.change_state("Takeoff")