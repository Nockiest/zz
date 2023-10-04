class_name Knight
extends MeleeUnit

func get_boost():
	$movement_comp.remain_movement += 1
	print("KNIGHT IS GETTING ONE MORE MOVE ", self, " ", $movement_comp.remain_movement  )
	

 
