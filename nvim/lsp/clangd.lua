return {
	cmd = { 'clangd' },
	init_options = {
		fallbackFlags = { "-std=c++20" },
	},
	root_markers = { '.clangd', 'compile_commands.json' },
	filetypes = { 'c', 'cpp', 'h', 'hpp', 'cxx' },
}
