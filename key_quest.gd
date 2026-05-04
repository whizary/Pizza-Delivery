extends Control

@onready var keyText = $TextureRect/Text
@onready var nameText = $TextureRect/Name
@onready var quest = $TextureRect

@onready var deny = $TextureRect/Deny
@onready var accept = $TextureRect/Accept

@onready var quest_1 = $Quest1
@onready var quest_2 = $Quest2
@onready var label1 = $Quest1/Label
@onready var label2 = $Quest2/Label
@onready var label3 = $Quest3/Label
@onready var check_box = $Quest1/CheckBox
@onready var check_box_2 = $Quest2/CheckBox2

var dialogue_playing = false

func _ready():
	quest_1.visible = false
	quest_2.visible = false
	quest.visible = false
	accept.visible = false
	deny.visible = false

func _process(delta):
	# STOPPA ALLT med Henry om han redan är klar
	if Global.henry_dialog_done and Global.keyQ:
		return
	# HENRY
	if !dialogue_playing \
	and !Global.henry_dialog_done \
	and Global.keyquest_index == 0 \
	and Global.keyQ == true \
	and Input.is_action_just_pressed("take_quest"):
		
		dialogue_playing = true
		Global.movement = false
		quest.visible = true
		accept.visible = false
		Global.hottis = false
		deny.visible = false
		Global.keyquest_index = 1
		

		nameText.text = "Henry"
		keyText.text = "I noticed something strange about that door..."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "There are no guards... and yet no one gets through."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Last time someone tried..."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "They never came back."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "But there is a way."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Somewhere out there lies a legendary pizza..."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Find it, and the door will open."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Behind it... a powerful boss awaits."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Defeat it, and a key will appear."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "That key is your only way forward."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "It won't be easy... but I believe you can do it."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Are you ready for the challenge?"
		await get_tree().create_timer(1.0).timeout

		keyText.text = ""
		accept.visible = true
		deny.visible = false
		dialogue_playing = false

	# SKIP DIALOG
	if Input.is_action_just_pressed("KEY_SPACE") and dialogue_playing:
		accept.visible = true
		deny.visible = false
		dialogue_playing = false
		keyText.text = ""

	# ALLY - ta questen
	if !dialogue_playing and Global.allyquest_index == 0 and Global.allyQ == true and !Global.AllyquestComplete and Input.is_action_just_pressed("take_quest"):
		dialogue_playing = true
		quest.visible = true
		accept.visible = false
		deny.visible = false
		Global.allyquest_index = 1
		Global.tut_pause = true
		Global.movement = false

		nameText.text = "Ally"

		# Om dialogen redan visats tidigare: hoppa direkt till knapparna
		if Global.ally_dialog_seen:
			keyText.text = ""
			accept.visible = true
			deny.visible = false
			dialogue_playing = false
		else:
			Global.ally_dialog_seen = true

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
			deny.visible = false
	
			dialogue_playing = false

	# ALLY - återvänd efter klarad quest
	if !dialogue_playing and Global.allyQ == true and Global.AllyquestComplete == true and Global.allyRewardGiven == false and Input.is_action_just_pressed("take_quest"):
		dialogue_playing = true
		Global.tut_pause = true
		quest.visible = true
		accept.visible = false
		deny.visible = false
		Global.movement = false

		nameText.text = "Ally"

		keyText.text = "You made it back!"
		await get_tree().create_timer(1.2).timeout
		keyText.text = "Thank you so much for helping me."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "Here, take this food."
		await get_tree().create_timer(2.0).timeout
		keyText.text = "You earned it!"
		Global.tutorial_index = 9
		await get_tree().create_timer(1.5).timeout

		keyText.text = ""
		quest.visible = false
		Global.tut_pause = false

		# ta bort Ally-questen från vänstra hörnet
		if quest_1.visible and (label1.text == "Collect food" or label1.text == "Return to Ally"):
			if quest_2.visible:
				label1.text = label2.text
				check_box.button_pressed = check_box_2.button_pressed
				quest_2.visible = false
				check_box_2.button_pressed = false
				label2.text = ""
			else:
				quest_1.visible = false
				check_box.button_pressed = false
				label1.text = ""

		elif quest_2.visible and (label2.text == "Collect food" or label2.text == "Return to Ally"):
			quest_2.visible = false
			check_box_2.button_pressed = false
			label2.text = ""

		Global.allyTurnInFinished = true
		dialogue_playing = false

	# uppdatera text när Ally-questen är klar
	if Global.AllyquestComplete == true:
		if quest_1.visible and label1.text == "Collect food":
			label1.text = "Return to Ally"
			check_box.button_pressed = true
		elif quest_2.visible and label2.text == "Collect food":
			label2.text = "Return to Ally"
			check_box_2.button_pressed = true
	
	if Global.HenryquestComplete == true:
		if quest_1.visible and label1.text == "Find the Pizza":
			label1.text = "Boss Door is open"
			label1.position = Vector2(35, 18)
			check_box.visible = false
		elif quest_2.visible and label2.text == "Find the Pizza":
			label2.text = "Boss Door is open"
			label1.position = Vector2(35, 18)
			check_box_2.visible = false


func _on_deny_pressed():
	quest.visible = false
	accept.visible = false
	deny.visible = false
	keyText.text = ""
	Global.tut_pause = false
	Global.movement = true
	Global.ally_dialog_seen = true

	if Global.keyQ:
		Global.keyquest_index = 0

	if Global.allyQ and !Global.AllyquestComplete:
		Global.allyquest_index = 0
		Global.tutorial_index = 5


func _on_accept_pressed():
	Global.acceptedQuest = true
	Global.tut = true
	Global.tut_pause = false
	Global.movement = true

	# Om tutorialen väntar på Ally-accept
	if Global.allyQ and Global.tutorial_index == 5:
		Global.tutorial_index = 7

	# Henry
	if Global.keyQ:
		Global.henry_dialog_done = true
		if quest_1.visible == true:
			quest_2.visible = true
			label2.text = "Find the Pizza"
			
			check_box_2.button_pressed = false
		else:
			quest_1.visible = true
			check_box.button_pressed = false
			label1.text = "Find the Pizza"

		Global.keyquest_index = 1

	# Ally
	elif Global.allyQ:
		if quest_1.visible == true:
			quest_2.visible = true
			label2.text = "Collect food"
			check_box_2.button_pressed = false
		else:
			quest_1.visible = true
			label1.text = "Collect food"
			check_box.button_pressed = false

		Global.allyquest_index = 1


	quest.visible = false
	accept.visible = false
	deny.visible = false
	keyText.text = ""
