extends Node2D

var floor_tile_texture = load("res://assets/tiles.png")
var player_texture = load("res://assets/player/adventurer-idle-00.png")
var card_background_texture = load("res://assets/card.png")
var arrow_up_texture = load("res://assets/arrow_up.png")

const grid_size = Vector2(7, 5)
const grid_scale = 32.0
const card_spacing = 50.0
const hand_height = 50.0

var player_grid_position = (grid_size / 2).floor()

var player: Sprite
var camera: Camera2D

var deck = [
	Card.new(arrow_up_texture, 0.0), # up
	Card.new(arrow_up_texture, 90.0), # right
	Card.new(arrow_up_texture, 180.0), # down
	Card.new(arrow_up_texture, 270.0), # left
]

var hand = []

func _ready():
	randomize()

	var world: Node2D = get_node("GameWorld")
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			world.add_child(create_floor_tile(x, y), true)
	
	player = Sprite.new()
	player.texture = player_texture
	world.add_child(player)

	camera = Camera2D.new()
	camera.current = true
	world.add_child(camera)

	# deal initial hand
	deck.shuffle()
	for _i in 3:
		hand.append(deck.pop_front())

	var cards_container = get_node("Cards")
	for card in hand:
		var card_node = Node2D.new()
		cards_container.add_child(card_node)

		var card_background_sprite = Sprite.new()
		card_background_sprite.name = "Background"
		card_background_sprite.texture = card_background_texture
		card_node.add_child(card_background_sprite)

		var card_icon_sprite = Sprite.new()
		card_icon_sprite.name = "Icon"
		card_icon_sprite.texture = card.texture
		card_icon_sprite.rotation_degrees = card.image_rotation
		card_node.add_child(card_icon_sprite)

	var card_nodes = cards_container.get_children()
	var viewport_size = get_viewport_rect().size

	print(viewport_size)

	for index in card_nodes.size():
		var card_node: Node2D = card_nodes[index]
		
		card_node.position = Vector2(
			viewport_size.x / 2
				- (hand.size() * card_spacing) / 2
				+ index * card_spacing
				+ card_spacing / 2,
			(viewport_size.y - hand_height / 2)
		)

func _process(_delta):
	player.position = player_grid_position * grid_scale
	camera.position = player.position

func create_floor_tile(grid_x: float, grid_y: float):
	var floor_tile = Sprite.new()
	floor_tile.texture = floor_tile_texture
	floor_tile.region_rect = Rect2(336, 96, 32, 32)
	floor_tile.region_enabled = true
	floor_tile.position = Vector2(grid_x, grid_y) * grid_scale
	floor_tile.visible = true
	return floor_tile

class Card:
	var texture: Texture
	var image_rotation: float

	func _init(_texture, _image_rotation):
		texture = _texture
		image_rotation = _image_rotation
