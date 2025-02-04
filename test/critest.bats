#!/usr/bin/env bats

load helpers

function setup() {
	if [[ -z $RUN_CRITEST ]]; then
		skip "critest because RUN_CRITEST is not set"
	fi

	export CONTAINER_SECCOMP_USE_DEFAULT_WHEN_EMPTY=false
	setup_test
	start_crio
}

function teardown() {
	cleanup_test
}

@test "run the critest suite" {
	critest --parallel 8 \
		--runtime-endpoint "unix://${CRIO_SOCKET}" \
		--image-endpoint "unix://${CRIO_SOCKET}" \
		--ginkgo.focus="${CRI_FOCUS}" \
		--ginkgo.skip="${CRI_SKIP}" \
		--ginkgo.flakeAttempts=3 >&3
}
