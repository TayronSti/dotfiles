if status is-interactive
    fastfetch
end

# prompt look

function fish_prompt

	set_color normal
	printf '[ '

	set_color '#756c63'
	printf '%s' $USER
	
	set_color normal
	printf '@%s ] > ' $hostname
end

# greeting

function fish_greeting
	printf '\n'

	set_color normal
	printf '[ BUNKER SYSTEM // OPERATOR INTERFACE '

	set_color green
	printf 'ONLINE'

	set_color normal
	printf ' ]'
	
	printf '\n'
end
