class_name FarmAnimal
extends Node2D

@export_category("Life")
@export var health: int = 100
@export var death_prefab: PackedScene
@export var damage_from_enemies: int = 1
@onready var damage_area: Area2D = $DamageArea

@export_category("Goal")
@export var targetGroup: Node

var damage_digit_prefab
var damage_digit_marker

var check_attacks_interval_length: int = 10
var check_attacks_interval_cooldown: int  = 0

func _ready():
	check_attacks_interval_cooldown = check_attacks_interval_length
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")
	damage_digit_marker = $DamageDigitMarker
	GameManager.animals.append(self)
	$HealthProgressBar.value = health

func _physics_process(delta):
	if not GameManager.game_ended():
		check_attacks_interval_cooldown -= delta
		if (check_attacks_interval_cooldown <= 0):
			get_damage_from_animals()
			check_attacks_interval_cooldown = check_attacks_interval_length

func damage(amount: int) -> void:
	health -= amount
	#print("O animal recebeu dano de ", amount, ". A vida total do enemy eh igual a ", health)
	$HealthProgressBar.value = health;
	modulate = Color.RED

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position  = damage_digit_marker.global_position
	else:
		damage_digit_marker.global_position = global_position 
	
	get_parent().add_child(damage_digit)
	
	if health <= 0:
		GameManager.animals.erase(self)
		die()

func die():
	if (death_prefab):
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	GameManager.animals_defeated_by_enemies += 1
	queue_free()

func get_damage_from_animals() -> void:
	var bodies = damage_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body;
			damage(damage_from_enemies)

