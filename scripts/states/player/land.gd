extends State
class_name StatePlayerLand

func _enter_state() -> void:
	anim.play("land")
	body.velocity = Vector2.ZERO