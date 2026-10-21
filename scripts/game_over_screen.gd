extends Control

@onready var retry_button: Button = $CenterContainer/VBoxContainer/RetryButton

func _ready() -> void:
	retry_button.pressed.connect(_on_retry_button_pressed)

func _on_retry_button_pressed() -> void:
	GameManager.reset_run()
