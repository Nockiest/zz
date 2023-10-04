extends StaticBody2D
class_name  BattleUnit
signal unit_selected 
signal unit_deselected 
signal interferes_with_area
signal bought(cost)
signal died(this)
const base_movement:int = 1
const base_movement_range:int = 250  
var action_component 
var death_image_scene:PackedScene = preload("res://scenes/screens/levels/sprite_with_timer.tscn")
#var remain_movement:int = base_movement:
#	set(new_movement):
#		remain_movement = new_movement
#		update_stats_bar()
 
var attack_resistances =  {"base_resistance":  0.1  }  
@onready var center = $CollisionShape2D.global_position #+$CollisionShape2D.shape.extents/2 
@onready var size = $CollisionShape2D.shape.extents * 2
@onready var global_start_turn_position :Vector2 = get_global_transform().get_origin() # Vector2((position[0]+round(size[0]/2)),(position[1]+round(size[1]/2)))
@onready var buy_areas = get_tree().get_nodes_in_group("buy_areas")

var cost:int = 20
#var movement_polygon = []    
var color: Color  
var original_position = position  # Store the current position
var unit_name: String = "default"
var start_hp: int = 2
var is_newly_bought = true:
	get:
		return is_newly_bought
	set(new_value):
		is_newly_bought = new_value
		print(new_value)
		if new_value == false:
			var tween = get_tree().create_tween()
			tween.tween_property($ColorRect, "modulate", Color(1,1,1), 0.2)
			tween.tween_property($ColorRect, "modulate",   color, 0.2)
 
func _ready():
	# The code here has to come after the code in th echildren compoennts
	$UnitStatsBar.hide()
	$HealthComponent.hide()
	$HealthComponent/HealthBar.value = start_hp
	$HealthComponent.hp = start_hp
	$movement_comp.parent_size =  size 
	center = $CollisionShape2D.global_position +  size/2 
	print(global_position,self )
	$ActionComponent.position =   to_local(global_position + Vector2(25,25))# to_local(center) 
	$ActionComponent.owner = self
	var outline = Utils.polygon_to_line2d($OutlinePolygon , 2) 
	add_child(outline)
	update_stats_bar()
	emit_signal("bought", cost)
	if action_component != null:
		action_component.center = center
		action_component.owner = self
	if  is_newly_bought:
		Globals.placed_unit = self
		Globals.hovered_unit = null
#		print("position not set")
	
func _on_default_attack_comp_remain_attacks_updated(_new_attacks):
	update_stats_bar()

func get_boost():
	print("THIS UNIT DOESNT HAVE A BOOST FOR KILLING A UNIT")

func _on_area_2d_area_entered(area): 
	emit_signal("interferes_with_area", area)

func move():
	position = $movement_comp.move(size,center)
	center = $CollisionArea/CollisionShape2D.global_position +$CollisionArea/CollisionShape2D.shape.extents/2 
	var can_move = true
	for unit in get_tree().get_nodes_in_group("living_units"):
		if unit == self:
			continue  # Skip checking collision with itself.
		if unit.get_node("CollisionArea").get_overlapping_areas().has($CollisionArea):
			can_move = false
			break
	if not can_move:
		position = $movement_comp.abort_movement()
 
func _draw():
	var local_start_turn_pos  = to_local(global_start_turn_position)
	if Globals.moving_unit == self:
		var fill_color = Utils.lighten_color(color, 0.4)
		# Draw an arc from 0 to PI radians (half a circle).
		draw_arc(local_start_turn_pos, base_movement_range, 0,  PI*2, 100, fill_color, 3)
		# Set the collision shape to match the drawn circle. 

func add_to_team(team):
	color = Color(team)
	# Add the unit to a group based on its color
	add_to_group(str(color))
	var color_rect = get_node("ColorRect")
	color_rect.modulate = color


func process_action():
	action_component.try_attack()
	
