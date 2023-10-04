class_name MovementComponent
extends Node2D
signal remain_movement_changed( )
const base_movement:int = 1
const base_movement_range:int = 250  
@onready var parent_size:Vector2
@onready var global_start_turn_position :Vector2 =  to_global(position)#get_global_transform().get_origin() # Vector2((position[0]+round(size[0]/2)),(position[1]+round(size[1]/2)))
var remain_distance  = base_movement_range:
	set(new_distance):
		remain_distance =new_distance 
		emit_signal("remain_movement_changed"  )
		if new_distance < 0 :
			abort_movement()
	get:
		return remain_distance
var remain_movement:int = base_movement:
	set(new_movement):
		remain_movement = new_movement
		emit_signal("remain_movement_changed"  )
	get:
		return remain_movement
 

func _ready():
 
	$MovementRangeArea/MovementRangeArea.shape = CircleShape2D.new()
	$MovementRangeArea/MovementRangeArea.shape.radius = base_movement_range
	$MovementRangeArea/MovementRangeArea.hide()
	global_start_turn_position =  global_position  
func move(size_of_scene, center):
#	print("move")
	var mouse_pos = get_global_mouse_position()
	var distance_to_mouse = global_start_turn_position.distance_to(mouse_pos) 
	var new_position = global_position

	if distance_to_mouse > base_movement_range:
		var direction_to_mouse = (mouse_pos - global_start_turn_position).normalized()
		new_position = global_start_turn_position + direction_to_mouse * base_movement_range - size_of_scene / 2
	else:
		new_position = mouse_pos - size_of_scene / 2

	var distance_just_traveled = floor( Utils.get_collision_shape_center(owner.get_node("CollisionArea")).distance_to(mouse_pos) )
	print("DISTANCE JUST TRAVELED", distance_just_traveled, " ", global_position, " ", mouse_pos)
	global_position = new_position 
	center =  to_global(global_position + size_of_scene/2)
	remain_distance -= distance_just_traveled
	print("RemainDisance",remain_distance)
#	print(position, global_start_turn_position)
	return  global_position 
		
func abort_movement():
 
	Globals.moving_unit = null
	global_position = global_start_turn_position
	remain_distance = base_movement_range
	#print(   global_start_turn_position, "AFTER")
	return    global_start_turn_position       
	
func set_new_start_turn_point():
	#print("set_new_start_turn_point")
	#print(global_start_turn_position,global_position, parent_size, "VALUES BEFORE SETTING NEW START POS")
	global_start_turn_position = global_position #$CollisionArea/CollisionShape2D.global_position +$CollisionArea/CollisionShape2D.shape.extents/2 
	position = to_local(global_start_turn_position)
	return global_start_turn_position
