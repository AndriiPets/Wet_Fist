extends Node2D

@onready var camera := %Camera2D as Camera2D
@onready var player := %Player as CharacterBody2D

func _process(_delta: float) -> void:
    if player.position.x > camera.position.x:
        camera.position.x = player.position.x
