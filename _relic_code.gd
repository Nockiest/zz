# toggle_action_screen()
#func play_attack_animation(attacked_entity):
#	$SlashAnimation.z_index = 1000
#	#	slash_animation.position = Globals.hovered_unit.position #.ZERO  # Center of the unit
#	var collision_shape = attacked_entity.get_node("CollisionArea/CollisionShape2D")  # Replace with your actual node path
#	var shape_size = collision_shape.shape.extents * 2  # For RectangleShape2D and CapsuleShape2D
#	$SlashAnimation.global_position = Globals.hovered_unit.global_position + shape_size / 2
#	# Calculate the angle to face Globals.hovered_unit
#	if Globals.hovered_unit:
#		var dir_to_hovered = (Globals.hovered_unit.position - position).normalized()
#		var angle_to_hovered = dir_to_hovered.angle()
#		$SlashAnimation.rotation = angle_to_hovered
#
#	$SlashAnimation.play("slash")

#	Engine.time_scale = 0.5


# The unit's collision shape is overlapping with the ResupplyAction's collision shape
			# Provide buffs here
#	super.provide_buffs()
#	if supported_entity:
#		Utils.play_animation_at_position($AnimatedSprite2D,"resupply_animation", supported_entity.global_position) 
 
#	var shape = RectangleShape2D.new()
#	shape.extents = Vector2(48, 48)
##	$CollisionShape2D.shape = shape

#	var same_color_units = []
#	for unit in units:
#		if unit.color != Color(team):
#			continue
#		same_color_units.append(unit)

# scale = Vector2(test_scale,test_scale )

#	var tenders = get_tree().get_nodes_in_group("player_tenders") 
#	for i in range(len(tenders)):
#		var tender = tenders[i]
#		if tender.team == "blue":
##			print(tender.team, tender.money, tender.units) 
#			tender.money-= cost

#	for unit in same_color_units:
#		var unit_type = unit.unit_name  # get_class()
#		if unit_type in sorted_units:
#			sorted_units[unit_type] += 1
#		else:
#			sorted_units[unit_type] = 1

	# Get all the grandchildren of the VBoxContainer
	
	#var unit_types = ["cannon", "pikeman", "shield", "medic", "knight", "musketeer"]
#var unit_images = [preload("res://img/cannon.png"), preload("res://img/pikeman.png"), preload("res://img/shield.png"), preload("res://img/medic.png"), preload("res://img/knight.png"), preload("res://img/musketeer.png")]

#func _process(delta):
#	queue_redraw() 
 
#	if not Globals.hovered_unit or Globals.hovered_unit.color == get_parent().color:
#		attack_failed.emit()
#		return "failed"	
#	print( self.get_parent().global_position.distance_to(Globals.hovered_unit.global_position), attack_range)
#	var distance = self.get_parent().global_position.distance_to(Globals.hovered_unit.global_position) 
#	if distance > attack_range:
#		attack_failed.emit()
#		return "failed"

#func play_attack_animation(attacked_entity):
#	$SlashAnimation.z_index = 1000
#	#	slash_animation.position = Globals.hovered_unit.position #.ZERO  # Center of the unit
#	var collision_shape = attacked_entity.get_node("CollisionArea/CollisionShape2D")  # Replace with your actual node path
#	var shape_size = collision_shape.shape.extents * 2  # For RectangleShape2D and CapsuleShape2D
#	$SlashAnimation.global_position = Globals.hovered_unit.global_position + shape_size / 2
#	# Calculate the angle to face Globals.hovered_unit
#	if Globals.hovered_unit:
#		var dir_to_hovered = (Globals.hovered_unit.position - position).normalized()
#		var angle_to_hovered = dir_to_hovered.angle()
#		$SlashAnimation.rotation = angle_to_hovered
#
#	$SlashAnimation.play("slash")

#
#func _on_attack_range_area_area_entered(area):
##	print (area.get_parent()," ",  area.get_parent() == self, " ", Globals.action_taking_unit != self, " ", self)
#	if area.get_parent() == self:
#		return
#	if Globals.action_taking_unit != self:
#		return
#	if area.name == "CollisionArea" and area.get_parent() is BattleUnit and not units_in_action_range.has(area):
#		units_in_action_range.append(area.get_parent())
##	print("THESE ARE UNITS IN RANGE NOW", units_in_action_range)
#func _on_attack_range_area_area_exited(area):
#	if area.get_parent() == self:
#		return
#	if Globals.action_taking_unit!= self:
#		return
#	if area.name == "CollisionArea" and units_in_action_range.has(area.get_parent()):
#		units_in_action_range.erase(area.get_parent()) 

 
#    def try_attack(self, click_pos, attacked_unit):
#        ####!!!RANGED UNITS ARNET CONNECTED O THIS FUNCTION!!!#####
#        if attacked_unit in self.enemies_in_range:
#            self.try_attack()
#            hit_result = attacked_unit.check_if_hit()  # 80% hit chance
#            # num_attacks += 1
#            if hit_result:
#                remaining_hp = attacked_unit.take_damage(self)
#                print("remaining enemy hp", remaining_hp)
#
#                return "UNIT ATTACKS"
#            else:
#                return "UNIT MISSED"
#        return "Attack not possible"

#    def get_attackable_units(self):
#        self.enemies_in_range = []
#        self.lines_to_enemies_in_range = []
#        total_attack_range_modifier = sum(self.attack_range_modifiers.values())
#        # for every living unit
#        for enemy in game_state.living_units.array:
#            if enemy.color == self.color:
#                continue
#            center_x, center_y = self.center
#            enemy_center_x, enemy_center_y = enemy.center
#            distance = math.sqrt((enemy_center_x - center_x)
#                                 ** 2 + (enemy_center_y - center_y)**2)
#            line_points = bresenham_line(
#                center_x, center_y, enemy_center_x, enemy_center_y)
#            if distance - enemy.size//2 < self.attack_range  * total_attack_range_modifier:
#                blocked = self.find_obstacles_in_line_to_enemies(
#                    enemy, line_points)
#
#                if not blocked:
#                    self.enemies_in_range.append(enemy)
#
#        print("in try_attack range are", self.enemies_in_range)
#
#	generate_bezier_curve(mid_point, end_point, num_segments)
	
#	for i in line.points.size() - 1:
#		print("child", $segments.get_child(i))
	## for creating collision shape for the line
#	for i in line.points.size() - 1:
#		var new_shape = CollisionShape2D.new()
#		add_child(new_shape)
#		var rect = RectangleShape2D.new()
#		new_shape.position = (line.points[i] + line.points[i + 1]) / 2
#		new_shape.rotation = line.points[i].direction_to(line.points[i + 1]).angle()
#		var length = line.points[i].distance_to(line.points[i + 1])
#		rect.extents = Vector2(length / 2, 10)
#		new_shape.shape = rect
#		print(new_shape.position)
