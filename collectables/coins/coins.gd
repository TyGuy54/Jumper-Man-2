extends Area2D

func _on_coins_body_entered(body):
	body.coin_collected()
	queue_free()
