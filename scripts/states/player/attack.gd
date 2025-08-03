extends State
class_name StatePlayerAttack

func _enter_state() -> void:
	anim.play("punch")
	body.velocity = Vector2.ZERO