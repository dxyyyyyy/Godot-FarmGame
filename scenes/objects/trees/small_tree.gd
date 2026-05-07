extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_ranched.connect(on_max_damage_reached)
	
func on_hurt(hit_damage: int) -> void:
	# Apply damage to the tree
	damage_component.apply_damage(hit_damage)
	
	# Shake the tree when it gets hit
	material.set_shader_parameter("shake_indensity", 0.5)
	#print("shake_intensity = " + str(material.get_shader_parameter("shake_indensity")))
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_indensity", 0.0)

	
func on_max_damage_reached() -> void:
	call_deferred("add_log_scene")
	print("Max damage reached")
	queue_free()

func add_log_scene() -> void:
	# Instantiate the log scene and set its position to the tree's position
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
	
