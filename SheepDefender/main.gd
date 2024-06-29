extends Node2D

@export var game_ui: CanvasLayer

func _ready():
	GameManager.game_over.connect(trigger_game_over)
	GameManager.player_won.connect(trigger_player_won)

func trigger_player_won():
	#Delete GameUI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
		
	#criar gameoverui
	var player_won_ui: GameOverUI = preload("res://ui/game_end_ui.tscn").instantiate()
	player_won_ui.player_won = true
	add_child(player_won_ui)

func trigger_game_over():
	#Delete GameUI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
		
	#criar gameoverui
	var game_over_ui: GameOverUI = preload("res://ui/game_end_ui.tscn").instantiate()
	game_over_ui.player_won = false
	add_child(game_over_ui)
