class_name RangedAttackComp
extends DefaultAttackComponent
signal ammo_changed(ammo)
@onready var projectile_scene:PackedScene = preload("res://scenes/screens/levels/projectiles/bullet.tscn")
var max_ammo: int
@onready var ammo:int = max_ammo:
	get:
		return ammo
	set(value):
		ammo = min(value, max_ammo)
		ammo_changed.emit(ammo)
 

func _ready():
	super._ready()
	$BlastAnimation.hide()

func toggle_action_screen():
	print(ammo," AMMO WHEN TOGGLING")
	if ammo <= 0:
		return
 
	super.toggle_action_screen()
	
func update_for_next_turn():
	super.update_for_next_turn()
	ammo += 1
	
func try_attack():
	print("LAUNCHED XXXXXXXXXXXXXXXXXXXXXXX", ammo)
	if    ammo < 0:
		return false
	if super.try_attack() != "SUCESS":
		print("ATTACK FAILED")
		return false
	return true
 
		
func attack():
	Globals.last_attacker = owner
	remain_actions -=1
	var direction = ( Globals.hovered_unit.center  - global_position).normalized()
	shoot_bullet(owner.center, direction)
	ammo-=1

func check_can_attack():
	if ammo <= 0:
		return false
#		toggle_action_screen()
	return super.check_can_attack()

func shoot_bullet(pos, direction):
	var bullet = projectile_scene.instantiate() as Area2D
	# Set the position and direction of the bullet
	var collision_shape = bullet.get_node("CollisionShape2D")  # Replace with your actual collision shape node name
	print(collision_shape, "COL")
	var shape = collision_shape.shape
	var shape_size = Vector2(0,0) 
#	if shape is RectangleShape2D or shape is CapsuleShape2D:
#		shape_size = shape.get_extents() * 2  # Calculate the size of the shape
	if shape is CircleShape2D:
		var radius = shape.get_radius()
		shape_size = Vector2(radius, radius) * 2
	else:
		print("Unsupported shape type")
 
 
	bullet.position = pos - shape_size / 2   # Adjust the position so that the center of the shape is at pos
	bullet.direction = direction
	bullet.color = owner.color
	bullet.attack_range = attack_range
	bullet.shooting_unit =  owner
	# Make the bullet face its direction
	var target_pos = pos + direction * 100
	var target_angle = (target_pos - pos).angle() + PI/2
	bullet.rotation = target_angle

	# Add the bullet to the projectiles node
	var projectiles = get_tree().get_root().get_node("BattleGround").get_node("Projectiles")
	projectiles.add_child(bullet)
	print("BULLET SHOT", projectiles)

#	print(direction.angle(), direction)
#
	# Calculate the new position for the blast animation
	var blast_displacement = direction.normalized() * 50
	$BlastAnimation.position += blast_displacement
	
	$BlastAnimation.show()
	$BlastAnimation.rotation = direction.angle() - PI/2 *3
	$BlastAnimation.play("blast")  # Replace "blast" with the name of your animation
	# Rotate the AnimatedSprite to face the same direction as the bullet	
