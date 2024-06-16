XKB_DIR = /usr/share/X11/xkb
# XKB_DIR = $(HOME)/projects/US-BR/test

SYMBOLS_DIR = $(XKB_DIR)/symbols 
RULES_DIR = $(XKB_DIR)/rules

install:
	@echo "Installing custom XKB files..."
	cp symbols/us $(SYMBOLS_DIR)
	cp -v rules/evdev.* $(RULES_DIR)
