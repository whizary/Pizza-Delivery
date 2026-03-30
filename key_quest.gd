extends Control

@onready var keyText = $TextureRect/Text
@onready var nameText = $TextureRect/Name
@onready var quest = $TextureRect

@onready var deny = $TextureRect/Deny
@onready var accept = $TextureRect/Accept

@onready var quest_1 = $Quest1
@onready var quest_2 = $Quest2
@onready var quest_3 = $Quest3
@onready var label1 = $Quest1/Label
@onready var label2 = $Quest2/Label
@onready var label3 = $Quest3/Label

var dialogue_playing = false

func _ready():
	quest_1.visible = false
	quest_2.visible = false
	quest_3.visible = false
	quest.visible = false
	accept.visible = false
	deny.visible = false

func _process(delta):
	# HENRY
	if !dialogue_playing and Global.keyquest_index == 0 and Global.keyQ == true and Input.is_action_just_pressed("take_quest"):
		dialogue_playing = true
		quest.visible = true
		accept.visible = false
		deny.visible = false
		Global.keyquest_index = 1

		nameText.text = "Henry"

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

		dialogue_playing = false
	if Input.is_action_just_pressed("KEY_SPACE"):
			accept.visible = true
			deny.visible = true
			dialogue_playing = false
			keyText.text = ""
	# ALLY - ta questen
	if !dialogue_playing and Global.allyquest_index == 0 and Global.allyQ == true and !Global.AllyquestComplete and Input.is_action_just_pressed("take_quest"):
		dialogue_playing = true
		quest.visible = true
		accept.visible = false
		deny.visible = false
		Global.allyquest_index = 1

		nameText.text = "Ally"

		keyText.text = "Hey you!"
		await get_tree().create_timer(1.0).timeout
		keyText.text = "I am really hungry..."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Could you bring me some food?"
		await get_tree().create_timer(2.0).timeout
		keyText.text = "I would really appreciate it."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Will you help me?"
		await get_tree().create_timer(1.0).timeout
		keyText.text = ""
		accept.visible = true
		deny.visible = true

		dialogue_playing = false

	# ALLY - återvänd efter klarad quest
	if !dialogue_playing and Global.allyQ == true and Global.AllyquestComplete == true and Global.allyRewardGiven == false and Input.is_action_just_pressed("take_quest"):
		dialogue_playing = true
		quest.visible = true
		accept.visible = false
		deny.visible = false

		nameText.text = "Ally"

		keyText.text = "You made it back!"
		await get_tree().create_timer(1.2).timeout
		keyText.text = "Thank you so much for helping me."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Here, take this food."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "You earned it!"
		await get_tree().create_timer(1.5).timeout

		# göm dialogrutan
		keyText.text = ""
		quest.visible = false

		# ta bort Ally-questen från vänstra hörnet
		if quest_1.visible and (label1.text == "☐ Collect food" or label1.text == "☑ Return to Ally"):
			quest_1.visible = false

		if quest_2.visible and (label2.text == "☐ Collect food" or label2.text == "☑ Return to Ally"):
			quest_2.visible = false

		if quest_3.visible and (label3.text == "☐ Collect food" or label3.text == "☑ Return to Ally"):
			quest_3.visible = false

		Global.allyTurnInFinished = true
		dialogue_playing = false

	# uppdatera text när Ally-questen är klar
	if Global.AllyquestComplete == true:
		if quest_1.visible and label1.text == "☐ Collect food":
			label1.text = "☑ Return to Ally"
		elif quest_2.visible and label2.text == "☐ Collect food":
			label2.text = "☑ Return to Ally"
		elif quest_3.visible and label3.text == "☐ Collect food":
			label3.text = "☑ Return to Ally"

func _on_deny_pressed():
	quest.visible = false
	accept.visible = false
	deny.visible = false
	Global.movement = true

	if Global.keyQ:
		Global.keyquest_index = 0

	if Global.allyQ and !Global.AllyquestComplete:
		Global.allyquest_index = 0

func _on_accept_pressed():
	Global.acceptedQuest = true

	# Henry
	if Global.keyQ:
		if quest_1.visible == true:
			quest_2.visible = true
			label2.text = "Collect key2"
		else:
			quest_1.visible = true
			label1.text = "Collect key"

		Global.keyquest_index = 1

	# Ally
	elif Global.allyQ:
		if quest_1.visible == true:
			quest_2.visible = true
			label2.text = "☐ Collect food"
		else:
			quest_1.visible = true
			label1.text = "☐ Collect food"

		Global.allyquest_index = 1
		
	Global.movement = true
	quest.visible = false
	accept.visible = false
	deny.visible = false
