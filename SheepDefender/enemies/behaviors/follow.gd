extends Node

@export var speed: float = 1.0;

@onready var sprite : AnimatedSprite2D

var enemy: Enemy

var animal: FarmAnimal = null
var follow_animal: bool = false

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	if randf() < 0.2:
		follow_animal = true

func get_target():
	if follow_animal:
		var n = GameManager.animals.size()
		if n > 0 and animal == null:
			#print("Segue animal")
			animal = GameManager.animals[randi_range(0, n-1)]
		if animal != null:
			return animal		
	#print("Segue player")
	return GameManager.player

func get_direction_to():
	if enemy == null: return Vector2.ZERO; 
	var dir = (get_target().position - enemy.position)
	if dir.is_zero_approx():
		return Vector2.ZERO
	return  dir.normalized()

func _physics_process(delta):
	if GameManager.game_ended(): return
	#velocity = alguma coisa
	var dir = get_direction_to()
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
