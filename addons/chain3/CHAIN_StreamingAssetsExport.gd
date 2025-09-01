@tool
extends EditorExportPlugin

const FOLDER_NAME = "StreamingAssets"

func _get_name() -> String:
    return "Create Streaming Assets Folder On Export"

func _export_begin(_features: PackedStringArray, _is_debug: bool, path: String, _flags: int) -> void:
    var dir = DirAccess.open(path.get_base_dir())
    if not dir.dir_exists(FOLDER_NAME):
        dir.make_dir(FOLDER_NAME)