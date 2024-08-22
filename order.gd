class_name Order extends Resource

@export var number: int
@export var ingredients: Array[OrderItem]

func _init(num: int = 0, items_content: Array[OrderItem] = []):
	ingredients = items_content
	number = num
