extends StaticBody2D

@onready var health := $HealthComponent as HealthComponent
@onready var hurtbox := $HurtboxComponent as HurtboxComponent
@onready var sprite := $Sprite2D as Sprite2D

enum State {
	IDLE,
	DESTROYED
}

var velocity = Vector2.ZERO
var _state := State.IDLE

const GRAVITY: float = 600.0

var height: float = 0.0
var height_speed: float = 0.0

func _ready() -> void:
	health.died.connect(_on_death)
	hurtbox.hit_recieved.connect(_hit_response)

func _process(delta: float) -> void:
	if _state == State.IDLE:
		velocity *= 0.92 # drag
	position += velocity * delta
	sprite.position = Vector2.UP * height
	handle_airtime(delta)

func _hit_response(data: AttackData) -> void:
	print("Barrel direction", data.direction)
	if _state == State.IDLE:
		height_speed = data.knockback * 2

	velocity = data.direction * data.knockback

func handle_airtime(delta: float) -> void:
	if _state == State.DESTROYED:
		sprite.frame = 1
		modulate.a -= delta
		height += height_speed * delta
		if height < 0:
			height = 0
			queue_free()
		else:
			height_speed -= GRAVITY * delta

func _on_death() -> void:
	_state = State.DESTROYED