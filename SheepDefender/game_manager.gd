extends Node

signal game_over
signal player_won

var player: Player
var player_position : Vector2
var is_game_over: bool = false
var has_player_won: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var meat_counter: int = 0
var monsters_defeated_counter:int = 0
var animals_defeated_by_enemies = 0
var animals: Array[FarmAnimal]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	time_elapsed += delta
	
	var time_elapsed_in_seconds: int = floor(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60	
	time_elapsed_string = "%02d:%02d"%[minutes, seconds]

func game_ended():
	return has_player_won or is_game_over

func end_game(won : bool = false):
	if not won:
		if is_game_over: return
		is_game_over = true
		game_over.emit()
	else:
		if has_player_won: return
		has_player_won = true
		player_won.emit()
		
func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	has_player_won = false
	time_elapsed = 0.0	
	time_elapsed_string = ""
	meat_counter = 0
	monsters_defeated_counter = 0
	animals_defeated_by_enemies = 0
	for con in game_over.get_connections():
		game_over.disconnect(con.callable)
	for con in player_won.get_connections():
		player_won.disconnect(con.callable)
