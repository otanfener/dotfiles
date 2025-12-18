#!/bin/bash

TEMPLATE_DIR="${HOME}/.note-templates"
EDITOR_CMD="${EDITOR:-vim}"

function _note() {
	if [[ -z "$1" ]]; then
		echo "Usage: note <note-name> [template-name]"
		echo
		echo "Creates a new note using the specified template."
		echo
		echo "Arguments:"
		echo "  <note-name>       Name of the note (will create <note-name>.md)"
		echo "  [template-name]   Optional template name (default: default)"
		echo
		echo "Available templates:"
		for file in "$TEMPLATE_DIR"/*.md; do
			[[ -f "$file" ]] && echo "  - $(basename "${file%.md}")"
		done
		return 0
	fi

	local note_name="$1"
	local template_name="${2:-default}"
	local file_name="${note_name}.md"
	local date=$(date +%Y-%m-%d)
	local timestamp=$(date +%Y%m%d%H%M)
	local template_file="${TEMPLATE_DIR}/${template_name}.md"

	if [[ -f "$file_name" ]]; then
		echo "Error: '$file_name' already exists"
		return 1
	fi

	if [[ ! -f "$template_file" ]]; then
		echo "Error: Template '$template_name' not found in $TEMPLATE_DIR"
		return 1
	fi

	sed \
		-e "s/{{TITLE}}/${note_name}/g" \
		-e "s/{{DATE}}/${date}/g" \
		-e "s/{{TIMESTAMP}}/${timestamp}/g" \
		"$template_file" >"$file_name"

	$EDITOR_CMD "$file_name"
}
