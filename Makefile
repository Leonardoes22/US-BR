# Source
US_BR_SYM = symbols/us_br
US_BR_VARIANTS = rules/us_br_variants

# Target 
XKB_DIR = /usr/share/X11/xkb
# XKB_DIR = $(HOME)/projects/linux_utils/US-BR/xkb

SYMBOLS_DIR = $(XKB_DIR)/symbols
RULES_DIR = $(XKB_DIR)/rules

all: reinstall

install_rule:
	@echo "Installing $(TARGET_RULE)"
	
	@br_variants_start=$$(awk '/<name>br</ {f=1} f && /variantList/ {print NR; exit}' "$(RULES_DIR)/$(TARGET_RULE).xml"); \
	echo "Inserting variants in $(TARGET_RULE).xml at line: $$br_variants_start"; \
    sed -i "$$br_variants_start r $(US_BR_VARIANTS).xml" "$(RULES_DIR)/$(TARGET_RULE).xml"

	@variants_start=$$(awk '/! variant/ {print NR; exit}' "$(RULES_DIR)/$(TARGET_RULE).lst"); \
	echo "Inserting variants in $(TARGET_RULE).lst at line: $$variants_start"; \
    sed -i "$$variants_start r $(US_BR_VARIANTS).lst" "$(RULES_DIR)/$(TARGET_RULE).lst"

uninstall_rule:
	sed -i '/US-BR BEGIN/,/US-BR END/d' "$(RULES_DIR)/$(TARGET_RULE).xml"
	sed -i "/US with ABNT/d" "$(RULES_DIR)/$(TARGET_RULE).lst"

install:
	@echo "Installing custom XKB files..."

	@echo "Appending symbols to $(SYMBOLS_DIR)/br"
	@echo '//US-BR//BEGIN' >> "$(SYMBOLS_DIR)/br"
	@cat $(US_BR_SYM) >> "$(SYMBOLS_DIR)/br"
	@echo '//US-BR//END' >> "$(SYMBOLS_DIR)/br"
	
	$(MAKE) install_rule TARGET_RULE=evdev
	$(MAKE) install_rule TARGET_RULE=base
    

uninstall:
	@echo "Uninstalling custom XKB files..."

	sed -i '/^\/\/US-BR\/\/BEGIN/,/^\/\/US-BR\/\/END/d' $(SYMBOLS_DIR)/br

	$(MAKE) uninstall_rule TARGET_RULE=evdev
	$(MAKE) uninstall_rule TARGET_RULE=base
	
reinstall:
	$(MAKE) uninstall
	$(MAKE) install