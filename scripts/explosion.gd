extends GPUParticles3D

func set_radius(radius: float):
	lifetime = radius
	$Timer.wait_time = lifetime
