extends Node2D

onready var hurtbox = $hurtbox
onready var stats = $stats

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.create_hitEffect()


func _on_stats_no_health():
	queue_free()
