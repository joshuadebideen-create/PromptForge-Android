
extends Node3D

var driver_window: MeshInstance3D
var passenger_window: MeshInstance3D
var windows_open := false

var cabin_material: StandardMaterial3D
var seat_material: StandardMaterial3D
var dashboard_material: StandardMaterial3D
var glass_material: StandardMaterial3D

func _ready() -> void:
    create_materials()
    create_cabin()
    create_dashboard()
    create_seats()
    create_windows()

func create_materials() -> void:
    cabin_material = make_material(Color(0.12, 0.13, 0.14))
    seat_material = make_material(Color(0.12, 0.07, 0.04))
    dashboard_material = make_material(Color(0.035, 0.04, 0.045))

    glass_material = make_material(Color(0.35, 0.65, 0.8, 0.3))
    glass_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

func make_material(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    return material

func add_box(
    object_name: String,
    dimensions: Vector3,
    location: Vector3,
    material: Material
) -> MeshInstance3D:
    var mesh_instance := MeshInstance3D.new()
    var mesh := BoxMesh.new()

    mesh.size = dimensions
    mesh_instance.name = object_name
    mesh_instance.mesh = mesh
    mesh_instance.position = location
    mesh_instance.material_override = material

    add_child(mesh_instance)
    return mesh_instance

func create_cabin() -> void:
    # Cabin floor
    add_box(
        "CabinFloor",
        Vector3(2.3, 0.12, 2.5),
        Vector3(0, 0.15, 0),
        cabin_material
    )

    # Dashboard
    add_box(
        "Dashboard",
        Vector3(2.2, 0.35, 0.45),
        Vector3(0, 1.15, -0.95),
        dashboard_material
    )

    # Roof
    add_box(
        "CabinRoof",
        Vector3(2.3, 0.12, 2.2),
        Vector3(0, 2.55, 0.1),
        cabin_material
    )

    # Rear cabin wall
    add_box(
        "RearWall",
        Vector3(2.2, 2.3, 0.12),
        Vector3(0, 1.3, 1.05),
        cabin_material
    )

    # Left and right door panels
    add_box(
        "LeftDoor",
        Vector3(0.12, 1.8, 2.0),
        Vector3(-1.08, 1.2, 0),
        cabin_material
    )

    add_box(
        "RightDoor",
        Vector3(0.12, 1.8, 2.0),
        Vector3(1.08, 1.2, 0),
        cabin_material
    )

    # Front windscreen
    add_box(
        "FrontWindscreen",
        Vector3(2.0, 1.0, 0.035),
        Vector3(0, 1.95, -0.95),
        glass_material
    )

func create_dashboard() -> void:
    # Steering column
    var column := add_box(
        "SteeringColumn",
        Vector3(0.12, 0.12, 0.55),
        Vector3(-0.55, 1.0, -0.65),
        cabin_material
    )

    column.rotation.x = -0.35

    # Steering wheel
    var wheel := MeshInstance3D.new()
    var wheel_mesh := TorusMesh.new()
    wheel_mesh.inner_radius = 0.32
    wheel_mesh.outer_radius = 0.38

    wheel.mesh = wheel_mesh
    wheel.position = Vector3(-0.55, 1.35, -0.38)
    wheel.rotation.x = 0.35
    wheel.material_override = cabin_material
    add_child(wheel)

    # Instrument display
    add_box(
        "InstrumentCluster",
        Vector3(0.8, 0.3, 0.08),
        Vector3(-0.55, 1.55, -0.9),
        dashboard_material
    )

    # Multimedia screen
    add_box(
        "MultimediaScreen",
        Vector3(0.55, 0.35, 0.06),
        Vector3(0.55, 1.48, -0.85),
        make_material(Color(0.02, 0.12, 0.2))
    )

    # CB radio
    add_box(
        "CBRadio",
        Vector3(0.42, 0.16, 0.25),
        Vector3(0.55, 1.2, -0.5),
        cabin_material
    )

func create_seats() -> void:
    # Driver seat
    add_box(
        "DriverSeatBase",
        Vector3(0.8, 0.25, 0.8),
        Vector3(-0.55, 0.65, 0.35),
        seat_material
    )

    add_box(
        "DriverSeatBack",
        Vector3(0.8, 1.0, 0.25),
        Vector3(-0.55, 1.2, 0.7),
        seat_material
    )

    # Passenger seat
    add_box(
        "PassengerSeatBase",
        Vector3(0.8, 0.25, 0.8),
        Vector3(0.55, 0.65, 0.35),
        seat_material
    )

    add_box(
        "PassengerSeatBack",
        Vector3(0.8, 1.0, 0.25),
        Vector3(0.55, 1.2, 0.7),
        seat_material
    )

func create_windows() -> void:
    driver_window = add_box(
        "DriverWindow",
        Vector3(0.025, 0.9, 0.8),
        Vector3(-1.0, 1.8, 0),
        glass_material
    )

    passenger_window = add_box(
        "PassengerWindow",
        Vector3(0.025, 0.9, 0.8),
        Vector3(1.0, 1.8, 0),
        glass_material
    )

func toggle_windows() -> void:
    windows_open = not windows_open

    var target_height := 1.0 if windows_open else 1.8

    var tween := create_tween()
    tween.set_parallel(true)

    tween.tween_property(
        driver_window,
        "position:y",
        target_height,
        0.7
    )

    tween.tween_property(
        passenger_window,
        "position:y",
        target_height,
        0.7
    )
