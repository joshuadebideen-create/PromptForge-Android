
extends CharacterBody3D

@export var acceleration: float = 12.0
@export var max_speed: float = 35.0
@export var reverse_speed: float = 10.0
@export var steering_speed: float = 1.5
@export var braking_force: float = 25.0
@export var engine_brake_stage_1: float = 5.0
@export var engine_brake_stage_2: float = 10.0
@export var engine_brake_stage_3: float = 18.0
@export var gravity: float = 9.8

var throttle_input: float = 0.0
var steering_input: float = 0.0
var brake_input: bool = false
var engine_brake_stage: int = 0
var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0.0

    if brake_input:
        current_speed = move_toward(
            current_speed,
            0.0,
            braking_force * delta
        )
    elif engine_brake_stage > 0:
        var engine_force: float = 0.0

        match engine_brake_stage:
            1:
                engine_force = engine_brake_stage_1
            2:
                engine_force = engine_brake_stage_2
            3:
                engine_force = engine_brake_stage_3

        current_speed = move_toward(
            current_speed,
            0.0,
            engine_force * delta
        )
    else:
        var target_speed := throttle_input * max_speed

        if throttle_input < 0.0:
            target_speed = throttle_input * reverse_speed

        current_speed = move_toward(
            current_speed,
            target_speed,
            acceleration * delta
        )

    if absf(current_speed) > 0.1:
        rotate_y(
            -steering_input *
            steering_speed *
            delta *
            signf(current_speed)
        )

    var forward_direction := -global_transform.basis.z

    velocity.x = forward_direction.x * current_speed
    velocity.z = forward_direction.z * current_speed

    move_and_slide()

func set_throttle(value: float) -> void:
    throttle_input = clampf(value, -1.0, 1.0)

func set_steering(value: float) -> void:
    steering_input = clampf(value, -1.0, 1.0)

func set_brake(pressed: bool) -> void:
    brake_input = pressed

func set_engine_brake_stage(stage: int) -> void:
    engine_brake_stage = clampi(stage, 0, 3)
