function pvc
	python3 -m venv .venv
end

function pva
	# TODO this probably doesn't work as activate would be bash
    source .venv/bin/activate
end

set -x PYTHONSTARTUP ~/.pythonrc
