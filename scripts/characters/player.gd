extends CharacterBody2D

@export var speed: float = 50.0

@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %CharacterSprite

@onready var hitbox := $HitboxComponent as HitboxComponent

enum PlayerState {
	IDLE,
	WALK,
	ATTACK
}

var _state := PlayerState.IDLE

func _physics_process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animatons()
	move_and_slide()

func handle_input() -> void:
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = direction * speed
	if can_attack() && Input.is_action_just_pressed("ATTACK"):
		_state = PlayerState.ATTACK

func handle_movement() -> void:
	if can_move():
		if velocity.is_zero_approx():
			_state = PlayerState.IDLE
		else:
			_state = PlayerState.WALK
	else:
		velocity = Vector2.ZERO
	
	if velocity.x > 0:
		sprite.flip_h = false
		hitbox.scale.x = 1.0

		hitbox.data.direction = Vector2.RIGHT
	elif velocity.x < 0:
		sprite.flip_h = true
		hitbox.scale.x = -1.0

		hitbox.data.direction = Vector2.LEFT

func handle_animatons() -> void:
	match _state:
		PlayerState.IDLE:
			animation.play("idle")
		PlayerState.WALK:
			animation.play("walk")
		PlayerState.ATTACK:
			animation.play("punch")

func can_attack() -> bool:
	return _state == PlayerState.IDLE || _state == PlayerState.WALK

func can_move() -> bool:
	return _state == PlayerState.WALK || _state == PlayerState.IDLE

func on_action_complete() -> void:
	_state = PlayerState.IDLE
	hitbox.disable()

func toggle_hitbox() -> void:
	hitbox.enable()
