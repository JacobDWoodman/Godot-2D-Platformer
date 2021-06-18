extends Node

export var max_health = 1 setget set_max_health
var health = max_health setget set_health
var stuff = []

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
	elif health > max_health:
		health = max_health
		
	emit_signal("health_changed", health)

func _ready():
	self.health = max_health
