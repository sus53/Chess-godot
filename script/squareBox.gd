@tool
# It inherits all properties and methods of ColorRect.
extends ColorRect

@export var dark : bool = false :
	set(v):
		dark = v
		color =  Color.PERU if dark else Color.PEACH_PUFF
