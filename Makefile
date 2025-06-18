COMMAND_NAME = dgraph
BINARY_PATH = ./.build/release/$(COMMAND_NAME)
<<<<<<< add-strip-transitive-option
VERSION = 0.2.0
=======
VERSION = 0.1.0
>>>>>>> main

.PHONY: release
release:
	mkdir -p releases
	swift build -c release
	cp $(BINARY_PATH) dgraph
	tar acvf releases/DependenciesGraph_$(VERSION).tar.gz dgraph
	cp dgraph releases/dgraph
	rm dgraph

