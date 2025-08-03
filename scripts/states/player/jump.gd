extends State
class_name StatePlayerJump

func _enter_state() -> void:
	add_to_group("air_state") # Used to check if we are in the air
	anim.play("jump")

func _physics_update(_delta: float) -> void:
	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	body.velocity = direction * body.speed
	body.flip_sprites(body.velocity.x)

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ATTACK"):
		fsm.change_state("JumpKick")
