extends CharacterBody2D

var monster_type: int = 1
var health: int = 3
var move_speed: float = 100.0
var target: Node2D = null

@onready var hitbox_area: Area2D = $HitboxArea

func _ready() -> void:
	monster_type = GameManager.current_monster_index
	setup_monster_stats()
	target = get_tree().get_first_node_in_group("player")

func setup_monster_stats() -> void:
	match monster_type:
		1: # Glint Swarmer
			health = 4
			move_speed = 180.0
		2: # Iron Golem
			health = 10
			move_speed = 70.0
		3: # Venom Spitter
			health = 7
			move_speed = 110.0
		4: # Apex Warden (Boss)
			health = 15
			move_speed = 140.0

func _physics_process(_delta: float) -> void:
	if target and is_instance_valid(target):
		var dir = (target.global_position - global_position).normalized()
		velocity = dir * move_speed
		move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	var arena = get_tree().current_scene
	if arena.has_method("on_monster_defeated"):
		arena.on_monster_defeated()
	queue_free()

func _on_hitbox_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(1)
