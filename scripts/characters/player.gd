class_name Player
extends Actor

@export var jump_intensity: float = 150.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %CharacterSprite
@onready var hitbox: HitboxComponent = %HitboxComponent
@onready var state_machine: StateMachine = %StateMachine

var height: float = 0.0
var height_speed: float = 0.0

var current_state: State

func _physics_process(delta: float) -> void:
	# Delegate the physics process to the current state
	state_machine._physics_process(delta)

	# Handle vertical movement and gravity, which is global to all states
	handle_air_time(delta)
	
	# Apply movement
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Delegate input handling to the current state
	state_machine._unhandled_input(event)

func handle_air_time(delta: float) -> void:
	# This logic is handled here because it's shared across multiple states (Jump, JumpKick, etc.)
	if height > 0 or height_speed != 0:
		height += height_speed * delta
		height_speed -= Globals.GRAVITY * delta

	if height < 0:
		height = 0
		height_speed = 0
		# The Land state will handle the transition back to Idle
		if state_machine.get_current().is_in_group("air_state"):
			state_machine.change_state("Land")

	# Update sprite and hitbox positions based on height
	sprite.position.y = - height
	hitbox.position.y = -13 - height

# Called from animation to signal the end of an attack
func on_action_complete() -> void:
	state_machine.change_state("Idle")

func flip_sprites(direction: float) -> void:
	if direction > 0:
		sprite.flip_h = false
		hitbox.scale.x = 1.0
		hitbox.data.direction = Vector2.RIGHT
	elif direction < 0:
		sprite.flip_h = true
		hitbox.scale.x = -1.0
		hitbox.data.direction = Vector2.LEFT

# Called from animation at the start and end of attacks
func toggle_hitbox() -> void:
	if hitbox.is_enabled:
		hitbox.disable()
	else:
		hitbox.enable()

# Called from the Takeoff animation
func on_takeoff_complete() -> void:
	state_machine.change_state("Jump")
	height_speed = jump_intensity

# Called from the Land animation
func on_land_complete() -> void:
	state_machine.change_state("Idle")
	hitbox.disable()

func _process(_delta: float) -> void:
	var state = state_machine.get_current()
	if state != current_state:
		print(state.name)
		current_state = state