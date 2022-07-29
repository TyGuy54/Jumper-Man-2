extends CanvasLayer

var coins = 0

func _ready():
	$num_of_coins.text = String(coins)

func _on_Player_collented_coin():
	coins += 1
	print(coins)
	_ready()
