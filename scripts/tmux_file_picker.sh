#!/usr/bin/env bash

set -euo pipefail


main() {
	if [[ -z "${TMUX-}" ]]; then
		echo "Error: This script must be run inside a tmux session." >&2

		exit 1
	fi

	local pane_id="${TMUX_PANE}"
	local pane_dir
	local pane_pid

	pane_dir=$(tmux display-message -p -t "$pane_id" '#{pane_current_path}')
	pane_pid=$(tmux display-message -p -t "$pane_id" '#{pane_pid}')

	local use_git_root=false
	local dir_only=false
	local path_arg=""

	while [[ $# -gt 0 ]]; do
		case "$1" in
			--git-root|-g)
				use_git_root=true
				shift
				;;
			-*)
				echo "Error: Unknown option '$1'" >&2

				exit 1
				;;
			*)
				if [[ -n "$path_arg" ]]; then
					echo "Error: Only one path argument is allowed." >&2

					exit 1
				fi

				path_arg="$1"

				shift
				;;
		esac
	done

	local at_prefix_mode=false

	if pgrep -P "$pane_pid" -f ".*claude.*|node.*gemini|codex" >/dev/null; then
		at_prefix_mode=true
	fi

	local git_root

	git_root=$(cd "$pane_dir" && git rev-parse --show-toplevel 2>/dev/null || true)

	if $use_git_root && [[ -z "$git_root" ]]; then
		echo "Error: --git-root flag used, but not inside a git repository." >&2

		exit 1
	fi

	local search_dir

	if $use_git_root; then
		search_dir="$git_root"
	else
		search_dir="${path_arg:-$pane_dir}"

		if [[ ! "$search_dir" = /* ]]; then
			search_dir="$pane_dir/$search_dir"
		fi

		local realpath_cmd="realpath"
		[[ "$OSTYPE" == "darwin"* ]] && realpath_cmd="grealpath"

		if command -v "$realpath_cmd" >/dev/null 2>&1; then
			search_dir=$("$realpath_cmd" -m "$search_dir")
		fi
	fi

	if [[ ! -d "$search_dir" ]]; then
		echo "Error: Directory '$search_dir' does not exist." >&2

		exit 1
	fi


	local fd_cmd
	if command -v fd >/dev/null 2>&1; then
		fd_cmd="fd"
	elif command -v fdfind >/dev/null 2>&1; then
		fd_cmd="fdfind"
	else
		echo "Error: Required command 'fd' or 'fdfind' not found. Please install it." >&2

		exit 1
	fi

	local preview_cmd="cat {}"

	if command -v bat >/dev/null 2>&1; then
		preview_cmd="bat -f --style=numbers --theme=base16 {}"
	elif command -v batcat >/dev/null 2>&1; then
		preview_cmd="batcat -f --style=numbers --theme=base16 {}"
	fi

	local fd_flags="${TMUX_FILE_PICKER_FD_FLAGS:--H --type f --exclude .git}"

	local selected_files_str

	selected_files_str=$(cd "$search_dir" && $fd_cmd $fd_flags | fzf --multi --reverse --preview "$preview_cmd" --preview-window 'right:50%:wrap' --bind 'ctrl-/:toggle-preview' --no-border || true)

	if [[ -z "$selected_files_str" ]]; then
		exit 0
	fi

	selected_files=()

	while IFS= read -r line; do
		if [[ -n "$line" ]]; then
			selected_files+=("$line")
		fi
	done <<<"$selected_files_str"

	local relative_paths=()
	local base_dir_for_relativization=""

	if $use_git_root; then
		base_dir_for_relativization="$git_root"
	elif [[ "$search_dir" != "$pane_dir" ]]; then
		base_dir_for_relativization="$pane_dir"
	fi

	if [[ -n "$base_dir_for_relativization" ]]; then
		local realpath_cmd="realpath"

		[[ "$OSTYPE" == "darwin"* ]] && realpath_cmd="grealpath"

		local full_paths=("${selected_files[@]/#/$search_dir\/}")

		while IFS= read -r line; do
			if [[ -n "$line" ]]; then
				relative_paths+=("$line")
			fi
		done < <("$realpath_cmd" --relative-to="$base_dir_for_relativization" "${full_paths[@]}")
	else
		relative_paths=("${selected_files[@]}")
	fi

	local files_oneline

	if $at_prefix_mode; then
		printf -v files_oneline "@%s " "${relative_paths[@]}"
	else
		local escaped_paths=()

		for path in "${relative_paths[@]}"; do
			printf -v escaped_path "%q" "$path"

			escaped_paths+=("$escaped_path")
		done

		files_oneline=$(printf "%s " "${escaped_paths[@]}")
	fi

	tmux send-keys -t "$pane_id" "$files_oneline"
}

main "$@"
