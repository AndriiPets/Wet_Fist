extends Area2D
class_name HitboxComponent

@export var data: AttackData
@export var auto_disable: bool = true

func enable() -> void:
    monitoring = true
    monitorable = true
    visible = true

func disable() -> void:
    monitoring = false
    monitorable = false
    visible = false

func _ready() -> void:
    if auto_disable:
        disable()
