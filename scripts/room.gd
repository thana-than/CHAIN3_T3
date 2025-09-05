extends Node3D
class_name Room

signal entered
signal exited

@export var require_portal := false

@onready var enter_trigger: Area3D = get_node(NodePath("enter_trigger"))

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
