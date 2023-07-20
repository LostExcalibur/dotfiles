# Nushell Environment Config File
#
# version = 0.78.0

export def local_ip [] {
	let interfaces = (ip -4 -j a  | from json | where ifname != 'lo') 
	if (($interfaces | length) > 0) {
		(if ($interfaces | where ifname !~ 'en' | length) > 0 {
			$interfaces | where ifname !~ 'en'
		} else {
			$interfaces
		}) | get addr_info | flatten | get local.0
	} else {
		"not connected"
	}
}

let-env BROWSER = "firefox"
let-env EDITOR = "vim"
let-env PAGER = "less"
 
def create_left_prompt [] {
    let hostname = (hostname | split row '.' | first | str trim)
    
	mut usr_str = $"(ansi -e {bg: '#e4e4e4' fg:'#080808'})"
	$usr_str = ([$usr_str $env.USER '@' $hostname ' ' (ansi reset)] | str join)

    let home = $env.HOME

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace -s $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_color = if (is-admin) {
        $"(ansi red_bold)"
    } else {
        $"(ansi -e {bg: '#1d99f3' fg: '#e4e4e4'})"
    }

	let path_segment = ( [ $path_color (char -u 'e0b0') (ansi -e {fg: '#ffffff'}) ' ' (char nf_folder1) '  ' ($dir) ] | str join)

	let end_segment  = ( [ (ansi reset) (ansi -e {fg: '#1d99f3'}) (char -u 'e0b0') ] | str join)

    [$usr_str $path_segment ' ' $end_segment ' '] | str join
}

def create_right_prompt [] {
    let corner_segment_1 = ( [ (ansi reset) (ansi -e {fg: '#4e9a06'}) (char -u 'e0b2') ] | str join)
	
	let ip_segment = ( [ (ansi -e {bg: '#4e9a06' fg: '#e4e4e4'}) ' ' (local_ip) ] | str join)

	let corner_segment_2 = ( [ (char -u 'e0b2' ) ] | str join ) 

	let time_segment = ([ (ansi -e {bg: '#e4e4e4' fg:'#080808'}) ' ' (date now | date format '%R:%S ') ] | str join)
	

    [ $corner_segment_1 $ip_segment ' ' $corner_segment_2 $time_segment ] | str join
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = {|| create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = {|| "" }
let-env PROMPT_INDICATOR_VI_INSERT = {|| ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
let-env PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
let-env PATH = ($env.PATH | split row (char esep) | prepend '/home/romain/.opam/default/bin')
let-env PATH = ($env.PATH | split row (char esep) | prepend '/home/romain/.local/bin')

let-env OCAML_TOPLEVEL_PATH = '/home/romain/.opam/default/lib/toplevel'
let-env OPAM_SWITCH_PREFIX = '/home/romain/.opam/default'
let-env CAML_LD_LIBRARY_PATH = '/home/romain/.opam/default/lib/stublibs:/usr/lib/ocaml/stublibs:/usr/lib/ocaml'
