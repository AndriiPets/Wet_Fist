extends Node
class_name HealthComponent

@export var max_health := 1

var health_ammount: int:
    set(v):
        var prev = health_ammount
        health_ammount = v
        healh_changed.emit(health_ammount, prev)
        print("heath changed current:", health_ammount)
        if health_ammount <= 0:
            died.emit()

signal died()
signal healh_changed(current: int, previous: int)

func _ready() -> void:
    health_ammount = max_health

func damage(num: int) -> void:
    health_ammount -= num

func heal(num: int) -> void:
    health_ammount += num
