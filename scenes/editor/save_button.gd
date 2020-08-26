extends TextureButton

export var window : NodePath
onready var window_node = get_node(window)
onready var hover_sound = $HoverSound
onready var click_sound = $ClickSound
var last_hovered = false

func _process(_delta):
	if is_hovered() and !last_hovered:
		hover_sound.play()
	last_hovered = is_hovered()

func _pressed():
	click_sound.play()

	if SavedLevels.selected_level != -1:
		SavedLevels.levels[SavedLevels.selected_level] = LevelInfo.new(CurrentLevelData.level_data.get_encoded_level_data())

		CurrentLevelData.unsaved_editor_changes = false

