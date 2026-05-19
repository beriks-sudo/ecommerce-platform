.DEFAULT_GOAL := help

.PHONY: help status log diff check

help:
	@echo "make help    Show available commands"
	@echo "make status  Show short repository status"
	@echo "make log     Show recent history"
	@echo "make diff    Show whitespace errors and diff summary"
	@echo "make check   Run basic Git checks"

status:
	git status --short

log:
	git log --oneline --decorate -5

diff:
	git diff --check
	git diff --stat

check:
	git status --short
	git diff --check

.DEFAULT:
	@echo "Unknown target '$@'. Available targets:"
	@$(MAKE) --no-print-directory help
	@exit 1

history:
	git log --oneline --decorate -5