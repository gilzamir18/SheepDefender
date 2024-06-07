extends Node

@export var speed: float = 1.0;

@onready var sprite : AnimatedSprite2D

var enemy: Enemy

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func get_direction_to_player():
	var dir = (GameManager.player_position - enemy.position)
	if dir.is_zero_approx():
		return Vector2.ZERO
	return  dir.normalized()

func _physics_process(delta):
	if GameManager.game_ended(): return
	#velocity = alguma coisa
	var dir = get_direction_to_player()
	#velocity = lerp(velocity,  dir * speed * 100.0, 0.2)
	enemy.velocity = dir * speed * 100
	enemy.move_and_slide()
	rotate_sprite(dir)

func rotate_sprite(dir):
		#girar sprite
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
