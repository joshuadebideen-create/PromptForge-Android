extends CanvasLayer

signal transmit_started
signal transmit_stopped

var current_channel: int = 19
var transmitting: bool = false

var channel_label: Label
var status_label: Label
var message_label: Label
var talk_button: Button

func _ready() -> void:
    create_radio_interface()

func create_radio_interface() -> void:
    var panel := PanelContainer.new()
    panel.position = Vector2(15, 15)
    panel.custom_minimum_size = Vector2(250, 150)
    add_child(panel)

    var layout := VBoxContainer.new()
    panel.add_child(layout)

    var heading := Label.new()
    heading.text = "TRUCK CB RADIO"
    heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    layout.add_child(heading)

    channel_label = Label.new()
    channel_label.text = "CHANNEL 19"
    channel_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    layout.add_child(channel_label)

    var channel_buttons := HBoxContainer.new()
    layout.add_child(channel_buttons)

    var previous_button := Button.new()
    previous_button.text = "CH -"
    channel_buttons.add_child(previous_button)
    previous_button.pressed.connect(change_channel.bind(-1))

    var next_button := Button.new()
    next_button.text = "CH +"
    channel_buttons.add_child(next_button)
    next_button.pressed.connect(change_channel.bind(1))

    talk_button = Button.new()
    talk_button.text = "HOLD TO TALK"
    layout.add_child(talk_button)
    talk_button.button_down.connect(start_transmitting)
    talk_button.button_up.connect(stop_transmitting)

    status_label = Label.new()
    status_label.text = "Radio ready"
    layout.add_child(status_label)

    message_label = Label.new()
    message_label.text = "No incoming messages"
    message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    layout.add_child(message_label)

func change_channel(direction: int) -> void:
    current_channel += direction

    if current_channel > 40:
        current_channel = 1
    elif current_channel < 1:
        current_channel = 40

    channel_label.text = "CHANNEL " + str(current_channel)
    status_label.text = "Channel changed"

func start_transmitting() -> void:
    if transmitting:
        return

    transmitting = true
    status_label.text = "TRANSMITTING..."
    transmit_started.emit()

func stop_transmitting() -> void:
    if not transmitting:
        return

    transmitting = false
    status_label.text = "Radio ready"
    transmit_stopped.emit()

func receive_message(sender: String, message: String) -> void:
    message_label.text = sender + ": " + message
