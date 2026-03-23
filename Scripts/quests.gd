extends Control
@onready var label1 = $TextureRect/Label
@onready var label2 = $TextureRect2/Label
@onready var label3 = $TextureRect3/Label

@onready var quest1 = $TextureRect
@onready var quest2 = $TextureRect2
@onready var quest3 = $TextureRect3
#☐ Find food
#☑ Go back to Ally
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	quest1.visible = false
	quest2.visible = false
	quest3.visible = false
	if get_tree().get_nodes_in_group("player"):
		player = get_tree().get_nodes_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _acceptedQuest():
	if Global.acceptedQuest == true:
		if quest1.visible == true and Input.is_action_just_pressed("take_quest"):
			#print("quest1 true")
			quest2.visible = true
			label2.text = "Collect key2"
		else:
			quest1.visible = true
			label1.text = "Collect key"
			#print("Test2")
			return
	#Om player accept = kolla om redan har quest = sätt ny quest under = gör quest2 visible
	#Global accept = true
	
func _process(delta):
	pass