func process_input():
	if Color(Globals.cur_player) !=  color :
		return
	elif Globals.moving_unit == self and Input.is_action_just_pressed("right_click"): 
		position = $movement_comp.abort_movement()
	elif Globals.hovered_unit == self : 
		if Input.is_action_just_pressed("left_click"): 
			toggle_move()
		if Input.is_action_just_pressed("right_click"):
			if action_component != null:
				action_component.toggle_action_screen()
			else:
				print("UNIT DOESNT HAVE AN ACTION TO TOGGLE SCREEN FOR")
	elif  Globals.action_taking_unit == self:
		if Input.is_action_just_pressed("right_click") :
			process_action()

func process_unit_placement():
	if Input.is_action_just_pressed("left_click"): 
		if Globals.hovered_unit != null:
			print(Globals.hovered_unit == null, Globals.hovered_unit, "POSITION CANNOT BE SET")
			return
		var in_valid_buy_area = false
		## check wheter it is being placed inside the buy bar
		for buy_area in buy_areas:
			print("COLORS",Color(buy_area.team) , color, buy_area.units_inside)
			if Color(buy_area.team) != color:
				continue  
			if self not in buy_area.units_inside:
				continue
			print("IN BUY AREA")
			in_valid_buy_area = true
		## check wheter it is placed in and of the occupied cities
		for town in get_tree().get_nodes_in_group("towns"):
			if town.team_alligiance == null:
				continue
			if Color(town.team_alligiance)!= color:
				continue
			if self in town.units_inside:
				print("UNIT IS INSIDE OF AN OCCUPIED CITY")
				in_valid_buy_area = true
		
		for river_segment in get_tree().get_nodes_in_group("river_segments"):
#			print(river_segment.get_node("Area2D"), river_segment.get_node("Area2D").get_overlapping_areas ( ))
			for area in  river_segment.get_node("Area2D").get_overlapping_areas ( ):
				if area == $CollisionArea:
					print(area, " OVERLAPS")
					in_valid_buy_area = false
					break
 
		if in_valid_buy_area:
			print(Globals.hovered_unit,"CAN PLACE A UNIT")
			is_newly_bought = false
			Globals.placed_unit = null
			return
		print(Globals.hovered_unit, in_valid_buy_area, "POSITION CANNOT BE SET")
 

	if Input.is_action_just_pressed("right_click"): 
		print("ABORTING BUYING AND GIVING MONEY BACK")
		queue_free()

func _process(_delta): 
	queue_redraw()
	if  Globals.placed_unit == self:
		position = get_global_mouse_position() - size / 2
		center = get_global_mouse_position() - size / 2
		global_start_turn_position = get_global_mouse_position() - size / 2
		process_unit_placement()
		return   
	if Globals.placed_unit != null:
		return
	process_input()
	if Globals.moving_unit == self:
		move() 


func deselect_movement():
	if Globals.moving_unit == self:
	#	remain_movement -= 1
		Globals.moving_unit = null 
	global_start_turn_position = $movement_comp.set_new_start_turn_point()
	#print("NEW START TURN POS ", global_start_turn_position)

func toggle_move():
	if Globals.moving_unit == self:
		deselect_movement()
#		print("CASE 1")
		return
	elif Globals.hovered_unit != self:
#		print("CASE 2")
		return  

	elif Globals.action_taking_unit != self and Globals.action_taking_unit != null:
#		print("CASE 3")
		return
	elif Globals.action_taking_unit != null:
#		print("CASE 4")
		return 
	elif $movement_comp.remain_movement <= 0:
		return
#	print("CASE 5")
	Globals.moving_unit = self
	Globals.action_taking_unit = null
 
func update_for_next_turn():
	$movement_comp.remain_movement =  $movement_comp.base_movement 
#	remain_actions = action_component.base_actions
	if has_node("RangedAttackComp"):
		$RangedAttackComp.ammo += 1
	if action_component != null:
		action_component.update_for_next_turn()
	else:
		print("DOESNT HAVE AN ATION COMPONENT TO TOGGLE")
#	if  has_node("HealthComponent"):
#		$HealthComponent.heal(1)

