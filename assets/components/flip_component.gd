extends Component

func oneshot_action() -> void:
	var subject = get_parent()
	if subject:
		var roomParent = subject.get_parent()
		if roomParent is Room:
			subject.scale.x = roomParent.scale.x
		else:
			printerr("flipComponent: Subject parent is not Room")
	else:
		printerr("flipComponent: Subject does not exist. (no parent)")
