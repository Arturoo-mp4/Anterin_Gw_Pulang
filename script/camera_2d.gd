extends Camera2D

@export var marcel: Node2D                  # drag node Marcel ke sini lewat Inspector
@export var max_distance := 600.0           # jarak Marcel yang dianggap "paling jauh"
@export var min_zoom := 0.8                 # zoom saat Marcel di jarak maksimum
@export_range(0.0, 1.0) var pull := 0.35    # 0 = tidak bergeser, 0.5 = tepat di tengah Felix-Marcel
@export var smooth := 6.0                   # makin besar, makin cepat responsnya

var remote_active := false
var base_zoom := 1.0

func _ready() -> void:
	base_zoom = zoom.x   # ambil zoom awal dari scene (1.4)

func _process(delta: float) -> void:
	var target_zoom := base_zoom
	var target_offset := Vector2.ZERO

	if remote_active:
		var to_marcel := marcel.global_position - get_parent().global_position
		var t := clampf(to_marcel.length() / max_distance, 0.0, 1.0)
		target_zoom = lerpf(base_zoom, min_zoom, t)
		target_offset = to_marcel * pull

	var w := 1.0 - exp(-smooth * delta)   # lerp yang tidak tergantung framerate
	zoom = zoom.lerp(Vector2.ONE * target_zoom, w)
	offset = offset.lerp(target_offset, w)
