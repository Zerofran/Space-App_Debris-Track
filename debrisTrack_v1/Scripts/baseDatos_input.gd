
extends LineEdit
var regex = RegEx.new()
var oldtext = ""
var puntero
# Called when the node enters the scene tree for the first time.
func _ready():
	#regex.compile("^[0-9]*$") #para admitir numeros
	regex.compile("^[a-zA-Z]*$") #para letras
	#regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$") #para correos [no funciona]

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
