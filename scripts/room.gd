extends Node3D
class_name Room

signal entered
signal exited

@export var cull_distance := 40.0

@onready var enter_trigger: Area3D = get_node(NodePath("room_area"))
@onready var cull_root: Node3D = get_node(NodePath("cull_root"))
@onready var cull_position := cull_root.global_position

var room_index := 0

func _ready() -> void:
	enter_trigger.body_entered.connect(_on_body_entered_trigger)
	enter_trigger.body_exited.connect(_on_body_exited_trigger)

func _on_body_entered_trigger(body: Node) -> void:
	if body is Player:
		enter()

func _on_body_exited_trigger(body: Node) -> void:
	if body is Player:
		exit()

func enter() -> void:
	entered.emit()

func exit() -> void:
	exited.emit()
