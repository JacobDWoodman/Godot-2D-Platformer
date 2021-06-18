extends KinematicBody2D

export var move_speed = 200
export var jump_force = 600
export var gravity = 30
export var max_fall_speed = 1000

onready var sprite

var grounded = true
var move_dir = 0
var y_velo = 0
var facing_right = false

func _ready():
	sprite = $Sprite

func _flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func _do_gravity():
	y_velo += gravity
	if grounded and y_velo >= 5:
		y_velo = 5
	if y_velo > max_fall_speed:
		y_velo = max_fall_speed
