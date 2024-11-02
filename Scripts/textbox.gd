extends CanvasLayer

const CHAR_READ_RATE = 0.05

#Loads necessary nodes
@onready var textbox_container = $Panel
@onready var start_symbol = $Start
@onready var end_symbol = $End
@onready var label = $Text

#Creates a tween variable
@onready var tween = create_tween()

#States of the textbox
enum State{
	READY,
	READING,
	FINISHED,
	NONE
}

#Variable
var dialogues = {} #Translates JSON data into a dictionary for extracting names and dialogue lines
var current_dialogue_id = "000" #ID of the dialogue to be displayed next
var current_state = State.NONE#Tracks the current state of the textbox
var text_queue = [] #Stores text to be displayed

func _ready():
	print("Current state is: READY")
	print("Current state is: " + str(current_dialogue_id))
	hide_textbox()
	#Loads all dialogues from JSON file into the dialogues dictionary
	dialogues = load_dialogues()

func _process(delta):
	if(Input.is_action_just_pressed("interact") and current_state == State.NONE):
		current_state = State.READY
	match current_state:
		State.READY:
			load_dialogue(current_dialogue_id)
			# If there are texts in the queue, display them
			if !text_queue.is_empty():
				display_text()
		State.READING:
			if(Input.is_action_just_pressed("interact")):
				label.visible_characters = -1
				tween.kill()
				end_symbol.text = "V"
				change_state(State.FINISHED)
		State.FINISHED:
			if(Input.is_action_just_pressed("interact")):
				change_state(State.READY)
				if current_dialogue_id == "":
					change_state(State.NONE)
					hide_textbox()

func load_dialogue(dialogue_id):
	if str(dialogue_id) in dialogues: #Check if dialogue ID exists in the dialogue data
		var dialogue_data = dialogues[dialogue_id]
		queue_text(dialogue_data["text"]) #Queue the dialogue text from JSON data
		if "next" in dialogue_data: #Check if there's a next dialogue ID
			current_dialogue_id = dialogue_data["next"] #Update current dialogue ID
			

#Loads dialogues from JSON file and converts them into a dictionary
func load_dialogues():
	var file = FileAccess.open("res://dialogues.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

#Adds the text into the text queue
func queue_text(next_text):
	text_queue.push_back(next_text)

#Hides the textbox and symbols
func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	label.hide()
	end_symbol.hide()
	start_symbol.hide()
	textbox_container.hide()

#Displays the textbox on the screen
func show_textbox():
	start_symbol.text = "*"
	end_symbol.show()
	start_symbol.show()
	label.show()
	textbox_container.show()

#Displays text from the text queue using a tween
func display_text():
	label.visible_characters = 0
	tween = create_tween()
	var next_text = text_queue.pop_front()
	label.text = next_text
	show_textbox()
	change_state(State.READING) # Changed to change state before tweening
	tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)

#Executes when the tween animation finishes
func on_tween_finished():
	end_symbol.text = "V"
	change_state(State.FINISHED)
	
#Updates the state of the textbox
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Current state is: READY")
		State.READING:
			print("Current state is: READING")
		State.FINISHED:
			print("Current state is: FINISHED")
