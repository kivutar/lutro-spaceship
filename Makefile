lutro:
	zip -9 -r spaceship.lutro ./*

love:
	zip -9 -r spaceship.love ./*

wasm:
	docker run --rm -v $(PWD):/src -w /src -u $(id -u):$(id -g) emscripten/emsdk python3 /emsdk/upstream/emscripten/tools/file_packager.py spaceship.data --preload ./* --js-output=spaceship.js
	
clean:
	@$(RM) -f spaceship.*

PHONY: all clean
