class_name Town
extends Area2D
var house_scene:PackedScene = preload("res://structures/house.tscn")  # get the house.tscn
var num_houses:int = 5
@onready var rect_shape =  $CollisionShape2D.shape as RectangleShape2D  # Access the RectangleShape2D
# Called when the node enters the scene tree for the first time.
var units_inside: Array
var team_alligiance 
var connected_roads:int = 0
var connected_towns: Array = []
func _process(_delta):
	if  Globals.placed_unit == null:
		$ColorRect.modulate = Color("#8B0000") 
		return
	if   team_alligiance == null:
		$ColorRect.modulate = Color("#8B0000")
		return

	if Globals.placed_unit.color == Color(team_alligiance):
		$ColorRect.modulate = Color("white")#Utils.lighten_color( Color(team_alligiance), 150) 
#	else:
#		$ColorRect.modulate = ## default color
	## make sure that collision shape in house scene is stil on index 0 otherwise it wont work
func place_house():
	for house in range(num_houses):
		var house_instance = house_scene.instantiate() as Area2D
		get_random_house_position(house_instance)
		add_child(house_instance)
		house_instance.connect("house_interferes", get_random_house_position ) 

func get_random_house_position(house):
	var house_collision_shape = house.get_child(0).shape as RectangleShape2D  # Access the house's RectangleShape2D
	var min_x = house_collision_shape.extents.x  
	var max_x = (rect_shape.extents.x - min_x)*2
	var min_y = house_collision_shape.extents.y  
	var max_y = (rect_shape.extents.y - min_y)*2
  
	var random_x = randi_range(min_x, max_x)
	var random_y = randi_range(min_y, max_y)
 
	house.position = Vector2(random_x, random_y)
	

func is_area_occupied(area):
	for child in $Houses.get_children():
		print_debug(child is Area2D ,child != area ,child.intersects_area(area))
		if child is Area2D and child != area and child.intersects_area(area):
			return true
	return false
 
 
func _on_area_entered(area): 
#	if area is Town:
#		print("HAD TO DESTROY ITSELF BECAUSE OVERLAPED ANOTHER TOWN")
#		queue_free()
	if not(area is UnitsMainCollisionArea):
		return
	if not (area.get_parent() is BattleUnit):
		return
	print("UNIT ENTERED TOWN ",  area.get_parent())
	units_inside.append(area.get_parent())
	
#func check_overlaps_other_towns():
#	for town in get_tree().get_nodes_in_group("towns"):
#		print("XXX", town.get_overlapping_areas())
#		if town.get_overlapping_areas().has(self):
#			queue_free()
func _ready():
	if not is_far_enough():
		free()
		return
	place_house()
#	var outline = Utils.area_to_line2d(self, 2)
# 	add_child(outline)
#	check_overlaps_other_towns()

func is_far_enough():
	for town in get_tree().get_nodes_in_group("towns"):
		if town == self:
			continue
		print("DISTANCE " ,Utils.get_collision_shape_center(self  ).distance_to(Utils.get_collision_shape_center(town  ) ))
		if Utils.get_collision_shape_center(self  ).distance_to(Utils.get_collision_shape_center(town  ) ) <  Globals.min_town_spacing_distance:
			return false
	return true

func _on_area_exited(area):
 
#	if not (area is UnitsMainCollisionArea):
#		return
#	if area.get_parent() not in units_inside:
#		return
#	print("UNIT EXITED TOWN ",  area.get_parent(), area,  units_inside )
	if area.get_parent() in units_inside:
		units_inside.erase(area.get_parent())
		
func make_next_turn_calculations():
	check_who_occupied()
	change_edge_color()

func check_who_occupied():
	var blue_count = 0
	var red_count = 0
	team_alligiance = null
	for unit in units_inside:
		if unit.color == Color("red"):
			red_count += 1
		elif unit.color == Color("blue"):
			blue_count += 1
		else:
			print("I DONT NOW THIS TEAM", unit.color)
	if blue_count > red_count:
		team_alligiance = "blue"
	elif red_count > blue_count:
		team_alligiance = "red"
	
 
func change_edge_color():
	if team_alligiance == "blue":
		$Edge.color = Color("blue")
	elif team_alligiance == "red":
		$Edge.color = Color("red")	
	else:
		$Edge.color = Color("white")
		
func connect_to_other_towns():
	var towns = get_tree().get_nodes_in_group("towns")
	var town_distances = [] ##array of arrays with the distance and the town
	for town in towns:
		if town == self:
			continue
		if town.connected_roads > 2:
			continue
#			print(town, " HAS TO MANY ROADS LEADING TO IT")
		town_distances.append([ position.distance_to(town.position), town])
		town_distances.sort()
	for i in range(min(2, len(town_distances))):
#		print(town_distances[i][1])
		town_distances[i][1].connected_roads += 1
		connected_towns.append(town_distances[i][1])
		connected_roads += 1
 
		
			
		
