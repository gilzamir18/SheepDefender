extends Node2D

@export var regeneration_amount: int = 10


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var player: Player = body
		var health = player.heal(regeneration_amount)
		print("Vida total do agente depois de comer carne: ", health)
		player.meat_collected.emit(regeneration_amount)
		queue_free()
