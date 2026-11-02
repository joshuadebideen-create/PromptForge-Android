
extends CanvasLayer

signal channel_changed(channel: int)
signal transmit_started(channel: int)
signal transmit_stopped(channel: int)

var current_channel: int = 19
var transmitting: bool = false

var display_label: Label
var status_label: Label

func _ready() -> void:
    create_radio_interface()

func create_radio_interface() -> void:
    var panel := PanelContainer.new()
    panel.set_anchors_and_offsets_preset(
        Control.PRESET_TOP_LEFT
    )
    panel.position = Vector2(15, 150)
    panel.custom_minimum_size = Vector2(230, 155)
    add_child(panel)

    var layout := VBoxContainer.new()
    panel.add_child(layout)

    var title := Label.new()
    title.text = "TRUCK CB RADIO"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    layout.add_child(title)

    display_label = Label.new()
    display_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    display_label.add_theme_font_size_override("font_size", 24)
    layout.add_child(display_label)

    var channel_row := HBoxContainer.new()
    layout.add_child(channel_row)

    var down_button := Button.new()
    down_button.text = "CH -"
    down_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    channel_row.add_child(down_button)
    down_button.pressed.connect(change_channel.bind(-1))

    var up_button := Button.new()
    up_button.text = "CH +"
    up_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    channel_row.add_child(up_button)
    up_button.pressed.connect(change_channel.bind(1))

    var microphone := Button.new()
    microphone.text = "HOLD TO TALK"
    microphone.custom_minimum_size = Vector2(0, 45)
    layout.add_child(microphone)

    microphone.button_down.connect(start_transmitting)
    microphone.button_up.connect(stop_transmitting)

    status_label = Label.new()
    status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    layout.add_child(status_label)

    update_display()

func change_channel(direction: int) -> void:
    current_channel += direction

    if current_channel > 40:
        current_channel = 1
    elif current_channel < 1:
        current_channel = 40

    update_display()
    channel_changed.emit(current_channel)

func update_display() -> void:
    display_label.text = "CHANNEL %02d" % current_channel

    if transmitting:
        status_label.text = "TRANSMITTING..."
    else:
        status_label.text = "RECEIVE MODE"

func start_transmitting() -> void:
    transmitting = true
    update_display()
    transmit_started.emit(current_channel)

func stop_transmitting() -> void:
    transmitting = false
    update_display()
    transmit_stopped.emit(current_channel)

func receive_message(message: String) -> void:
    status_label.text = message
