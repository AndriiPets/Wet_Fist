extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var hit_cooldown: float = 0.5

@onready var hit_timer := Timer.new()

signal hit_recieved(data: AttackData)

func _ready() -> void:
	add_child(hit_timer)
	hit_timer.one_shot = true
	hit_timer.wait_time = hit_cooldown

	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	
	if not hit_timer.is_stopped():
		print("on hit cooldown")
		return

	print("hit")
	var hitbox: HitboxComponent = area
	hit_recieved.emit(hitbox.data)
	if health_component:
		health_component.damage(hitbox.data.damage)
	
	hit_timer.start()
