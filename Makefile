RETROARCH=/Applications/RetroArch.app/Contents/MacOS/RetroArch
RETROCORE_LIBRETRO="$(HOME)/Library/Application Support/RetroArch/cores/lutro_libretro.dylib"

lutro:
	zip -9 -r spaceship.lutro ./*

love:
	zip -9 -r spaceship.love ./*

wasm:
	docker run --rm -v $(PWD):/src -w /src -u $(id -u):$(id -g) emscripten/emsdk python3 /emsdk/upstream/emscripten/tools/file_packager.py spaceship.data --preload ./* --js-output=spaceship.js
	
clean:
	@$(RM) -f spaceship*

run:
	$(RETROARCH) -L $(RETROCORE_LIBRETRO) spaceship.lutro

PHONY: all clean
