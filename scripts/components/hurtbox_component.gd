extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

signal hit_recieved(data: AttackData)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not area is HitboxComponent:
		return
	
	var hitbox: HitboxComponent = area
	hit_recieved.emit(hitbox.data)
	if health_component:
		health_component.damage(hitbox.data.damage)
