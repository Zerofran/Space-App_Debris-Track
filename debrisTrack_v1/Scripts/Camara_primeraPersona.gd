extends Node3D

@export var rotationSpeed:float = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Rotación de la cámara
	rotation.x += (deg_to_rad(Input.get_action_strength("ui_up")* rotationSpeed) - deg_to_rad(Input.get_action_strength("ui_down")* rotationSpeed))
	rotation.y += (deg_to_rad(Input.get_action_strength("ui_left")* rotationSpeed) - deg_to_rad(Input.get_action_strength("ui_right") * rotationSpeed))
	rotation.x = clamp(rotation.x, deg_to_rad(-50),deg_to_rad(75))
	
