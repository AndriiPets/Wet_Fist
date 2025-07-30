extends Area2D
class_name HitboxComponent

@export var data: AttackData
@export var auto_disable: bool = true

var is_enabled: bool = false

func enable() -> void:
    monitoring = true
    monitorable = true
    visible = true
    is_enabled = true

func disable() -> void:
    monitoring = false
    monitorable = false
    visible = false
    is_enabled = false
    
func _ready() -> void:
    if auto_disable:
        disable()
