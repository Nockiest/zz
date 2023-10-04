extends CanvasLayer
class_name Canvas
signal next_turn_pressed
signal player_gave_up

func on_cur_player_has_been_changed():
	update_label()
	
func update_label():
	$Label.text = "Cur_player: " + str(Globals.cur_player)
	$Label.modulate = Color(Globals.cur_player)
 
func update_color(ammount:int, label: Label,   color:Color) -> void:
	if ammount > 0:
		label.modulate = color
	else:
		label.modulate = Color("red")
func _ready():
	update_label()
	Globals.connect("cur_player_has_been_changed", on_cur_player_has_been_changed) 
#		teams[team].sort( )
#		print("Team ", team, ": ",   teams[team] )
 

func sort_by_instance(a, b):
	return a.get_class() < b.get_class()

func _on_give_up_btn_up(): 	 
	player_gave_up.emit()
	Globals.end_game(Globals.cur_player)
 


func _on_next_turn_btn_button_up():
	next_turn_pressed.emit()
