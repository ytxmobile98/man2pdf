MAN2PDF := man2pdf

BASH_DIR := src/bash
MAN2PDF_EXEC := man2pdf.sh

ifeq ($(shell whoami),root)
INSTALL_DIR := /usr/local/bin
SHARE_DIR := /usr/local/share/$(MAN2PDF)
else
USER := $(shell whoami)
INSTALL_DIR := /home/$(USER)/bin
SHARE_DIR := /home/$(USER)/.local/share/$(MAN2PDF)
$(info To install $(MAN2PDF) for current user, please ensure that the directory "$(INSTALL_DIR)" exists and is in $$PATH.)
endif

.PHONY: all
all: help

.PHONY: help
help:
	@echo "[MAN2PDF]"
	@echo ""
	@echo "- \`make install\` / \`make uninstall\`: Install / uninstall for current user only."
	@echo "- \`sudo make install\` / \`sudo make uninstall\`: Install / uninstall for all users."

.PHONY: install
install: $(INSTALL_DIR) $(SHARE_DIR)
	@cp -rv "$(BASH_DIR)"/* "$(SHARE_DIR)"
	@ln -rsfv "$(SHARE_DIR)/$(MAN2PDF_EXEC)" "$(INSTALL_DIR)/$(MAN2PDF)"

.PHONY: uninstall
uninstall:
	@-rm -fv "$(INSTALL_DIR)/$(MAN2PDF)"
	@-rm -rfv "$(SHARE_DIR)"

$(INSTALL_DIR) $(SHARE_DIR):
	@mkdir -p $@