extends Node

@export var speed: float = 1.0;

var targets: Array[Marker2D]

@onready var sprite : AnimatedSprite2D

var animal: FarmAnimal
var current_target: Marker2D

func _ready():
	var targetGroup = get_parent().targetGroup;
	var has_targets: bool = false
	if (targetGroup):
		var nc = targetGroup.get_child_count()
		if nc > 0:
			for i in range(nc):
				var c = targetGroup.get_child(i)
				if c is Marker2D:
					has_targets = true
					targets.append(c)
	if not has_targets:
		for i in range(5):
			var marker = Marker2D.new()
			var size = get_viewport().get_window().size
			marker.position = Vector2(size.x * randf(), size.y * randf())
			get_tree().root.add_child(marker)
			targets.append(marker)
	current_target = targets[randi_range(0, targets.size()-1)]
	animal = get_parent()
	sprite = animal.get_node("AnimatedSprite2D")
	
func get_direction_to_target():
	var dir = (current_target.position - animal.position)
	if dir.is_zero_approx():
		return Vector2.ZERO
	return  dir.normalized()

func meet_target():
	return current_target.position.distance_to(animal.position) <= 1


func _physics_process(delta):
	if GameManager.is_game_over: return

	if meet_target():
		var idx = randi_range(0, targets.size()-1)
		print("New target ", idx)
		current_target = targets[idx]	
			
	#velocity = alguma coisa
	var dir = get_direction_to_target()
	#velocity = lerp(velocity,  dir * speed * 100.0, 0.2)
	animal.velocity = dir * speed * 100
	animal.move_and_slide()
	rotate_sprite(dir)

func rotate_sprite(dir):
		#girar sprite
	if dir.x > 0:
		sprite.flip_h = false
	elif dir.x < 0:
		sprite.flip_h = true
