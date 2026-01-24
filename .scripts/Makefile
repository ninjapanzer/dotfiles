.PHONY: test test-setup test-clean

test: test-setup
	./.test/bats/bats/bin/bats *.bats

test-setup:
	@if [ ! -d "./.test/bats/bats" ]; then \
		bash install-bats-libs.sh; \
	fi

test-clean:
	bash clean-bats.sh
