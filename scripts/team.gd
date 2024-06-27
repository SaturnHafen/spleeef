class_name Team extends Object

var name: String
var color: Color
var num_players: int

func _init(name: String, color: Color):
	self.name = name
	self.color = color

func is_alive() -> bool:
	return num_players > 0
