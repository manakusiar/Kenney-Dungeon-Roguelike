extends Node

const SAVE_PATH = "user://keybinds.cfg"

var default_bindings: Dictionary = {}

func _ready():
	_save_default_bindings()
	load_keybinds()

func _save_default_bindings():
	for action in InputMap.get_actions():
		if action.begins_with("ui_"):  # Skip built-in UI actions (optional)
			continue
		default_bindings[action] = InputMap.action_get_events(action).duplicate()

# Rebind an action to a new event
func rebind_action(action: String, new_event: InputEvent, slot: int = 0):
	var events = InputMap.action_get_events(action)
	
	# Remove old event at slot
	if slot < events.size():
		InputMap.action_erase_event(action, events[slot])
	
	# Add new event
	InputMap.action_add_event(action, new_event)
	
	save_keybinds()

# Get the current event for an action
func get_action_event(action: String, slot: int = 0) -> InputEvent:
	var events = InputMap.action_get_events(action)
	if slot < events.size():
		return events[slot]
	return null

# Get readable name for an input event
func get_event_name(event: InputEvent) -> String:
	if event is InputEventKey:
		return event.as_text_physical_keycode()
	elif event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT: return "Left Click"
			MOUSE_BUTTON_RIGHT: return "Right Click"
			MOUSE_BUTTON_MIDDLE: return "Middle Click"
			_: return "Mouse " + str(event.button_index)
	elif event is InputEventJoypadButton:
		return "Pad " + str(event.button_index)
	return "Unknown"

func reset_action(action: String):
	InputMap.action_erase_events(action)
	if default_bindings.has(action):
		for event in default_bindings[action]:
			InputMap.action_add_event(action, event)
	save_keybinds()
func reset_all_to_defaults():
	for action in default_bindings:
		InputMap.action_erase_events(action)
		for event in default_bindings[action]:
			InputMap.action_add_event(action, event)
	save_keybinds()

# Save current keybinds to file
func save_keybinds():
	var config = ConfigFile.new()
	
	for action in default_bindings.keys():
		var events = InputMap.action_get_events(action)
		for i in events.size():
			var event = events[i]
			if event is InputEventKey:
				config.set_value(action, "key_%d" % i, event.physical_keycode)
			elif event is InputEventMouseButton:
				config.set_value(action, "mouse_%d" % i, event.button_index)
	
	config.save(SAVE_PATH)

# Load keybinds from file
func load_keybinds():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return  # No saved bindings, use defaults
	
	for action in config.get_sections():
		if not InputMap.has_action(action):
			continue
		
		InputMap.action_erase_events(action)
		
		for key in config.get_section_keys(action):
			var event: InputEvent
			
			if key.begins_with("key_"):
				event = InputEventKey.new()
				event.physical_keycode = config.get_value(action, key)
			elif key.begins_with("mouse_"):
				event = InputEventMouseButton.new()
				event.button_index = config.get_value(action, key)
			
			if event:
				InputMap.action_add_event(action, event)
