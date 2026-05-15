extends NodeState

@export var character: NonPlayableCharacters
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D
@export var min_speed : float = 5.0
@export var max_speed : float = 10.0


var speed : float 

func _ready() -> void:
	navigation_agent_2d = get_owner().find_child("NavigationAgent2D", true, false)
	navigation_agent_2d.velocity_computed.connect(on_velocity_computed)
	
	call_deferred("character_setup")
	
func character_setup() -> void:
	await get_tree().physics_frame
	
	set_movement_target()
	
#func set_movement_target() -> void:
	# Get a random point on the navigation map and set it as the target position for the navigation agent
	#var target_position : Vector2 = NavigationServer2D.map_get_random_point(navigation_agent_2d.get_navigation_map(),navigation_agent_2d.navigation_layers,false)
	#navigation_agent_2d.target_position = target_position
	#speed = randf_range(min_speed, max_speed)
	
	 # 打印出当前鸡节点的名称
	#var chicken_name = get_owner().name   # 假设 owner 是 Chicken
	#print(chicken_name, " 新目标: ", target_position)
	#speed = randf_range(min_speed, max_speed)
	
func set_movement_target() -> void:
	var map = navigation_agent_2d.get_navigation_map()
	var layers = navigation_agent_2d.navigation_layers
	var target = Vector2.ZERO
	var attempts = 0
	while target == Vector2.ZERO and attempts < 10:
		target = NavigationServer2D.map_get_random_point(map, layers, false)
		#print("尝试获取导航点，尝试次数: ", attempts, " 结果: ", target)
		attempts += 1
		if target == Vector2.ZERO:
			await get_tree().physics_frame  # 等待一帧再试
	navigation_agent_2d.target_position = target
	#print(get_owner().name, " 新目标: ", target)
	speed = randf_range(min_speed, max_speed)
	
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	# Check if the navigation agent has reached its target position
	if navigation_agent_2d.is_navigation_finished():
		character.current_walk_cycle += 1
		set_movement_target()
		return 
	
	# Move the character towards the target position
	var target_position : Vector2 = navigation_agent_2d.get_next_path_position()
	var target_direction : Vector2 = character.global_position.direction_to(target_position)
	animated_sprite_2d.flip_h = target_direction.x <0
	
	var velocity : Vector2 = target_direction * speed
	if navigation_agent_2d.avoidance_enabled:
		#print("Avoidance Enabled")
		animated_sprite_2d.flip_h = velocity.x <0
		navigation_agent_2d.velocity = velocity
	else:
		character.velocity = velocity
		character.move_and_slide()

func on_velocity_computed(safe_velocity : Vector2) -> void:
	animated_sprite_2d.flip_h = safe_velocity.x <0
	character.velocity = safe_velocity
	character.move_and_slide()
	#print("Safe Velocity: ", safe_velocity)

func _on_next_transitions() -> void:
	# Transition to the idle state if the character has reached its target position
	if character.current_walk_cycle >= character.walk_cycle:
		character.velocity = Vector2.ZERO
		character.current_walk_cycle = 0
		transition.emit("Idle")



func _on_enter() -> void:
	animated_sprite_2d.play("walk")
	character.current_walk_cycle = 0

func _on_exit() -> void:
	animated_sprite_2d.stop()
