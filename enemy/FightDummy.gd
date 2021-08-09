extends Node2D


onready var hurtbox = $hurtbox


func _on_hurtbox_area_entered(area):
	hurtbox.create_hitEffect()
	hurtbox.create_dmgNumber(area.damage)
