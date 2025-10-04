extends Node3D

#region Variables
@export_category("variables que definen cualidades")
#------variables que definen cualidades------#
@export_enum("Meteoroide", "Fragmento", "Satelite") var Object_Type : int
@export var nombre : String = "sarya"
@export var Grande : bool = false
@export var IconColor : Color = Color("White")

@export_category("Agrandar escala para ver donde esta")
#------agrandar escala para ver donde esta------#
@export var FixedSize : bool = false

@export_category("variables que muestran el aspecto")
#------variables que muestran el aspecto------#
@export var DebrisRockIcon : Array[Texture]
@export var FragmentIcon : Array[Texture]
@export var SateliteIcon : Array[Texture]
@export var Desconosido : CompressedTexture2D

#------variables Internas------#

#------llamado a nodos------#
@onready var Icon : Sprite3D = $Sprite3D
@export var iconTexture : Texture

@onready var texto = $Texto
#endregion


func _ready() -> void:
	texto.text = nombre
#region Definir el icono a mostra
#------Esto definira que tip de objeto sera representado en el icono------#
	if Object_Type == 0: # esto quiere decir que es un meteoroide
		Icon.texture = DebrisRockIcon[1]
		if Grande: # si el meteoroide es grande
			Icon.texture = DebrisRockIcon[0]
	elif Object_Type == 1: # esto quiere decir que es un pedaso de metal
		Icon.texture = FragmentIcon[1]
		if Grande: # si es un fragmento grande
			Icon.texture = FragmentIcon[0]
	elif Object_Type == 2: # Esto define si es un satelite
		Icon.texture = SateliteIcon[1]
		if Grande: #en caso de que sea una estaccion esapacial
			Icon.texture = SateliteIcon[0]
	iconTexture = Icon.texture
#endregione


func _process(delta: float) -> void:
	pass
