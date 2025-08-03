extends State
class_name StatePlayerTakeoff

func _enter_state() -> void:
	anim.play("takeoff")
	body.velocity = Vector2.ZERO
