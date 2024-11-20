@tool
extends EditorInspectorPlugin


const DialogueEditorProperty = preload("./components/editor_property/editor_property.gd")
var main_view # main view reference.

func _can_handle(object) -> bool:
	if object is DialogueResource: return true
	
	if object is GDScript: return false
	if not object is Node: return false
	if "name" in object and object.name == "Dialogue Manager": return false
	return true


func _parse_property(object: Object, type, name: String, hint_type, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if hint_string == "DialogueResource" or ("dialogue" in name.to_lower() and hint_string == "Resource"):
		var property_editor = DialogueEditorProperty.new()
		add_property_editor(name, property_editor)
		return true
	return false

func _parse_begin(object: Object) -> void:
	if object is DialogueResource:
		var edit_button := Button.new()
		edit_button.text = "Edit"
		edit_button.pressed.connect(_edit.bind(object))
		add_custom_control(edit_button)

func _edit(object) -> void:
	if is_instance_valid(main_view) and is_instance_valid(object):
		main_view.open_resource(object)
		EditorInterface.set_main_screen_editor("Dialogue")
