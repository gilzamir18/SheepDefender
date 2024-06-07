class_name Player
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

@export_category("Movement")
@export var speed = 3

@export_category("Sword")
@export var sword_damage: int = 2

@export_category("Ritual")
@export var ritual_damage:int = 10
@export var ritual_interval:float = 10
@export var ritual_scene: PackedScene

@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
@export var death_prefab: PackedScene
@export var mission_maximum_size: int = 60

signal meat_collected(value:int)

var is_running: bool = false
var is_attacking: bool = false

var attack_cooldown: float = 0
var hitbox_cooldown: float = 0
var ritual_cooldown: float = 0

var was_running = false
var input_vector: Vector2 = Vector2.ZERO

func _ready():
	GameManager.player = self
	meat_collected.connect(func(value:int): GameManager.meat_counter += 1)

func _process(delta):
	GameManager.player_position = position
	
	if GameManager.time_elapsed > mission_maximum_size:
		GameManager.end_game(true)
	
	read_input()
	
	#Ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()

	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
	
	#processar dano
	update_hitbox_detection(delta)
	
	update_ritual(delta)
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health

func update_ritual(delta:float):
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)
	

func update_attack_cooldown(delta: float):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
	
func read_input():
	#obter o input_vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var deadzone = 0.15
	
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0

func play_run_idle_animation():
	#tocar a animacao
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite():
		#girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func _physics_process(delta):
	#codificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25 
	velocity = lerp(velocity, target_velocity, 0.05) 
	move_and_slide()

func attack():
	if is_attacking:
		return
	is_attacking = true
	attack_cooldown = 0.6
	animation_player.play('atack_side1')

func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body;
			
			var direction_to_enemy = (enemy.position - position).normalized()
			
			var attack_direction: Vector2
			
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			
			var dotproduct = direction_to_enemy.dot(attack_direction)
			
			if dotproduct > 0.3:
				enemy.damage(sword_damage)

func update_hitbox_detection(delta: float) -> void:
	hitbox_cooldown -= delta
	
	if hitbox_cooldown > 0:
		return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = 1
			damage(damage_amount)

func damage(amount: int) -> void:
	if health <= 0:
		return
	health -= amount
	#print("Player recebeu dano de ", amount, ". A vida total do enemy eh igual a ", health)
	
	modulate = Color.RED
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()

func die():
	GameManager.end_game()
	if (death_prefab):
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()

func heal(amount: int) -> int:
	self.health += amount
	if self.health > max_health:
		self.health = max_health
	return health
