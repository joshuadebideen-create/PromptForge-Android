
extends CanvasLayer

signal move_input(direction: Vector2)
signal action_pressed(action_name: StringName)

var steering_input: float = 0.0
var acceleration_input: float = 0.0
var brake_input: bool = false

func send_move_input(direction: Vector2) -> void:
    move_input.emit(direction.limit_length(1.0))

func send_action(action_name: StringName) -> void:
    action_pressed.emit(action_name)

func set_steering(value: float) -> void:
    steering_input = clampf(value, -1.0, 1.0)
    send_move_input(Vector2(steering_input, acceleration_input))

func set_acceleration(value: float) -> void:
    acceleration_input = clampf(value, -1.0, 1.0)
    send_move_input(Vector2(steering_input, acceleration_input))

func set_brake(pressed: bool) -> void:
    brake_input = pressed
    if pressed:
        send_action(&"brake")
