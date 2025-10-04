extends RigidBody3D

@export var nombre : String = "Sarya"
@export var Debri = true
@export var CuerpoMenor : bool = false
@export var ID = 1 #identificardor del debris

@export var Masa = 20
@export var VelocidadLineal = Vector3.ZERO
@export var Tipo = ""

@export var Alert : bool = false

#variable de instancia de el nodo que se vera en camara
var Body_Visual : PackedScene = preload("res://debrisTrack_v1/Escenas/body_visual.tscn")
var Instance : Node3D
var Body_HUD :  PackedScene = preload("res://debrisTrack_v1/Escenas/object_hud.tscn")
var InstanceHUD : Control
@onready var HUD_BoxContainer : VBoxContainer = $"../../../HUD/SystemDebrisMenu/SplitContainer/VSplitPrincipal/VSplitLeftContainer/Inspect2_L_Dawn/HBoxContainer/VContainer2/Container2/VBoxContainer/ScrollContainer/HBoxContainer/VBoxContainer2/ObjectHUDContainer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#definir parametros del nodo
	if nombre == "iss":
		mass = Math.IssMass
	else:
		mass = Masa
	set_name(nombre)
	#region Instanciando cuerpos
# Aqui se instancia el objeto visual, el que siempre estara en camara
	Instance = Body_Visual.instantiate()
	Instance.set_name(nombre)
	Instance.nombre = nombre
	Instance.Object_Type = 0
	Instance.Grande = false
	get_parent().add_child.call_deferred(Instance) #instancia como hijo del entorno para ver el objeto en camara
# Aqui se instancia a el objeto que se mostrara en la interfaz
	InstanceHUD = Body_HUD.instantiate()
	InstanceHUD.set_name(name)
	InstanceHUD.nombre = name
	InstanceHUD.ID = ID
	InstanceHUD.iconTexture = Instance.iconTexture
	HUD_BoxContainer.add_child(InstanceHUD) #instancia como hijo del contenedor de interfaz
	#dando referencias a los nodos para su destruccion
	InstanceHUD.PhysicsBody = self
	InstanceHUD.VisualBody = Instance
	#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Alert:
		Instance.IconColor = Color("red")
	#var forceGravity = Math.GravityNewton(Masa, Math.tierraMasa, global_position, Vector3.ZERO)
	#self.constant_force = forceGravity * 10e5
	
	# control de la instancia visual
	Instance.position = self.position/Math.earth_radius
	
	#control de la instancia en el HUD
	InstanceHUD.BodyPosition = position

#funcion para destruir el cuerpo
func Destroy():
	print_rich( "El nodo ","[color=red][b]", nombre,"[/b][/color]", " a sido eliminado")
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("PhysicsBody"):
		Alert = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("PhysicsBody"):
		Alert = false
		
