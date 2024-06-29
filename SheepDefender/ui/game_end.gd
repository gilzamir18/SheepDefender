class_name GameOverUI
extends CanvasLayer


@onready var time_label : Label = %TimerLabel
@onready var monsters_label : Label = %MonstersLabel
@onready var sheeps_label : Label = %SheepsLabel
@export var restart_delay = 5.0

var restart_cooldown: float
var player_won = true

func _ready():
	time_label.text = GameManager.time_elapsed_string
	monsters_label.text = str(GameManager.monsters_defeated_counter)
	sheeps_label.text = str(GameManager.animals_defeated_by_enemies)
	
	if player_won:
		if GameManager.animals_defeated_by_enemies <= 2:
			$TopPanel/Label.text = "Congratulations, you did well!"
		else:
			$TopPanel/Label.text = "You are alive, improve next."
	else:
		$TopPanel/Label.text = "GameOver"
	restart_cooldown = restart_delay
	

func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0:
		restart_game()

func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
		



	
	
