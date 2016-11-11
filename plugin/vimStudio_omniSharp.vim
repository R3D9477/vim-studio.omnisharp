if exists("g:vimStudio_omniSharp_init")
	if g:vimStudio_omniSharp_init == 1
		finish
	endif
endif

let g:vimStudio_omniSharp_init = 1

"-------------------------------------------------------------------------

let g:vimStudio_omniSharp#plugin_dir = expand("<sfile>:p:h:h")

let g:vimStudio_omniSharp#is_valid_project = 0

let g:vimStudio_omniSharp#workdir = ""
let g:vimStudio_omniSharp#compiler = ""
let g:vimStudio_omniSharp#activeConfig = ""
let g:vimStudio_omniSharp#applicationType = ""

"-------------------------------------------------------------------------

function! vimStudio_omniSharp#set_buffer_settings()
	if g:vimStudio_omniSharp#is_valid_project == 1
		let vaxe_configured = 0
		
		if exists("b:vaxe_configured")
			let vaxe_configured = b:vaxe_configured
		endif
		
		if vaxe_configured == 0
			let &l:makeprg = "cd " . g:vimStudio_omniSharp#workdir . " && " . g:vimStudio_omniSharp#compiler . " &&"
			mkview
			let b:vaxe_configured = 1
		endif
	endif
endfunction

autocmd BufEnter ?* : call vimStudio_omniSharp#set_buffer_settings()

"-------------------------------------------------------------------------

function! vimStudio_omniSharp#on_project_before_open()
	let g:vimStudio_omniSharp#is_valid_project = 0
	
	let g:vimStudio_omniSharp#workdir = ""
	let g:vimStudio_omniSharp#compiler = ""
	let g:vimStudio_omniSharp#activeConfig = ""
	let g:vimStudio_omniSharp#applicationType = ""
	
	let projectType = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"vimStudio"', '"projectType"'])
	
	if projectType == "omniSharp"
		let g:vimStudio_omniSharp#compiler = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"omniSharp"', '"compiler"'])
		
		if len(g:vimStudio_omniSharp#compiler) > 0
			let g:vimStudio_omniSharp#activeConfig = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"omniSharp"', '"activeConfig"'])
			let g:vimStudio_omniSharp#applicationType = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"omniSharp"', '"applicationType"'])
			
			"...
			"...
			"...
			
			let g:OmniSharp_host = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"omniSharp"', '"host"'])
			let g:OmniSharp_timeout = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"omniSharp"', '"timeout"'])
			let vimStudio_omniSharp#startServer = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_conf_property", ['"' . g:vimStudio#buf#mask_bufname . '"', '"omniSharp"', '"startServer"'])
			
			if vimStudio_omniSharp#startServer == "1"
				OmniSharpStartServer
			endif
			
			let g:vimStudio_omniSharp#workdir = vimStudio#request(g:vimStudio#plugin_dir, "project", "get_path_by_index", ['"' . g:vimStudio#buf#mask_bufname . '"', 0])
			call vimStudio_omniSharp#set_buffer_settings()
			
			let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
			
			call add(g:vimStudio#integration#context_menu_dir, g:vimStudio_omniSharp#plugin_dir . "/menu")
			
			let g:vimStudio_omniSharp#is_valid_project = 1
		endif
	endif
	
	return 1
endfunction

function! vimStudio_omniSharp#on_before_project_close()
	if g:vimStudio_omniSharp#is_valid_project == 1
		let g:vimStudio_omniSharp#is_valid_project = 0
		call remove(g:vimStudio#integration#context_menu_dir, index(g:vimStudio#integration#context_menu_dir, g:vimStudio_omniSharp#plugin_dir . "/menu"))
	endif
	
	return 1
endfunction

"-------------------------------------------------------------------------

function! vimStudio_omniSharp#on_menu_item(menu_id)
	if g:vimStudio_omniSharp#is_valid_project == 1
		if a:menu_id == "omniSharp_build"
			"...
		elseif a:menu_id == "omniSharp_edit_references"
			"...
		
		elseif a:menu_id == "omniSharp_refactor_rename"
			OmniSharpRename
		
		elseif a:menu_id == "omniSharp_goto_definition"
			OmniSharpGotoDefinition
		elseif a:menu_id == "omniSharp_find_implementations"
			OmniSharpFindImplementations
		elseif a:menu_id == "omniSharp_find_type"
			OmniSharpFindType
		elseif a:menu_id == "omniSharp_find_symbol"
			OmniSharpFindSymbol
		elseif a:menu_id == "omniSharp_find_usages"
			OmniSharpFindUsages
		
		elseif a:menu_id == "omniSharp_find_usages"
			OmniSharpFindMembers
		
		elseif a:menu_id == "omniSharp_fix_issue"
			OmniSharpFixIssue
		elseif a:menu_id == "omniSharp_fix_usings"
			OmniSharpFixUsings
		elseif a:menu_id == "omniSharp_type_lookup"
			OmniSharpTypeLookup
		
		elseif a:menu_id == "omniSharp_navigate_up"
			OmniSharpNavigateUp
		elseif a:menu_id == "omniSharp_navigate_down"
			OmniSharpNavigateDown
		
		elseif a:menu_id == "omniSharp_toogle_omniSharp_doc"
			"...
		endif
	endif
	
	return 1
endfunction

"-------------------------------------------------------------------------

call vimStudio#integration#register_module("vimStudio_omniSharp")

call add(g:vimStudio#integration#project_template_dir, g:vimStudio_omniSharp#plugin_dir . "/template/project")
call add(g:vimStudio#integration#file_template_dir, g:vimStudio_omniSharp#plugin_dir . "/template/file")
