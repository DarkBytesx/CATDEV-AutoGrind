shared_script '@catnyan/ai_module_fg-obfuscated.lua'
shared_script '@catnyan/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

author 'CATX Auto Grind'
description 'Grind As You Much'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    "@ox_lib/init.lua",
    "config/cfg.lua",
    "config/cfg.job.lua",
}

server_scripts {
    "config/function/cfg.function_sv.lua",
    "config/cfg.job_sv.lua",
    "core/server.lua"
}

client_scripts {
    "config/function/cfg.function_cl.lua",
    "core/ultil.lua",
    "core/client.lua"
}

ui_page 'interface/ui.html'

files {
	'interface/**',
}