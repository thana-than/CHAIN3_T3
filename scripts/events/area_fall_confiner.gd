extends Area3D

@export var active = true
@export var shape_source : CollisionShape3D
@export var sides_margin := 1.0
@export var top_margin := 1.0
@export var limit_body_velocity = 0.0

@onready var _logger := Logger.new(name)
@onready var box := shape_source.shape as BoxShape3D

var confined_bodies : Array[Node3D] = []

func _ready():
	if not box:
		_logger.err("ColliderShape3D must contain a BoxShape3D")
		return
		
	body_entered.connect(confine_body)

func confine_body(body: Node3D):
	if not active:
		return
	if not confined_bodies.has(body):
		confined_bodies.append(body)
		
func free_bodies():
	confined_bodies.clear()

func activate():
	active = true;

func deactivate():
	free_bodies()
	active = false

func _physics_process(_delta: float) -> void:
	if not active:
		return
		
	if not box:
		return
		
	var trf = shape_source.to_global(shape_source.position + box.size / 2)
	var blb = shape_source.to_global(shape_source.position - box.size / 2)
	
	for body in confined_bodies:
		if limit_body_velocity > 0.0:
			if 'velocity' in body:
				var length = body.velocity.length()
				if length > limit_body_velocity:
					body.velocity = body.velocity.normalized() * limit_body_velocity
				
		if body.global_position.y < blb.y:
			body.global_position.y = trf.y - top_margin
		
		body.global_position.x = clamp(body.global_position.x, blb.x - sides_margin, trf.x - sides_margin)
		body.global_position.z = clamp(body.global_position.z, blb.z - sides_margin, trf.z - sides_margin)
