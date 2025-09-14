extends Node

var cache : Dictionary[String, AudioEmitter]
var last_emitter : AudioEmitter

func create_emitter(audio_resource : AudioEventResource):
	var emitter = AudioEmitter.new(audio_resource)
	emitter.stop_mode = AudioEmitter.AUDIO_STOP_MODE.STOP_ALLOWFADEOUT
	emitter.spacial3D = false
	emitter.debug = true
	add_child(emitter)
	return emitter

func play_music(audio_resource : AudioEventResource):
	var emitter = cache.get(audio_resource.name)
	if not emitter:
		emitter = create_emitter(audio_resource)
		cache.set(audio_resource.name, emitter)
	
	if last_emitter:
		if last_emitter == emitter:
			return
			
		last_emitter.stop()
	
	last_emitter = emitter
	emitter.play()
