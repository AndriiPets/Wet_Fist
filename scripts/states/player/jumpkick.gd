extends State
class_name StatePlayerJumpKick

func _enter_state() -> void:
	add_to_group("air_state")
	anim.play("jumpkick")
	body.hitbox.enable()

func _physics_update(_delta: float) -> void:
	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	body.velocity = direction * body.speed
	body.flip_sprites(body.velocity.x)