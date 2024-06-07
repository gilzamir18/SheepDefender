extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel
@onready var sheep_label: Label = %SheepLabel

func _process(delta):
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_counter)
	sheep_label.text = str(max(0, 4 - GameManager.animals_defeated_by_enemies))
