
extends Panel

const Tile = preload("res://tile.xscn")
const Core = preload("res://core.xscn")

const tile_side = 60
const recoil = 20
const DarkCyan = Color(0, 0.5, 0.5)
const Yellow = Color(1, 1, 0)
const White = Color(1, 1, 1)

var board = [[], [], [], [], []]
var boardCorners = [Vector2(0, 0), Vector2(0, 335), Vector2(335, 335), Vector2(335, 0)]
var activeTiles = [[]]
var check = true
var mouse_color = White


func _ready():
	get_node("Background").set_polygon(boardCorners)
	get_node("Background").set_color(DarkCyan)
	for i in range(5):
		for j in range(5):
			board[i].append(Tile.instance())
			board[i][j].set_pos(Vector2(i*(tile_side+5)+recoil, j*(tile_side+5)+recoil))
			add_child(board[i][j])
	remove_child(board[3][2])
	board[3][2] = Core.instance()
	board[3][2].set_pos(Vector2(3*(tile_side+5)+20, 2*(tile_side+5)+20))
	board[3][2].set_color(Yellow)
	board[3][2].set_priority(0)
	add_child(board[3][2])
	remove_child(board[0][0])
	board[0][0] = Core.instance()
	board[0][0].set_pos(Vector2(20, 20))
	board[0][0].set_color(Yellow)
	board[0][0].set_priority(1)
	add_child(board[0][0])
	print(board[1][0].get_color())
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if (Input.is_mouse_button_pressed(BUTTON_LEFT) == true):
		var i = 0
		var j = 0
		var itIs = mouse_is_on_tile(i, j)
		while (itIs == false and i < 5):
			j = 0
			while (itIs == false and j < 5):
				itIs = mouse_is_on_tile(i, j)
				if (itIs == false):
					j += 1
			if (itIs == false):
				i += 1
		if (itIs == true and i < 5 and j < 5):
			#print(i, ":", j, "print 1")
			var stop = false
			while (activeTiles[0].size() != 0 and stop == false and board[i][j].get_color() != White and board[i][j].get_type() != "Core"):
				if (activeTiles[0][activeTiles[0].size()-1].x != i or activeTiles[0][activeTiles[0].size()-1].y != j):
					board[activeTiles[0][activeTiles[0].size()-1].x][activeTiles[0][activeTiles[0].size()-1].y].set_color(White)
					activeTiles[0].remove(activeTiles[0].size()-1)
				else:
					stop = true
			#print("Hey")
			#print(mouse_color)
			if (board[i][j].get_type() == "Tile"):
				if (board[i][j].get_color() == White and is_the_next(i, j, 0)):
					board[i][j].set_color(mouse_color)
					activeTiles[0].append(Vector2(i ,j))
					#print(activeTiles)
					#print("it's a tile")
			else:
				#print("It's a core!")
				activeTiles[0].append(Vector2(i ,j))
				mouse_color = board[i][j].get_color()

func mouse_is_on_tile(i, j):
	var pos = get_viewport().get_mouse_pos()
	#print(get_viewport().get_mouse_pos().x, ":", get_viewport().get_mouse_pos().y)
	if (pos.x > i*(tile_side+5)+recoil and pos.y > j*(tile_side+5)+recoil and pos.x < (i+1)*tile_side+recoil and pos.y < (j+1)*tile_side+recoil):
		#print(i, ":", j)
		return true
	return false

#adicionar a checagem na cor da tile
func is_the_next(i, j, colorNo):
	if (activeTiles[0].size() == 0):
		return true
	var tile = activeTiles[colorNo][activeTiles[colorNo].size()-1]
	if (tile.x == i+1 and tile.y == j):
		return true
	if (tile.x == i-1 and tile.y == j):
		return true
	if (tile.x == i and tile.y == j+1):
		return true
	if (tile.x == i and tile.y == j-1):
		return true
	return false
