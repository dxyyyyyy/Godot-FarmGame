extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var stone_scene = preload("res://scenes/objects/rocks/stone.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_ranched.connect(on_max_damage_reached)
	
func on_hurt(hit_damage: int) -> void:
	# Apply damage to the rock
	damage_component.apply_damage(hit_damage)
	print("Current damage: " + str(damage_component.current_damage) + "/" + str(damage_component.max_damage))
	
	material.set_shader_parameter("shake_indensity", 0.3)
	print("The rocks shake_intensity = " + str(material.get_shader_parameter("shake_indensity")))
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_indensity", 0.0)
	
	
func on_max_damage_reached() -> void:
	call_deferred("add_stone_scene")
	print("Max damage reached")
	queue_free()



func add_stone_scene() -> void:
	# Instantiate the stone scene and set its position to the rock's position
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
	
