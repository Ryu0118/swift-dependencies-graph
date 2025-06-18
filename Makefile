COMMAND_NAME = dgraph
BINARY_PATH = ./.build/release/$(COMMAND_NAME)
VERSION = 0.2.0

.PHONY: release
release:
	mkdir -p releases
	swift build -c release
	cp $(BINARY_PATH) dgraph
	tar acvf releases/DependenciesGraph_$(VERSION).tar.gz dgraph
	cp dgraph releases/dgraph
	rm dgraph

