extends RichTextEffect
class_name Scroll

var bbcode = "scroll"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var vertical_size = char_fx.env.get("vertical_size", 6)
	char_fx.offset.y -= vertical_size * 16*(char_fx.elapsed_time)
	
	return true
