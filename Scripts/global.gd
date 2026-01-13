extends Node

var chase_distance = 250.0

var stamina = 100.0
var maxStamina = 100.0
var staminaDrain = 25.0
var staminaRecovery = 15.0

var health = 100.0
var maxHealth = 100.0
var iframesTimer = 1.0
var iframes = false
var death = false

var current_wave: int
var moving_to_next_wave: bool
