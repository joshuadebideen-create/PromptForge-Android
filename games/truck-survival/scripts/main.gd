
extends Node3D

const MobileControls = preload("res://scripts/mobile_controls.gd")

@export var world_label: String = "Open-World Truck Survival Simulator"

@onready var truck: CharacterBody3D = $Truck

func _ready() -> void:
    print("Loaded: ", world_label)
    create_world()
    connect_mobile_controls()

func create_world() -> void:
    # Create the highway
    var road_mesh := BoxMesh.new()
    road_mesh.size = Vector3(12.0, 0.15, 200.0)

    var road := MeshInstance3D.new()
    road.name = "Highway"
    road.mesh = road_mesh
    road.position = Vector3(0.0, -0.35, 0.0)
    add_child(road)

func connect_mobile_controls() -> void:
    var controls = MobileControls.new()
    add_child(controls)

    controls.steering_changed.connect(
        truck.set_steering
    )

    controls.throttle_changed.connect(
        truck.set_throttle
    )

    controls.brake_changed.connect(
        truck.set_brake
    )

    controls.engine_brake_changed.connect(
        truck.set_engine_brake_stage
    )

    print("Mobile driving controls connected.")

