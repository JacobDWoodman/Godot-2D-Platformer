extends "res://moving_entity.gd"

var has_bounced = false

var timeout = false
var last_position = Vector2.ZERO
onready var timer = $Timer

func _ready():
	sprite = $AnimatedSprite

func _physics_process(_delta):
	
	if facing_right:
		move_dir = -1
	else: move_dir  = 1
	
	if timeout:
		if last_position.x-position.x == 0:
			print("flipping!")
			_flip()
			has_bounced = true
			timeout = false
			timer.start(0.1)
	last_position.x = position.x
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1))



func _on_hitbox_area_entered(area):
	_flip()
	has_bounced = true


func _on_Timer_timeout():
	timeout = true


func _on_LifeTimer_timeout():
	queue_free()
