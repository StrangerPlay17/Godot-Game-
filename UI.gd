extends CanvasLayer

var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#var coinNode = get_tree().get_root().find_node("Coin2D", true, false)
	for child in get_tree().get_nodes_in_group("coins"):  # Itera sobre todos los nodos "Coins" en el grupo "coins"
		#print("Nodo Coin2D encontrado: ", child)
		child.connect("coinCollected", handleCoinCollected, 0)
	
	$CoinsCollectedText.text = str(coins)

func handleCoinCollected(): # Funcion para suma de monedas
	print("Coin Collected")
	coins += 1
	$CoinsCollectedText.text = str(coins)
