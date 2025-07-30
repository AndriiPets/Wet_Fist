extends CharacterBody2D

@export var speed: float = 50.0
@export var jump_intensity: float = 150.0

@onready var animation: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %CharacterSprite

@onready var hitbox := %HitboxComponent as HitboxComponent
@onready var hurtbox := %HurtboxComponent as HurtboxComponent

enum PlayerState {
	IDLE,
	WALK,
	ATTACK,
	TAKEOFF,
	JUMP,
	LAND,
	JUMPKICK
}

var height: float = 0.0
var height_speed: float = 0.0
var _state := PlayerState.IDLE

var anim_map := {
	PlayerState.IDLE: "idle",
	PlayerState.WALK: "walk",
	PlayerState.ATTACK: "punch",
	PlayerState.TAKEOFF: "takeoff",
	PlayerState.JUMP: "jump",
	PlayerState.LAND: "land",
	PlayerState.JUMPKICK: "jumpkick",
}

func _process(_delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animatons()
	handle_air_time(_delta)
	flip_sprites()
	sprite.position = Vector2.UP * height
	hurtbox.position = Vector2.UP * height
	move_and_slide()

func handle_input() -> void:
	var direction := Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	velocity = direction * speed
	if can_attack() && Input.is_action_just_pressed("ATTACK"):
		_state = PlayerState.ATTACK
	if can_jump() && Input.is_action_pressed("JUMP"):
		_state = PlayerState.TAKEOFF
	if can_jumpkick() && Input.is_action_just_pressed("ATTACK"):
		_state = PlayerState.JUMPKICK
		hitbox.enable()

func handle_movement() -> void:
	if can_move():
		if velocity.is_zero_approx():
			_state = PlayerState.IDLE
		else:
			_state = PlayerState.WALK
	
func flip_sprites() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		hitbox.scale.x = 1.0

		hitbox.data.direction = Vector2.RIGHT
	elif velocity.x < 0:
		sprite.flip_h = true
		hitbox.scale.x = -1.0

		hitbox.data.direction = Vector2.LEFT

func handle_animatons() -> void:
	if not animation.has_animation(anim_map[_state]):
		push_error("Player dosent have animation:", anim_map[_state])
	animation.play(anim_map[_state])

func handle_air_time(delta: float) -> void:
	if _state != PlayerState.JUMP && _state != PlayerState.JUMPKICK:
		return
	
	height += height_speed * delta

	if height < 0:
		height = 0
		_state = PlayerState.LAND
	else:
		height_speed -= Globals.GRAVITY * delta

func can_attack() -> bool:
	return _state == PlayerState.IDLE || _state == PlayerState.WALK

func can_jump() -> bool:
	return _state == PlayerState.IDLE || _state == PlayerState.WALK

func can_move() -> bool:
	return _state == PlayerState.WALK || _state == PlayerState.IDLE

func can_jumpkick() -> bool:
	return _state == PlayerState.JUMP

func on_action_complete() -> void:
	_state = PlayerState.IDLE

func toggle_hitbox() -> void:
	if hitbox.is_enabled:
		hitbox.disable()
	else:
		hitbox.enable()

func on_takeoff_complete() -> void:
	_state = PlayerState.JUMP
	height_speed = jump_intensity

func on_land_complete() -> void:
	_state = PlayerState.IDLE
	hitbox.disable()