extends Node

func flip_sprite_h(sprite: Sprite2D, direction: float) -> void:
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

func flip_hitbox_h(hitbox: HitboxComponent, direction: float) -> void:
	if direction > 0:
		hitbox.scale.x = 1.0
		hitbox.data.direction = Vector2.RIGHT
	elif direction < 0:
		hitbox.scale.x = -1.0
		hitbox.data.direction = Vector2.LEFT