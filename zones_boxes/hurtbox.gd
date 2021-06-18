extends Area2D

const HitEffect = preload("res://hiteffect.tscn")
const DmgNumber = preload("res://text/newdmgtext.tscn")

var isInvincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	isInvincible = value
	if isInvincible:
		emit_signal("invincibility_started")
	else: emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.isInvincible = true
	timer.start(duration)

func create_hitEffect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func create_dmgNumber(num):
	var effect = DmgNumber.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.get_child(0).input = str(num)
	effect.global_position = global_position + Vector2(rand_range(-20, 20), rand_range(-50, -80))

func _on_Timer_timeout():
	self.isInvincible = false


func _on_hurtbox_invincibility_ended():
	set_deferred("monitoring", true)


func _on_hurtbox_invincibility_started():
	set_deferred("monitoring", false)
