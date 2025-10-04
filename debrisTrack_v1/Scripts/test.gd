extends Control

func sort_ascending(a, b):
	if a[0] < b[0]:
		return true
	return false

func _ready():
		
	var my_items = [[13.009109, "debris_1", 1],[18.009109, "debris_2", 2], [2.009109, "debris_3", 3],[1832323.009109, "debris_4", 13]]
	print("no ordenado ",my_items)
	my_items.sort_custom(sort_ascending)
	my_items.insert(0, ["fecha juliana", "nombre", "id"])
	print("Ordenado ",my_items) # Prints [[4, Tomato], [5, Potato], [9, Rice]].

"""	# Descending, lambda version.
	my_items.sort_custom(func(a, b): return a[0] > b[0])
	print(my_items) # Prints [[9, Rice], [5, Potato], [4, Tomato]]."""
