extends Node


@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 60
@export var spawn_rate_per_minute: int = 30
@export var wave_duration: float  = 20
@export var break_intensity: float = 0.5

var time: float = 0.0

func _process(delta):
	#Ignorar GameOver
	if GameManager.is_game_over: return
	
	#incrementar temporizador
	time += delta
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60.0)

	var sin_wave = sin( (time * TAU)/wave_duration )
	var wave_factor = remap(sin_wave, -1, 1, break_intensity, 1)

	spawn_rate *= wave_factor
	
	mob_spawner.mobs_per_minute = spawn_rate
