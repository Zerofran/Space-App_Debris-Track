extends Node3D

#region Variables
@export var sencivilidad : int = 5
@onready var Camara3d: Node = $Camera3D
@export var Aceleracion : int = 10
var mausMovemen = false
var Drag : bool = false
var clickFuera : bool = false
@export var menu : bool = true
#endregion

func _ready():
	pass
	
func _input(event):

#region deteccion de clicks para poder rotar la camara
	if Input.is_action_just_pressed("Maus_left") and Drag == false:
		Input.action_release("Maus_left")
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		
	if Input.is_action_pressed("Maus_left") and Drag:
		mausMovemen= true
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		
	if Input.is_action_just_released("Maus_left"):
		mausMovemen = false
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

#endregion

#region Movimiento de la camara
	if mausMovemen and menu == false:
		if event is InputEventMouseMotion:
			rotation.x -= event.relative.y /1000 * sencivilidad
			rotation.y -= event.relative.x /1000 * sencivilidad
			rotation.x = clamp(rotation.x, deg_to_rad(-60),deg_to_rad(60))
#endregion
		
#region Zoom de la camara
	if menu == false:
		if Input.is_action_pressed("Zoom+"):
			Camara3d.position.z += 2 * get_process_delta_time()
		elif Input.is_action_pressed("Zoom-"):
			Camara3d.position.z -= 2 * get_process_delta_time()
			
#endregion

func _process(_delta):

	rotation_degrees.y = lerp(rotation_degrees.y, rad_to_deg(rotation.y), _delta * Aceleracion)
	rotation_degrees.x = lerp(rotation_degrees.x, rad_to_deg(rotation.x), _delta * Aceleracion)
	# Bloqueando la posicision de la camara durante el Zoom
	Camara3d.position.z =  clamp(Camara3d.position.z, 1.5, 10)

func _on_area_2d_mouse_entered():
	Drag  = true
	
func _on_area_2d_mouse_exited():
	Drag = false
	
