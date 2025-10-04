extends LineEdit
var regex = RegEx.new()
var oldtext = ""
var puntero

@export var numeroEnteros : bool = true
@export var negativos : bool = false
@export var decimales : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if numeroEnteros:
		regex.compile("^[0-9]*$") #para admitir numeros
		if negativos:
			regex.compile("^[0-9]*$") #para admitir numeros
	else:
		regex.compile("^[a-zA-Z]*$") #para letras
	#regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$") #para correos [no funciona]
	
	self.text_changed.connect(self._on_text_changed.bind())

func _process(_delta):
	pass

func _on_text_changed(new_text):
	puntero = get_caret_column()
	if regex.search(new_text):
		text = new_text
		oldtext = text
	else:
		text = oldtext
		
	set_caret_column(puntero)
