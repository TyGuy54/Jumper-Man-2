extends KinematicBody2D

signal collented_coin

export var move_speed = 200.0

var velocity := Vector2.ZERO

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# node refrences 
onready var animations = $AnimatedSprite
onready var jump_buffer = $jump_buffer
onready var respawn_timer = $respawn_timer
onready var jump_sound = $jump_sound
onready var coin_sound = $coin_sound
onready var game_over = $game_over


func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = get_input() * move_speed
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer.start()
		
	if is_on_floor():
		if !jump_buffer.is_stopped():
			jump_sound.play()
			jump_sound.stop()
			jump()
	else:
		animations.play("jump")
		
		if Input.is_action_just_released("jump") and velocity.y < jump_height * 0.3:
			velocity.y = jump_height * 0.3
			velocity.y = jump_time_to_peak * 0.3
			velocity.y = jump_time_to_descent * 0.3

	velocity = move_and_slide(velocity, Vector2.UP)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity
	jump_buffer.stop()

func get_input() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		animations.play("walk")
		animations.flip_h = true
		horizontal -= 1.0
	
	elif Input.is_action_pressed("right"):
		animations.play("walk")
		animations.flip_h = false
		horizontal += 1.0
	else:
		animations.play("idle")
	
	return horizontal

func coin_collected():
	emit_signal("collented_coin")
	coin_sound.play()
	coin_sound.stop()
	
	
func _on_fallzone_body_entered(body):
	game_over.play()
	respawn_timer.start()
	respawn_timer.stop()
	
func _on_fallzone_body_exited(body):
	get_tree().change_scene("res://Worlds/world_1/world.tscn")


func _on_gem_body_entered(body):
	get_tree().change_scene("res://Worlds/world_2/world_2.tscn")
