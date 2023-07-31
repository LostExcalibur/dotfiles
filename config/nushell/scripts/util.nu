export def count_lines [pattern: string] {
	ls -la $"**/($pattern)" | get name | each { |it| wc -l $it | split row " " | get 0 | into int } | reduce { |it, acc| $acc + $it }
}

export def commit [--message (-m): string] {
	let has_fetched = (git fetch | str length) != 0;
	if ($has_fetched) {
		"Changes have been made upstream, prevented commit"
	} else {
		git commit -m $message
	}
}
