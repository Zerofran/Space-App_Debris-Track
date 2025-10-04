extends Control

@export var PhysicsBody : RigidBody3D
@export var VisualBody : Node3D


@export var nombre : String = "Sarya"
@export var Debri = true
@export var Grande : bool = false
@export var BodyPosition : Vector3 = Vector3.ZERO


@onready var Icon : TextureRect = $BoxContainer/HBoxContainer/PrincipalContainer/HBoxContainer/IconContainer/Icon
@export var IconModulate : Color = Color("white")
@export var iconTexture: Texture

@onready var Posicion : Label = $BoxContainer/HBoxContainer/PrincipalContainer/HBoxContainer/ElementContainer/HBoxContainer/Posicion

@export var ID = 2 #identificardor del debris

#llamada a nodos
@onready var labelName : Label = $BoxContainer/HBoxContainer/PrincipalContainer/HBoxContainer/ElementContainer/HBoxContainer/Nombre

func _ready() -> void:
	Icon.texture = iconTexture
	labelName.text = "Nombre: " + nombre + "\nID: " + str(ID)
	set_name(nombre)


func _process(delta: float) -> void:
	Icon.modulate = IconModulate
	Posicion.text = "Posicion: " + str(BodyPosition)
	


func _on_eliminar_pressed() -> void:
	PhysicsBody.queue_free()
	VisualBody.queue_free()
	self.queue_free()
