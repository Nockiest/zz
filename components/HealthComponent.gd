extends Node2D

signal hp_changed(hp, prev_hp)  # New signal
#signal health_reached_zero(dead_component)
var max_hp:int = 6
var hp:int  :
	get:
		return hp
	set(value):  # Setter function for hp
		var prev_hp = hp
		hp = min(value, max_hp)
		print("PREV_HP", prev_hp)
		if prev_hp == 0:
			return
		if prev_hp != hp:
			emit_signal("hp_changed", hp, prev_hp)  # Emit signal whenever hp changes
		if hp <= 0:
#			emit_signal("health_reached_zero", get_parent())
			get_parent().queue_free() 
func hit(amount):
	hp -= amount  # Use self.hp to trigger setter

func heal(amount):
	hp = min(max_hp, self.hp + amount)  # Use self.hp to trigger setter
 
