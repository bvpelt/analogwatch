DEVICE ?= fr165
KEY = ~/.Garmin/developer_key
APP_NAME = analogwatch

OUTPUT_DIR = bin
OUTPUT_EXT = prg
BIN_DIR = ~/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc/bin

SVG_SOURCE = ./images/analogview.svg
LOGOSVG_SOURCE = ./resources/drawables/vav-logo.svg

# Sentinel files — no inline comments allowed on these lines
ICON_STAMP = .icons_generated
LOGO_STAMP = .logos_generated

.PHONY: clean build run fresh kill-simulator export icons logos clean-icons clean-logos clean-all help

# ─── Help ────────────────────────────────────────────────────────────────────

help: ## Show this help message
	@echo "Usage: make [target] [DEVICE=<device_id>]"
	@echo ""
	@echo "Default device: $(DEVICE)"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "  %-20s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
	@echo "Examples:"
	@echo "  make clean                  # Remove build artifacts and compiled output"
	@echo "  make clean-storage          # Clean build artifacts AND simulator storage for DEVICE"
	@echo "  make clean-icons            # remove generated icons"
	@echo "  make clean-logos            # remove generated colored logos"
	@echo "  make clean-all              # Remove everything — artifacts, storage, icons and logos"
	@echo "  make icons                  # Generate launcher icons from SVG (skipped if SVG unchanged)
	@echo "  make logos                  # Generate colored logo SVGs (skipped if logo SVG unchanged)"
	@echo "  make build                  # Build the watch face for DEVICE (default: $(DEVICE))"
	@echo "  make run                    # Build and run in the simulator for DEVICE (default: $(DEVICE))"
	@echo "  make run DEVICE=fenix7      # Build and run in the simulator for DEVICE fenix7"
	@echo "  make fresh DEVICE=fenix7    # Clean everything, regenerate icons/logos, rebuild and run for DEVICE fenix7"
	@echo "  make export                 # Build release .iq for all devices"
	

# ─── Simulator ───────────────────────────────────────────────────────────────

kill-simulator: ## Kill the simulator and any rogue processes
	@echo "Killing simulator and rogue processes..."
	killall -9 simulator monkeydo shell 2>/dev/null || true

# ─── Icons ───────────────────────────────────────────────────────────────────

$(ICON_STAMP): $(SVG_SOURCE)
	@echo "SVG changed — regenerating icons..."
	rm -rf icon-*
	./convertsvgtopng.bash $(SVG_SOURCE)
	touch $(ICON_STAMP)

icons: $(ICON_STAMP) ## Generate launcher icons from SVG (skipped if SVG unchanged)

# ─── Logos ───────────────────────────────────────────────────────────────────

$(LOGO_STAMP): $(LOGOSVG_SOURCE)
	@echo "Logo SVG changed — regenerating colored logos..."
	rm -f ./resources/drawables/vav-logo-*.svg
	./changesvgcolor.bash $(LOGOSVG_SOURCE)
	touch $(LOGO_STAMP)

logos: $(LOGO_STAMP) ## Generate colored logo SVGs (skipped if logo SVG unchanged)

# ─── Build ───────────────────────────────────────────────────────────────────

# Build depends on icons and logos so they are always generated first
$(OUTPUT_DIR)/$(APP_NAME).$(OUTPUT_EXT): $(ICON_STAMP) $(LOGO_STAMP) $(shell find source -name "*.mc") $(shell find resources -type f) monkey.jungle manifest.xml
	@mkdir -p $(OUTPUT_DIR)
	@echo "Building $@..."
	monkeyc -o $@ -f monkey.jungle -y $(KEY) -d $(DEVICE) -w

build: icons logos $(OUTPUT_DIR)/$(APP_NAME).$(OUTPUT_EXT) ## Build the watch face for DEVICE (default: $(DEVICE))

# ─── Run ─────────────────────────────────────────────────────────────────────

run: build ## Build and run in the simulator for DEVICE (default: $(DEVICE))
	@echo "Running in simulator..."
	pgrep simulator >/dev/null || connectiq &
	sleep 5
	monkeydo $(OUTPUT_DIR)/$(APP_NAME).$(OUTPUT_EXT) $(DEVICE) \
		-a $(OUTPUT_DIR)/$(APP_NAME)-settings.json:GARMIN/Settings/$(APP_NAME)-settings.json

# ─── Clean ───────────────────────────────────────────────────────────────────

clean: kill-simulator ## Remove build artifacts and compiled output
	@echo "Cleaning build artifacts..."
	rm -rf $(OUTPUT_DIR)/ build/
	find . -name "*.$(OUTPUT_EXT)" -delete

clean-storage: clean ## Clean build artifacts AND simulator storage for DEVICE
	@echo "Cleaning simulator storage..."
	rm -rf source/mir/ source/gen/ source/internal-mir/
	rm -rf /tmp/com.garmin.connectiq/
	rm -rf ~/.Garmin/ConnectIQ/Devices/$(DEVICE)/APPS/

clean-icons: ## Remove generated icons and stamp — forces regeneration on next build
	@echo "Cleaning icons..."
	rm -rf icon-*
	rm -f $(ICON_STAMP)

clean-logos: ## Remove generated colored logos and stamp — forces regeneration on next build
	@echo "Cleaning logos..."
	rm -f ./resources/drawables/vav-logo-*.svg
	rm -f $(LOGO_STAMP)

clean-all: clean-storage clean-icons clean-logos ## Remove everything — artifacts, storage, icons and logos

# ─── Compound targets ────────────────────────────────────────────────────────

# fresh regenerates icons+logos BEFORE building
fresh: clean-all icons logos build run ## Clean everything, regenerate icons/logos, rebuild and run

# ─── Export ──────────────────────────────────────────────────────────────────

$(OUTPUT_DIR)/$(APP_NAME).iq: $(ICON_STAMP) $(LOGO_STAMP) $(shell find source -name "*.mc") $(shell find resources -type f) monkey.jungle manifest.xml
	@mkdir -p $(OUTPUT_DIR)
	find . -name "$(APP_NAME).iq" -delete
	java -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true \
		-jar $(BIN_DIR)/monkeybrains.jar \
		-o $(OUTPUT_DIR)/$(APP_NAME).iq \
		-f monkey.jungle -y $(KEY) -e -r -w

export: clean-all icons logos $(OUTPUT_DIR)/$(APP_NAME).iq ## Build release .iq for all devices
	@echo "Export complete: $(OUTPUT_DIR)/$(APP_NAME).iq"