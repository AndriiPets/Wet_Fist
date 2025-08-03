extends State
class_name StatePlayerWalk

func _enter_state() -> void:
	anim.play("walk")

#TODO: create velocity component and pass it to the state machine

func _physics_update(_delta: float) -> void:
	var dir = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	body.velocity = dir * body.speed

	if body.velocity.is_zero_approx():
		fsm.change_state("Idle")

	body.flip_sprites(body.velocity.x)

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ATTACK"):
		fsm.change_state("Attack")
	if event.is_action_pressed("JUMP"):
		fsm.change_state("Takeoff")
