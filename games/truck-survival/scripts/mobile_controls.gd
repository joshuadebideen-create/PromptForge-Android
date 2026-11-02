
extends CanvasLayer

signal steering_changed(value: float)
signal throttle_changed(value: float)
signal brake_changed(pressed: bool)
signal engine_brake_changed(stage: int)
signal camera_switch_requested
signal windows_toggle_requested

var engine_stage: int = 0
var engine_button: Button

func _ready() -> void:
    create_controls()

func create_controls() -> void:
    var screen := Control.new()
    screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(screen)

    create_button(screen, "◀", Vector2(25, -115),
        Control.PRESET_BOTTOM_LEFT, "left")
    create_button(screen, "▶", Vector2(115, -115),
        Control.PRESET_BOTTOM_LEFT, "right")

    create_button(screen, "ACCEL", Vector2(-125, -115),
        Control.PRESET_BOTTOM_RIGHT, "accelerate")
    create_button(screen, "REV", Vector2(-225, -115),
        Control.PRESET_BOTTOM_RIGHT, "reverse")
    create_button(screen, "BRAKE", Vector2(-125, -205),
        Control.PRESET_BOTTOM_RIGHT, "brake")

    engine_button = Button.new()
    engine_button.text = "ENGINE: OFF"
    engine_button.custom_minimum_size = Vector2(125, 65)
    engine_button.set_anchors_and_offsets_preset(
        Control.PRESET_BOTTOM_RIGHT
    )
    engine_button.position = Vector2(-260, -205)
    screen.add_child(engine_button)
    engine_button.pressed.connect(cycle_engine_brake)

    var camera_button := Button.new()
    camera_button.text = "CAMERA"
    camera_button.custom_minimum_size = Vector2(110, 55)
    camera_button.position = Vector2(20, 20)
    camera_button.set_anchors_and_offsets_preset(
        Control.PRESET_TOP_RIGHT
    )
    screen.add_child(camera_button)
    camera_button.pressed.connect(
        func(): camera_switch_requested.emit()
    )

    var window_button := Button.new()
    window_button.text = "WINDOW"
    window_button.custom_minimum_size = Vector2(110, 55)
    window_button.position = Vector2(20, 85)
    window_button.set_anchors_and_offsets_preset(
        Control.PRESET_TOP_RIGHT
    )
    screen.add_child(window_button)
    window_button.pressed.connect(
        func(): windows_toggle_requested.emit()
    )

func create_button(
    parent: Control,
    label: String,
    offset: Vector2,
    preset: Control.LayoutPreset,
    action: String
) -> void:
    var button := Button.new()
    button.text = label
    button.custom_minimum_size = Vector2(105, 75)
    button.set_anchors_and_offsets_preset(preset)
    button.position = offset
    parent.add_child(button)

    button.button_down.connect(
        func(): handle_action(action, true)
    )
    button.button_up.connect(
        func(): handle_action(action, false)
    )

func handle_action(action: String, pressed: bool) -> void:
    match action:
        "left":
            steering_changed.emit(-1.0 if pressed else 0.0)
        "right":
            steering_changed.emit(1.0 if pressed else 0.0)
        "accelerate":
            throttle_changed.emit(1.0 if pressed else 0.0)
        "reverse":
            throttle_changed.emit(-1.0 if pressed else 0.0)
        "brake":
            brake_changed.emit(pressed)

func cycle_engine_brake() -> void:
    engine_stage = (engine_stage + 1) % 4

    if engine_stage == 0:
        engine_button.text = "ENGINE: OFF"
    else:
        engine_button.text = "ENGINE: STAGE " + str(engine_stage)

    engine_brake_changed.emit(engine_stage)
