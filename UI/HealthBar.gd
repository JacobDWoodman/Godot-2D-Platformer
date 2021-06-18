extends Control

var hearts = 6 setget set_hearts
var max_hearts = 6 setget set_max_hearts
var heart_width = 7.5

onready var heartUIFull = $HealthUIFull
onready var heartUIEmpty = $HealthUIEmpty


func set_hearts(value):
	hearts = value
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * heart_width
	
func set_max_hearts(value):
	max_hearts = value
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * heart_width

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	#takes value argument from health_changed and passes into set_hearts
	# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
	# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