func _on_health_component_hp_changed(hp, prev_hp):
	update_stats_bar()
	if color and $ColorRect.is_inside_tree():
		var tween = get_tree().create_tween()
		if hp < prev_hp:
			tween.tween_property($ColorRect, "modulate", Color(0,0,0), 0.2)
		else:
			tween.tween_property($ColorRect, "modulate", Color(1,1,1), 0.2)
		
		tween.tween_property($ColorRect, "modulate",   color, 0.2)
	if hp <= 0:
		queue_free()

func _on_collision_area_mouse_entered():
	if Globals.placed_unit == self:
		return
 
	Globals.hovered_unit = self
	toggle_show_information()
 
func _on_collision_area_mouse_exited():
	Globals.hovered_unit = null
	toggle_show_information()
 
func toggle_show_information():
	$UnitStatsBar.visible = !$UnitStatsBar.visible
	$HealthComponent.visible = !$HealthComponent.visible

func update_stats_bar():
	$UnitStatsBar/VBoxContainer/Health.text = "Health "+str($HealthComponent.hp)
	$UnitStatsBar/VBoxContainer/Actions.text = "Moves "+str($movement_comp.remain_movement)
	$RemainMovementLabel.text = "Remain Movement:\n" + str($movement_comp.remain_distance )
func _on_tree_exiting():
	# remove_from_group("living_units")
	var other_units = get_tree().get_nodes_in_group("living_units")
	for unit in other_units:
		if unit == Globals.last_attacker:
			print(unit, " will get a boost")

	var death_image = death_image_scene.instantiate() as Sprite2D
	death_image.global_position = center
	get_tree().get_root().add_child(death_image)

func _on_collision_area_area_entered(_area):
	print("ENTERED AREA")

func ___on_movement_changed():
	update_stats_bar()

  
 
#    def find_obstacles_in_line_to_enemies(self, enemy, line_points):
#        # I could only reset the line to that specific unit instead of deleting the whole array
#        ######################### x FIND BLOCKING UNITS ##############
#        blocked = False
#        for unit in game_state.living_units.array:
#            if unit == enemy:
#                continue
#            elif unit.color == self.color:
#                continue
#            point_x, point_y, interferes = check_precalculated_line_square_interference(
#                unit, line_points)
#            distance_between_units = get_two_units_center_distance(unit  , enemy )
#
#            if interferes and abs(distance_between_units )> max(enemy.size//2, unit.size//2):
#                print("this unit is blocking the way", unit, enemy)
#                blocked = True
#                self.lines_to_enemies_in_range.append({
#                    "enemy": enemy,
#                    "start": self.center,
#                    "interference_point": (point_x, point_y),
#                    "end": enemy.center})
#
#                break
#        if not blocked:
#            self.lines_to_enemies_in_range.append({
#                "enemy": enemy,
#                "start": self.center,
#                "interference_point": None,
#                "end": enemy.center})
#
#        return blocked
#
  
#    def draw_lines_to_enemies_in_range(self):
#        for line in self.lines_to_enemies_in_range:
#            start = line["start"]
#            end = line["end"]
#            interference_point = line["interference_point"]
#
#            if interference_point is not None:
#                pygame.draw.line(screen, DARK_RED, start,
#                                 interference_point, 3)
#                pygame.draw.line(screen, (HOUSE_PURPLE),
#                                 interference_point, end, 3)
#            else:
#                pygame.draw.line(screen, DARK_RED, start, end, 3)
#                midpoint = ((start[0] + end[0]) // 2,
#                            (start[1] + end[1]) // 2)
#                distance = math.sqrt(
#                    (start[0] - end[0]) ** 2 + (start[1] - end[1]) ** 2)
#                font = pygame.font.Font(None, 20)
#                text_surface = font.render(
#                    f"{int(distance)} meters", True, WHITE)
#                text_rect = text_surface.get_rect(center=midpoint)
#                screen.blit(text_surface, text_rect)
# 
 


 
 

 
