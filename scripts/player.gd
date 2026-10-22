extends CharacterBody2D

@export var base_speed: float = 300.0

var speed: float = 300.0
var damage_take_mod: float = 1.0
var attack_cooldown: float = 0.4
var can_attack: bool = true
var is_invulnerable: bool = false

@onready var attack_area: Area2D = $AttackArea
@onready var attack_timer: Timer = $AttackTimer
@onready var iframe_timer: Timer = $IFrameTimer
@onready var slash_visual: Sprite2D = $AttackArea/SlashVisual

func _ready() -> void:
	attack_area.monitoring = false
	if slash_visual:
		slash_visual.visible = false
	apply_potion_modifiers()

func apply_potion_modifiers() -> void:
	var potion = GameManager.active_potion
	if potion.is_empty():
		return
	
	speed = base_speed * potion.get("speed_mod", 1.0)
	damage_take_mod = potion.get("damage_take_mod", 1.0)
	attack_cooldown *= potion.get("attack_speed_mod", 1.0)
	
	if potion.get("reduced_max_hp", false):
		GameManager.player_hearts = 1
		GameManager.hearts_changed.emit(1)

func _physics_process(_delta: float) -> void:
	var input_vec = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vec * speed
	move_and_slide()

	if Input.is_action_just_pressed("ui_accept") and can_attack:
		perform_attack()

func perform_attack() -> void:
	can_attack = false
	attack_area.monitoring = true
	
	# Show Attack Visual & Play Sound
	if slash_visual:
		slash_visual.visible = true
	SFXManager.play_sfx("attack")
	
	await get_tree().create_timer(0.15).timeout
	
	attack_area.monitoring = false
	if slash_visual:
		slash_visual.visible = false
	
	attack_timer.start(attack_cooldown)

func _on_attack_timer_timeout() -> void:
	can_attack = true

func take_damage(base_amount: int = 1) -> void:
	if is_invulnerable:
		return
		
	var final_damage = int(ceil(base_amount * damage_take_mod))
	GameManager.lose_heart(final_damage)
	
	SFXManager.play_sfx("hurt")
	
	is_invulnerable = true
	iframe_timer.start(1.0)

func _on_iframe_timer_timeout() -> void:
	is_invulnerable = false

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		SFXManager.play_sfx("hit")
		body.take_damage(1)
