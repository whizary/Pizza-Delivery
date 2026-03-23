extends Control

@onready var keyText = $TextureRect/Text
@onready var quest = $TextureRect

@onready var deny = $TextureRect/Deny
@onready var accept = $TextureRect/Accept

@onready var quest_1 = $Quest1
@onready var quest_2 = $Quest2
@onready var quest_3 = $Quest3
@onready var label1 = $Quest1/Label
@onready var label2 = $Quest2/Label
@onready var label3 = $Quest3/Label

func _ready():
	quest_1.visible = true
	quest_2.visible = false
	quest_3.visible = false
	quest.visible = false
	accept.visible = false
	deny.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.keyquest_index == 0 and Global.keyQ == true and Input.is_action_pressed("take_quest"):
		quest.visible = true
		accept.visible = false
		deny.visible = false
		keyText.text = "Hello Player!"
		await get_tree().create_timer(1.0).timeout
		keyText.text = "I have seen that there are no guards at the door!"
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Last time a player tried to get through..."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "They ended up dead..."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "However, if you are brave enough I have a final quest for you"
		await get_tree().create_timer(2.0).timeout
		keyText.text = "It will be pretty difficult, but I believe in you"
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Are you ready for your final quest?"
		await get_tree().create_timer(1.0).timeout
		keyText.text = ""
		accept.visible = true
		deny.visible = true
		print("taking quest")


func _on_deny_pressed():
	quest.visible = false


func _on_accept_pressed():
	Global.acceptedQuest = true
	if quest_1.visible == true:
		quest_2.visible = true
		label2.text = "Collect key2"
	else:
		quest_1.visible = true
		label1.text = "Collect key"

	quest.visible = false
	accept.visible = false
	deny.visible = false
	Global.keyquest_index = 1
	print("acc")
