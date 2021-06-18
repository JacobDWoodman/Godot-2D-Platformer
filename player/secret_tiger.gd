extends "res://moving_entity.gd"
#this script overrides the sprite variable to an animated sprite

var last_position = Vector2.ZERO
onready var timer = $Timer
onready var lifetimer = $LifeTimer
var timeout = false

func _ready():
	sprite = $AnimatedSprite

func _physics_process(_delta):
	move_dir = 0
	
	if facing_right:
		move_dir -= 1
	else: move_dir += 1
	
	if timeout:
		if last_position.x-position.x == 0:
			_flip()
			timeout = false
			timer.start(0.1)
	last_position.x = position.x
	
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(move_dir * move_speed, y_velo), Vector2(0, -1))
	grounded = is_on_floor()
	_do_gravity()

func _on_Timer_timeout():
	timeout = true


func _on_LifeTimer_timeout():
	queue_free()


func _on_hitbox_area_entered(area):
	queue_free()
